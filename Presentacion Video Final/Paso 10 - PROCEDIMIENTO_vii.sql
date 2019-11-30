/*

Crear un procedimiento que reciba el ID de una APUESTA (Las que efectuan los usuarios)
y reciba: id_usuario, valor, tipo_apuesta_id, cuota, opción ganadora (Ya cada uno mirará como manejan esta parte conforme al diseño que tengan). 
Con estos parámetros deberá insertar un registro en la tabla detalles de apuesta en estado "ABIERTA".

*/
--select * from tipos_apuestas;
CREATE OR REPLACE PROCEDURE sp_crear_detalle_apuestas (
    p_id_apuesta                   detalle_apuesta.id_apuesta%TYPE,
    p_id_tipo_apuesta               detalle_apuesta.id_tipo_apuesta%TYPE,
    p_opcion_equipo1                detalle_apuesta.opcion_equipo1%TYPE:=NULL,
    p_opcion_equipo2                detalle_apuesta.opcion_equipo2%TYPE:=NULL,
    p_opcion_empate                 detalle_apuesta.opcion_empate%TYPE:=NULL,
    p_opcion_si                     detalle_apuesta.opcion_si%TYPE:=NULL,
    p_opcion_no                     detalle_apuesta.opcion_no%TYPE:=NULL,
    p_opcion_mas                    detalle_apuesta.opcion_mas%TYPE:=NULL,
    p_opcion_menos                  detalle_apuesta.opcion_menos%TYPE:=NULL,
    p_valor_apostado                detalle_apuesta.valor_apostado%TYPE:=NULL,
    p_valor_ganado                  detalle_apuesta.valor_ganado%TYPE:=NULL,
    p_porcentaje_equipo1_apostado   detalle_apuesta.porcentaje_equipo1_apostado%TYPE:=NULL,
    p_porcentaje_equipo2_apostado   detalle_apuesta.porcentaje_equipo2_apostado%TYPE:=NULL,
    p_porcentaje_empate_apostado    detalle_apuesta.porcentaje_empate_apostado%TYPE:=NULL,
    p_porcentaje_si_apostado        detalle_apuesta.porcentaje_si_apostado%TYPE:=NULL,
    p_porcentaje_no_apostado        detalle_apuesta.porcentaje_no_apostado%TYPE:=NULL,
    p_porcentaje_mas_apostado       detalle_apuesta.porcentaje_mas_apostado%TYPE:=NULL,
    p_porcentaje_menos_apostado     detalle_apuesta.porcentaje_menos_apostado%TYPE
) IS
    id_apuestas detalle_apuesta.id_apuesta%TYPE;
BEGIN
    SELECT
        id
    INTO id_apuestas
    FROM
        detalle_apuesta
    WHERE
        id_apuesta = p_id_apuesta;

    INSERT INTO detalle_apuesta (
        id_apuesta,
        id_tipo_apuesta,
        opcion_equipo1,
        opcion_equipo2,
        opcion_empate,
        opcion_si,
        opcion_no,
        opcion_mas,
        opcion_menos,
        valor_apostado,
        valor_ganado,
        porcentaje_equipo1_apostado,
        porcentaje_equipo2_apostado,
        porcentaje_empate_apostado,
        porcentaje_si_apostado,
        porcentaje_no_apostado,
        porcentaje_mas_apostado,
        porcentaje_menos_apostado,
        registro_activo,
        estado
    ) VALUES (
        p_id_apuesta,
        p_id_tipo_apuesta,
        p_opcion_equipo1,
        p_opcion_equipo2,
        p_opcion_empate,
        p_opcion_si,
        p_opcion_no,
        p_opcion_mas,
        p_opcion_menos,
        p_valor_apostado,
        p_valor_ganado,
        p_porcentaje_equipo1_apostado,
        p_porcentaje_equipo2_apostado,
        p_porcentaje_empate_apostado,
        p_porcentaje_si_apostado,
        p_porcentaje_no_apostado,
        p_porcentaje_mas_apostado,
        p_porcentaje_menos_apostado,
        'Y',
        'ABIERTA'
    );

EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20001, 'APUESTA NO EXISTE');
END;

/*
select * from apuestas;
select * from usuarios;
select  * from tipos_apuestas;
select * from detalle_apuesta;
*/
/*
execute sp_crear_detalle_apuestas(2,3,'N', 'N', 'N','Y','N','N','N',21000,0,0,0 ,0, 4, 0,0,0);
       
/*