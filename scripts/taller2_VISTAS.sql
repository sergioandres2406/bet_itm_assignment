/*
Sumar el valor ganado de todas las apuestas de los 
usuarios que están en estado ganado de aquellos 
partidos asociados a las apuestas que se efectuaron 
en el trancurso de la semana y mostrarlas ordenadas 
por el valor más alto; El nombre de la vista será 
"GANADORES_SEMANALES" 
y tendrá dos columnas: nombre completo y valor acumulado.


Considerar el siguiente query 
select trunc(sysdate, 'DAY') 
start_of_the_week, trunc(sysdate, 'DAY')+6 
end_of_the_week from dual;
*/
SELECT
    trunc(sysdate, 'DAY') start_of_the_week,
    trunc(sysdate, 'DAY') + 6 end_of_the_week
FROM
    dual;

SELECT
    u.nombre1
    || ' '
    || u.nombre2
    || ' '
    || u.apellido1
    || ' '
    || u.apellido2 AS nombre,
    SUM(nvl(a.total_ganado, 0)) valor_ganado
FROM
    usuarios   u
    INNER JOIN apuestas   a ON u.id = a.id_usuario
WHERE
    a.fecha_apuesta BETWEEN trunc(sysdate, 'DAY') AND trunc(sysdate, 'DAY') + 6
GROUP BY
    u.nombre1
    || ' '
    || u.nombre2
    || ' '
    || u.apellido1
    || ' '
    || u.apellido2
ORDER BY
    nombre;

/*  VISTA 1 */

CREATE OR REPLACE VIEW v_ganadores_semanales AS
    SELECT
        u.nombre1
        || ' '
        || u.nombre2
        || ' '
        || u.apellido1
        || ' '
        || u.apellido2 AS nombre,
        SUM(nvl(a.total_ganado, 0)) valor_ganado
    FROM
        usuarios   u
        INNER JOIN apuestas   a ON u.id = a.id_usuario
    WHERE
        a.fecha_apuesta BETWEEN trunc(sysdate, 'DAY') AND trunc(sysdate, 'DAY') + 6
    GROUP BY
        u.nombre1
        || ' '
        || u.nombre2
        || ' '
        || u.apellido1
        || ' '
        || u.apellido2
    ORDER BY
        SUM(nvl(a.total_ganado, 0)) DESC;

SELECT
    *
FROM
    ganadores_semanales;


/*   VISTA 2*/ 

/* Nombre de la vista: DETALLES_APUESTAS. Esta vista deberá mostrar todos los 
detalles de apuestas simples que se efectuaron para un boleto en particular, 
tal como se muestra en el siguiente ejemplo:

detalles_apuestas.

La idea es que cuando se llame la vista se pueda pasar el id de la apuesta para que muestre los detalles de ese boleto en particular,
ejemplo: SELECT * FROM DETALLES_APUESTAS WHERE APUESTAS.ID = 123
*/

CREATE OR REPLACE VIEW v_detalles_apuestas AS
    SELECT
        da.id_apuesta       id,
        cp.estado           estado_partido,
        to_date(to_char(cp.fecha, 'MM/DD/YYYY'), 'MM/DD/YYYY') fecha_partido,
        to_char(cp.fecha, 'HH:MI:SS') hora,
        e1.nombre
        || ' - '
        || e2.nombre partido,
        ta.tipo_apuesta     tipo_apuesta,
        CASE
            WHEN da.porcentaje_equipo1_apostado IS NOT NULL THEN
                da.porcentaje_equipo1_apostado
            WHEN da.porcentaje_equipo2_apostado IS NOT NULL THEN
                da.porcentaje_equipo2_apostado
            WHEN da.porcentaje_empate_apostado IS NOT NULL THEN
                da.porcentaje_empate_apostado
            WHEN da.porcentaje_si_apostado IS NOT NULL THEN
                da.porcentaje_si_apostado
            WHEN da.porcentaje_no_apostado IS NOT NULL THEN
                da.porcentaje_no_apostado
            WHEN da.porcentaje_mas_apostado IS NOT NULL THEN
                da.porcentaje_mas_apostado
            WHEN da.porcentaje_menos_apostado IS NOT NULL THEN
                da.porcentaje_menos_apostado
        END porcentaje,
        nvl(cp.goles_equipo1, '0')
        || ':'
        || nvl(cp.goles_equipo2, '0') marcador,
        CASE
            WHEN da.valor_ganado = 0 THEN
                'PERDIO'
            WHEN da.valor_ganado IS NULL THEN
                'PENDIENTE'
            ELSE
                'GANADA'
        END estado,
        da.valor_apostado   valor_apostado
    FROM
        detalle_apuesta       da
        INNER JOIN tipos_apuestas        ta ON da.id_tipo_apuesta = ta.id
        INNER JOIN cronograma_partidos   cp ON ta.id_cronograma = cp.id
        INNER JOIN equipos               e1 ON cp.id_equipo1 = e1.id
        INNER JOIN equipos               e2 ON cp.id_equipo2 = e2.id;



