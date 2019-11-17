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

select trunc(sysdate, 'DAY') start_of_the_week, trunc(sysdate, 'DAY')+6 end_of_the_week from dual;

SELECT  u.nombre1 ||' '||u.nombre2||' '||u.apellido1||' '||u.apellido2 as Nombre,Sum( NVL(a.total_ganado,0)) VALOR_GANADO FROM USUARIOS U INNER JOIN APUESTAS A ON U.ID= a.id_usuario
WHERE a.fecha_apuesta between trunc(sysdate, 'DAY') and trunc(sysdate, 'DAY')+6
group by u.nombre1 ||' '||u.nombre2||' '||u.apellido1||' '||u.apellido2
order by Nombre
;

/*  VISTA 1 */
CREATE OR REPLACE VIEW GANADORES_SEMANALES 
 AS SELECT  u.nombre1 ||' '||u.nombre2||' '||u.apellido1||' '||u.apellido2 as Nombre,Sum( NVL(a.total_ganado,0)) VALOR_GANADO FROM USUARIOS U INNER JOIN APUESTAS A ON U.ID= a.id_usuario
WHERE a.fecha_apuesta between trunc(sysdate, 'DAY') and trunc(sysdate, 'DAY')+6
group by u.nombre1 ||' '||u.nombre2||' '||u.apellido1||' '||u.apellido2
order by Sum( NVL(a.total_ganado,0)) DESC;

SELECT * FROM GANADORES_SEMANALES;


/*   VISTA 2*/ 

/* Nombre de la vista: DETALLES_APUESTAS. Esta vista deberá mostrar todos los 
detalles de apuestas simples que se efectuaron para un boleto en particular, 
tal como se muestra en el siguiente ejemplo:

detalles_apuestas.

La idea es que cuando se llame la vista se pueda pasar el id de la apuesta para que muestre los detalles de ese boleto en particular,
ejemplo: SELECT * FROM DETALLES_APUESTAS WHERE APUESTAS.ID = 123
*/

CREATE OR REPLACE VIEW DETALLES_APUESTAS
AS
SELECT da.id_apuesta ID,cp.estado Estado_Partido,TO_DATE(cp.fecha) Fecha_Partido, TO_CHAR(cp.fecha,'HH:MI:SS') HORA,
e1.nombre ||'-'||e2.nombre PARTIDO, ta.tipo_apuesta TIPO_APUESTA,
CASE WHEN da.porcentaje_equipo1_apostado is NOT null then da.porcentaje_equipo1_apostado
WHEN da.porcentaje_equipo2_apostado is NOT null then da.porcentaje_equipo2_apostado
WHEN da.porcentaje_empate_apostado is NOT null then da.porcentaje_empate_apostado
WHEN da.porcentaje_si_apostado  is NOT null then da.porcentaje_si_apostado
WHEN da.porcentaje_no_apostado  is NOT null then da.porcentaje_no_apostado
WHEN da.porcentaje_mas_apostado  is not null then da.porcentaje_mas_apostado
WHEN da.porcentaje_menos_apostado  is not null then da.porcentaje_menos_apostado end PORCENTAJE,
NVL(cp.goles_equipo1,'0')||':'||NVL(cp.goles_equipo2,'0') MARCADOR,
CASE WHEN da.valor_ganado=0 then 'PERDIO' WHEN da.valor_ganado is null then 'PENDIENTE' ELSE 'GANADA' END ESTADO,da.valor_apostado VALOR_APOSTADO
FROM detalle_apuesta da inner join tipos_apuestas ta on 
da.id_tipo_apuesta=ta.id inner join cronograma_partidos cp on ta.id_cronograma=cp.id
inner join equipos e1 on cp.id_equipo1=e1.id
inner join equipos e2 on cp.id_equipo2=e2.id


/*
VISTA 3 
Nombre de la vista: RESUMEN_APUESTAS. Esta vista mostrará el resumen de cada apuesta efectuada en el sistema, la información de la siguiente imagen 
corresponderá a cada columna (Omitir la siguiente columna Pago máx. incl. 5% bono (293.517,58 $)). La idea es que cuando se llame la vista, 
muestre la información únicamente de esa apuesta en particular: SELECT * FROM RESUMEN_APUESTAS WHERE APUESTAS.ID = 123.
*/ 

CREATE OR REPLACE VIEW RESUMEN_APUESTAS
AS
SELECT ID_APUESTA ID ,COUNT (*) NUMERO_APUESTAS, SUM(valor_apostado) TOTAL_VALOR APOSTADO,
MAX(CASE WHEN da.porcentaje_equipo1_apostado is NOT null then da.porcentaje_equipo1_apostado
WHEN da.porcentaje_equipo2_apostado is NOT null then da.porcentaje_equipo2_apostado
WHEN da.porcentaje_empate_apostado is NOT null then da.porcentaje_empate_apostado
WHEN da.porcentaje_si_apostado  is NOT null then da.porcentaje_si_apostado
WHEN da.porcentaje_no_apostado  is NOT null then da.porcentaje_no_apostado
WHEN da.porcentaje_mas_apostado  is not null then da.porcentaje_mas_apostado
WHEN da.porcentaje_menos_apostado  is not null then da.porcentaje_menos_apostado ELSE  0 end) CUOTA_MAXIMA
FROM  detalle_apuestas da
WHERE 