/*
VISTA 3 
Nombre de la vista: RESUMEN_APUESTAS. Esta vista mostrará el resumen de cada apuesta efectuada en el sistema, la información de la siguiente imagen 
corresponderá a cada columna (Omitir la siguiente columna Pago máx. incl. 5% bono (293.517,58 $)). La idea es que cuando se llame la vista, 
muestre la información únicamente de esa apuesta en particular: SELECT * FROM RESUMEN_APUESTAS WHERE APUESTAS.ID = 123.
*/

CREATE OR REPLACE VIEW v_resumen_apuestas AS
    SELECT
        id_apuesta id,
        COUNT(*) numero_apuestas,
        SUM(valor_apostado) total_valor_apostado,
        MAX(
            CASE
                WHEN da.porcentaje_equipo1_apostado IS NOT NULL THEN
                    da.porcentaje_equipo1_apostado
                WHEN da.porcentaje_equipo2_apostado IS NOT NULL THEN
                    da.porcentaje_equipo2_apostado
                WHEN da.porcentaje_empate_apostado IS NOT NULL THEN
                    da.porcentaje_empate_apostado
                WHEN da.porcentaje_si_apostado IS NOT NULL THEN
                    da.porcentaje_si_apostado
                WHEN da.porcentaje_no_apostado IS NOT NULL THEN
                    da.porcentaje_no_apostado
                WHEN da.porcentaje_mas_apostado IS NOT NULL THEN
                    da.porcentaje_mas_apostado
                WHEN da.porcentaje_menos_apostado IS NOT NULL THEN
                    da.porcentaje_menos_apostado
                ELSE
                    0
            END
        ) cuota_maxima,
        SUM(da.valor_ganado) total_valor_ganado
    FROM
        detalle_apuesta da
    GROUP BY
        id_apuesta;


/*
VISTA 4 
Para la siguiente vista deberán alterar el manejo de sesiones de usuario, el sistema deberá guardar el timestamp de la hora de sesión y el timestamp del 
fin de sesión, si el usuario tiene el campo fin de sesión en null, significa que la sesión está activa. Crear una vista que traiga las personas que tienen
una sesión activa, ordenado por la hora de inicio de sesión, mostrando las personas que más tiempo llevan activas; adicional, deberá tener una columna
que calcule cuántas horas lleva en el sistema con respecto a la hora actual, la siguiente columna será la cantidad de horas seleccionada 
en las preferencias de usuario, finalmente, habrá una columna que reste cuánto tiempo le falta para que se cierre la sesión (si aparece
un valor negativo, significa que el usuario excedió el tiempo en el sistema)
*/

CREATE OR REPLACE FUNCTION f_diferencia_horas (
    hora_actual   TIMESTAMP,
    hora_inicio   TIMESTAMP
) RETURN NUMBER AS
    dias_transcurridos    NUMBER;
    horas_transcurridas   NUMBER;
    diferencia_horas      INTERVAL DAY TO SECOND;
    horas_totales         NUMBER;
BEGIN
    diferencia_horas := hora_actual - hora_inicio;
    dias_transcurridos := extract(DAY FROM diferencia_horas);
    horas_transcurridas := extract(HOUR FROM diferencia_horas);
    horas_totales := ( ( dias_transcurridos * 24 ) + horas_transcurridas );
    RETURN horas_totales;
END;


CREATE OR REPLACE VIEW V_SESIONES_ACTIVAS
AS

SELECT S.ID id_sesion,u.id id_usuario,f_diferencia_horas(sysdate,s.FECHA_INICIO_SESION) horas_transcurridas,lb.TIEMPO_CERRAR_SESION HORAS_CERRAR_SESSION ,lb.TIEMPO_CERRAR_SESION-f_diferencia_horas(sysdate,s.FECHA_INICIO_SESION)
DIFERENCIA_HORAS
FROM USUARIOS U inner JOIN sesiones S ON u.id=s.id_usuario
inner join limites_bloqueos lb on u.id=lb.id_usuario
where s.fecha_fin_sesion is null AND s.registro_activo='Y' order by  s.FECHA_INICIO_SESION,f_diferencia_horas(sysdate,s.FECHA_INICIO_SESION)desc
;







