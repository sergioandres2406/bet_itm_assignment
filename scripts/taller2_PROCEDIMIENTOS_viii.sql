/***** ESTE SP  VALIDA TODA LA LÓGICA CUANDO UN PARTIDO HA FINALIZADO.  
-VALIDA  QUE EFECTIVAMENTE EL PARTIDO ESTÉ FINALIZADO EN LA TABLA CRONOGRAMAS,
-FINALIZA TODOS LOS TIPOS DE APUESTAS RELACIONADAS AL PARTIDO QUE TERMINÓ,  EN LA TABLA TIPOS_APUESTAS.
-VALIDA CADA APUESTA RELACIONADA A LOS TIPOS DE APUESTA QUE HACEN REFERENCIA AL PARTIDO QUE FINALIZÓ  EN LA 
    TABLA  DETALLE_APUESTAS.  VALIDA SI LA APUESTA GANÓ O PERDIÓ,  PONE EN GANADA  O PERDIDA LA APUESTA, ADICIONAL HACE LOS CÁLCULOS 
    DEL VALOR GANADO, TENIENDO COMO REFERENCIA EL PORCENTAJE  O CUOTA,   MULTIPLICADO POR EL VALOR APOSTADO, Y LLEVÁNDO DICHO CÁLCULO
    AL CAMPO  VALOR_GANADO  EN CADA REGISTRO DE LA TABLA DETALLE_APUESTAS  CUYO TIPO DE APUESTA ESTÉ RELACIONADO AL PARTIDO FINALIZADO.


***/
CREATE OR REPLACE PROCEDURE PROC_FINALIZA_PARTIDO_CALCULOS (
    id_partido NUMBER, cp_id_equipo1 number,cp_id_equipo2 number,
    cp_equipo_ganador number, cp_goles_equipo1  number,
    cp_goles_equipo2 number,cp_ganador_tiempo1 number, cp_ganador_tiempo2 number,
    cp_goles_tiempo1 number,cp_goles_tiempo2 number,cp_estado varchar2
) IS

    cambio_estado           VARCHAR2(255);
    
   
    ta_id_tipos_apuestas    tipos_apuestas.id%TYPE;
    ta_tipo_apuesta         tipos_apuestas.tipo_apuesta%TYPE;
    ta_id_cronograma        tipos_apuestas.id_cronograma%TYPE;
    da_id_detalle_apuesta   detalle_apuesta.id%TYPE;
    da_id_apuesta           detalle_apuesta.id_apuesta%TYPE;
    da_estado               detalle_apuesta.estado%TYPE;
    da_id_tipo_apuesta      detalle_apuesta.id_tipo_apuesta%TYPE;
    da_opcion_equipo1       detalle_apuesta.opcion_equipo1%TYPE;
    da_opcion_equipo2       detalle_apuesta.opcion_equipo2%TYPE;
    da_opcion_empate        detalle_apuesta.opcion_empate%TYPE;
    da_opcion_si            detalle_apuesta.opcion_si%TYPE;
    da_opcion_no            detalle_apuesta.opcion_no%TYPE;
    da_opcion_mas           detalle_apuesta.opcion_mas%TYPE;
    da_opcion_menos         detalle_apuesta.opcion_menos%TYPE;
    da_porcentaje_equipo1   detalle_apuesta.porcentaje_equipo1_apostado%TYPE;
    da_porcentaje_equipo2   detalle_apuesta.porcentaje_equipo2_apostado%TYPE;
    da_porcentaje_empate    detalle_apuesta.porcentaje_empate_apostado%TYPE;
    da_porcentaje_si        detalle_apuesta.porcentaje_si_apostado%TYPE;
    da_porcentaje_no        detalle_apuesta.porcentaje_no_apostado%TYPE;
    da_porcentaje_mas       detalle_apuesta.porcentaje_mas_apostado%TYPE;
    da_porcentaje_menos     detalle_apuesta.porcentaje_menos_apostado%TYPE;
    da_valor_ganado         detalle_apuesta.valor_ganado%TYPE;
    da_valor_apostado       detalle_apuesta.valor_apostado%TYPE;
    ap_total_ganado         apuestas.total_ganado%TYPE;
    CURSOR tipo_apuestas_partido IS
    SELECT
        id,
        tipo_apuesta,
        id_cronograma
    FROM
        tipos_apuestas
    WHERE
        id_cronograma = id_partido;
       --SELECT id,tipo_apuesta,ID_CRONOGRAMA   FROM tipos_apuestas where id_cronograma = 2;

    CURSOR detalle_apuesta_tipo_apuesta IS
    SELECT
        id,
        id_apuesta,
        id_tipo_apuesta,
        estado,
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
        porcentaje_menos_apostado
    FROM
        detalle_apuesta
    WHERE
        id_tipo_apuesta = ta_id_tipos_apuestas;

BEGIN
    cambio_estado := 'FINALIZADO';
   
    IF cp_estado = 'FINALIZADO' THEN
        UPDATE tipos_apuestas
        SET
            estado = cambio_estado
        WHERE
            id_cronograma = id_partido;

        OPEN tipo_apuestas_partido;
        LOOP
            FETCH tipo_apuestas_partido INTO
                ta_id_tipos_apuestas,
                ta_tipo_apuesta,
                ta_id_cronograma;
            EXIT WHEN tipo_apuestas_partido%notfound;
            IF ta_tipo_apuesta = 'SIMPLE' AND ta_id_cronograma = id_partido THEN
        --select * from tipos_apuestas where  tipo_apuesta = 'SIMPLE' AND  ID_CRONOGRAMA = 2;
                OPEN detalle_apuesta_tipo_apuesta;
                LOOP
                    FETCH detalle_apuesta_tipo_apuesta 
                
                --select * from detalle_apuesta;
                     INTO
                        da_id_detalle_apuesta,
                        da_id_apuesta,
                        da_id_tipo_apuesta,
                        da_estado,
                        da_opcion_equipo1,
                        da_opcion_equipo2,
                        da_opcion_empate,
                        da_opcion_si,
                        da_opcion_no,
                        da_opcion_mas,
                        da_opcion_menos,
                        da_valor_apostado,
                        da_valor_ganado,
                        da_porcentaje_equipo1,
                        da_porcentaje_equipo2,
                        da_porcentaje_empate,
                        da_porcentaje_si,
                        da_porcentaje_no,
                        da_porcentaje_mas,
                        da_porcentaje_menos;

                    SELECT
                        nvl(total_ganado, '0')
                    INTO ap_total_ganado
                    FROM
                        apuestas
                    WHERE
                        id = da_id_apuesta;

                    EXIT WHEN detalle_apuesta_tipo_apuesta%notfound; 
   --select * from tipos_apuestas;
   --select * from detalle_apuesta;
                    IF cp_equipo_ganador = cp_id_equipo1 THEN
                        SELECT
                            nvl(total_ganado, '0')
                        INTO ap_total_ganado
                        FROM
                            apuestas
                        WHERE
                            id = da_id_apuesta;

                        IF da_opcion_equipo1 = 'Y' THEN
                            da_valor_ganado := da_valor_apostado * da_porcentaje_equipo1;
                            UPDATE apuestas
                            SET
                                total_ganado = ap_total_ganado + da_valor_ganado;

                            UPDATE detalle_apuesta
                            SET
                                estado = 'GANADA',
                                valor_apostado = da_valor_apostado,
                                valor_ganado = da_valor_ganado
                            WHERE
                                id = da_id_detalle_apuesta;

                            dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                            dbms_output.put_line('PARTIDO ganado  EQUIPO1 APUESTA SIMPLE VALOR GANADO ' || da_valor_ganado);
                            dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                        ELSE
                            da_valor_ganado := 0;
                            UPDATE detalle_apuesta
                            SET
                                estado = 'PERDIDA',
                                valor_apostado = da_valor_apostado,
                                valor_ganado = da_valor_ganado
                            WHERE
                                id = da_id_detalle_apuesta;

                            dbms_output.put_line('PARTIDO PERDIDO  EQUIPO1 APUESTA SIMPLE  VALOR GANADO' || da_valor_ganado);
                        END IF;

                    ELSE
                        IF cp_equipo_ganador = cp_id_equipo2 THEN
                            IF da_opcion_equipo2 = 'Y' THEN
                                da_valor_ganado := da_valor_apostado * da_porcentaje_equipo2;
                                UPDATE detalle_apuesta
                                SET
                                    estado = 'GANADA',
                                    valor_apostado = da_valor_apostado,
                                    valor_ganado = da_valor_ganado
                                WHERE
                                    id = da_id_detalle_apuesta;

                                dbms_output.put_line('valor ganado PARTIDO EQUIPO2  ' || da_valor_ganado);
                            ELSE
                                da_valor_ganado := 0;
                                UPDATE detalle_apuesta
                                SET
                                    estado = 'PERDIDA',
                                    valor_apostado = da_valor_apostado,
                                    valor_ganado = da_valor_ganado
                                WHERE
                                    id = da_id_detalle_apuesta;

                                dbms_output.put_line('PARTIDO PERDIDO  EQUIPO1 APUESTA SIMPLE  VALOR GANADO' || da_valor_ganado)
                                ;
                            END IF;

                        ELSE
                            IF nvl(cp_equipo_ganador, '0') = 0 THEN
                                IF da_opcion_empate = 'y' THEN
                                    da_valor_ganado := da_valor_apostado * da_porcentaje_empate;
                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'GANADA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('valor ganado PARTIDO EMPATADO  ' || da_valor_ganado);
                                ELSE
                                    da_valor_ganado := 0;
                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'PERDIDA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('PARTIDO PERDIDO  EMPATE  VALOR GANADO' || da_valor_ganado);
                                END IF;

                            END IF;
                        END IF;
                    END IF;

                END LOOP;

                CLOSE detalle_apuesta_tipo_apuesta;
            ELSE
                IF ta_tipo_apuesta = 'MAS/MENOS(0,5)' AND ta_id_cronograma = id_partido THEN
                    OPEN detalle_apuesta_tipo_apuesta;
                    LOOP
                        FETCH detalle_apuesta_tipo_apuesta 
                
                --select * from detalle_apuesta;
                         INTO
                            da_id_detalle_apuesta,
                            da_id_apuesta,
                            da_id_tipo_apuesta,
                            da_estado,
                            da_opcion_equipo1,
                            da_opcion_equipo2,
                            da_opcion_empate,
                            da_opcion_si,
                            da_opcion_no,
                            da_opcion_mas,
                            da_opcion_menos,
                            da_valor_apostado,
                            da_valor_ganado,
                            da_porcentaje_equipo1,
                            da_porcentaje_equipo2,
                            da_porcentaje_empate,
                            da_porcentaje_si,
                            da_porcentaje_no,
                            da_porcentaje_mas,
                            da_porcentaje_menos;

                        SELECT
                            nvl(total_ganado, '0')
                        INTO ap_total_ganado
                        FROM
                            apuestas
                        WHERE
                            id = da_id_apuesta;

                        EXIT WHEN detalle_apuesta_tipo_apuesta%notfound; 
   --select * from tipos_apuestas;
   --select * from detalle_apuesta;
                        IF cp_goles_tiempo1 + cp_goles_tiempo2 > 0 THEN
                            SELECT
                                nvl(total_ganado, '0')
                            INTO ap_total_ganado
                            FROM
                                apuestas
                            WHERE
                                id = da_id_apuesta;

                            IF da_opcion_mas = 'Y' THEN
                                da_valor_ganado := da_valor_apostado * da_porcentaje_mas;
                                UPDATE apuestas
                                SET
                                    total_ganado = ap_total_ganado + da_valor_ganado;

                                UPDATE detalle_apuesta
                                SET
                                    estado = 'GANADA',
                                    valor_apostado = da_valor_apostado,
                                    valor_ganado = da_valor_ganado
                                WHERE
                                    id = da_id_detalle_apuesta;

                                dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                                dbms_output.put_line('PARTIDO ganado  EQUIPO1 APUESTA SIMPLE VALOR GANADO ' || da_valor_ganado);
                                dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                            ELSE
                                da_valor_ganado := 0;
                                UPDATE detalle_apuesta
                                SET
                                    estado = 'PERDIDA',
                                    valor_apostado = da_valor_apostado,
                                    valor_ganado = da_valor_ganado
                                WHERE
                                    id = da_id_detalle_apuesta;

                                dbms_output.put_line('PARTIDO PERDIDO  EQUIPO1 APUESTA SIMPLE  VALOR GANADO' || da_valor_ganado)
                                ;
                            END IF;

                        ELSE
                            IF da_opcion_menos = 'Y' THEN
                                da_valor_ganado := da_valor_apostado * da_porcentaje_menos;
                                UPDATE apuestas
                                SET
                                    total_ganado = ap_total_ganado + da_valor_ganado;

                                UPDATE detalle_apuesta
                                SET
                                    estado = 'GANADA',
                                    valor_apostado = da_valor_apostado,
                                    valor_ganado = da_valor_ganado
                                WHERE
                                    id = da_id_detalle_apuesta;

                                dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                                dbms_output.put_line('PARTIDO ganado  EQUIPO1 APUESTA SIMPLE VALOR GANADO ' || da_valor_ganado);
                                dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                            ELSE
                                da_valor_ganado := 0;
                                UPDATE detalle_apuesta
                                SET
                                    estado = 'PERDIDA',
                                    valor_apostado = da_valor_apostado,
                                    valor_ganado = da_valor_ganado
                                WHERE
                                    id = da_id_detalle_apuesta;

                                dbms_output.put_line('PARTIDO PERDIDO  EQUIPO1 APUESTA SIMPLE  VALOR GANADO' || da_valor_ganado)
                                ;
                            END IF;
                        END IF;

                    END LOOP;

                    CLOSE detalle_apuesta_tipo_apuesta;
                    dbms_output.put_line('ganador mas menos 0.5');
                    dbms_output.put_line('TIPO DE APUESTA ' || ta_tipo_apuesta);
                ELSE
                    IF ta_tipo_apuesta = 'MAS/MENOS(1,5)'  AND ta_id_cronograma = id_partido THEN
                        OPEN detalle_apuesta_tipo_apuesta;
                        LOOP
                            FETCH detalle_apuesta_tipo_apuesta 
                
                --select * from detalle_apuesta;
                             INTO
                                da_id_detalle_apuesta,
                                da_id_apuesta,
                                da_id_tipo_apuesta,
                                da_estado,
                                da_opcion_equipo1,
                                da_opcion_equipo2,
                                da_opcion_empate,
                                da_opcion_si,
                                da_opcion_no,
                                da_opcion_mas,
                                da_opcion_menos,
                                da_valor_apostado,
                                da_valor_ganado,
                                da_porcentaje_equipo1,
                                da_porcentaje_equipo2,
                                da_porcentaje_empate,
                                da_porcentaje_si,
                                da_porcentaje_no,
                                da_porcentaje_mas,
                                da_porcentaje_menos;

                            SELECT
                                nvl(total_ganado, '0')
                            INTO ap_total_ganado
                            FROM
                                apuestas
                            WHERE
                                id = da_id_apuesta;

                            EXIT WHEN detalle_apuesta_tipo_apuesta%notfound; 
   --select * from tipos_apuestas;
   --select * from detalle_apuesta;
                            IF cp_goles_tiempo1 + cp_goles_tiempo2 > 1 THEN
                                SELECT
                                    nvl(total_ganado, '0')
                                INTO ap_total_ganado
                                FROM
                                    apuestas
                                WHERE
                                    id = da_id_apuesta;

                                IF da_opcion_mas = 'Y' THEN
                                    da_valor_ganado := da_valor_apostado * da_porcentaje_mas;
                                    UPDATE apuestas
                                    SET
                                        total_ganado = ap_total_ganado + da_valor_ganado;

                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'GANADA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                                    dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                                ELSE
                                    da_valor_ganado := 0;
                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'PERDIDA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('PARTIDO PERDIDO  EQUIPO1 APUESTA SIMPLE  VALOR GANADO' || da_valor_ganado
                                    );
                                END IF;

                            ELSE
                                IF da_opcion_menos = 'Y' THEN
                                    da_valor_ganado := da_valor_apostado * da_porcentaje_menos;
                                    UPDATE apuestas
                                    SET
                                        total_ganado = ap_total_ganado + da_valor_ganado;

                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'GANADA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                                    dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                                ELSE
                                    da_valor_ganado := 0;
                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'PERDIDA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                END IF;
                            END IF;

                        END LOOP;

                        CLOSE detalle_apuesta_tipo_apuesta;
                        dbms_output.put_line('ganador mas menos 1.5');
                    END IF;
                END IF;
            END IF;

            IF ta_tipo_apuesta = 'MAS/MENOS(2,5)' AND ta_id_cronograma = id_partido  THEN
                OPEN detalle_apuesta_tipo_apuesta;
                LOOP
                    FETCH detalle_apuesta_tipo_apuesta 
                
                --select * from detalle_apuesta;
                     INTO
                        da_id_detalle_apuesta,
                        da_id_apuesta,
                        da_id_tipo_apuesta,
                        da_estado,
                        da_opcion_equipo1,
                        da_opcion_equipo2,
                        da_opcion_empate,
                        da_opcion_si,
                        da_opcion_no,
                        da_opcion_mas,
                        da_opcion_menos,
                        da_valor_apostado,
                        da_valor_ganado,
                        da_porcentaje_equipo1,
                        da_porcentaje_equipo2,
                        da_porcentaje_empate,
                        da_porcentaje_si,
                        da_porcentaje_no,
                        da_porcentaje_mas,
                        da_porcentaje_menos;

                    SELECT
                        nvl(total_ganado, '0')
                    INTO ap_total_ganado
                    FROM
                        apuestas
                    WHERE
                        id = da_id_apuesta;

                    EXIT WHEN detalle_apuesta_tipo_apuesta%notfound; 
   --select * from tipos_apuestas;
   --select * from detalle_apuesta;
                    IF cp_goles_tiempo1 + cp_goles_tiempo2 > 2 THEN
                        SELECT
                            nvl(total_ganado, '0')
                        INTO ap_total_ganado
                        FROM
                            apuestas
                        WHERE
                            id = da_id_apuesta;

                        IF da_opcion_mas = 'Y' THEN
                            da_valor_ganado := da_valor_apostado * da_porcentaje_mas;
                            UPDATE apuestas
                            SET
                                total_ganado = ap_total_ganado + da_valor_ganado;

                            UPDATE detalle_apuesta
                            SET
                                estado = 'GANADA',
                                valor_apostado = da_valor_apostado,
                                valor_ganado = da_valor_ganado
                            WHERE
                                id = da_id_detalle_apuesta;

                            dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                            dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                        ELSE
                            da_valor_ganado := 0;
                            UPDATE detalle_apuesta
                            SET
                                estado = 'PERDIDA',
                                valor_apostado = da_valor_apostado,
                                valor_ganado = da_valor_ganado
                            WHERE
                                id = da_id_detalle_apuesta;

                            dbms_output.put_line('PARTIDO PERDIDO  EQUIPO1 APUESTA SIMPLE  VALOR GANADO' || da_valor_ganado);
                        END IF;

                    ELSE
                        IF da_opcion_menos = 'Y' THEN
                            da_valor_ganado := da_valor_apostado * da_porcentaje_menos;
                            UPDATE apuestas
                            SET
                                total_ganado = ap_total_ganado + da_valor_ganado;

                            UPDATE detalle_apuesta
                            SET
                                estado = 'GANADA',
                                valor_apostado = da_valor_apostado,
                                valor_ganado = da_valor_ganado
                            WHERE
                                id = da_id_detalle_apuesta;

                            dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                            dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                        ELSE
                            da_valor_ganado := 0;
                            UPDATE detalle_apuesta
                            SET
                                estado = 'PERDIDA',
                                valor_apostado = da_valor_apostado,
                                valor_ganado = da_valor_ganado
                            WHERE
                                id = da_id_detalle_apuesta;

                        END IF;
                    END IF;

                END LOOP;

                CLOSE detalle_apuesta_tipo_apuesta;
                dbms_output.put_line('ganador mas menos 2.5');
            END IF;

            IF ta_tipo_apuesta = 'AMBOS ANOTAN GOL' AND ta_id_cronograma = id_partido THEN
            
            OPEN detalle_apuesta_tipo_apuesta;
                        LOOP
                            FETCH detalle_apuesta_tipo_apuesta 
                
                --select * from detalle_apuesta;
                             INTO
                                da_id_detalle_apuesta,
                                da_id_apuesta,
                                da_id_tipo_apuesta,
                                da_estado,
                                da_opcion_equipo1,
                                da_opcion_equipo2,
                                da_opcion_empate,
                                da_opcion_si,
                                da_opcion_no,
                                da_opcion_mas,
                                da_opcion_menos,
                                da_valor_apostado,
                                da_valor_ganado,
                                da_porcentaje_equipo1,
                                da_porcentaje_equipo2,
                                da_porcentaje_empate,
                                da_porcentaje_si,
                                da_porcentaje_no,
                                da_porcentaje_mas,
                                da_porcentaje_menos;

                            SELECT
                                nvl(total_ganado, '0')
                            INTO ap_total_ganado
                            FROM
                                apuestas
                            WHERE
                                id = da_id_apuesta;

                            EXIT WHEN detalle_apuesta_tipo_apuesta%notfound; 
   --select * from tipos_apuestas;
   --select * from detalle_apuesta;
                            IF cp_goles_equipo1 >0 AND cp_goles_equipo2> 0 THEN
                                SELECT
                                    nvl(total_ganado, '0')
                                INTO ap_total_ganado
                                FROM
                                    apuestas
                                WHERE
                                    id = da_id_apuesta;

                                IF da_opcion_si = 'Y' THEN
                                    da_valor_ganado := da_valor_apostado * da_porcentaje_si;
                                    UPDATE apuestas
                                    SET
                                        total_ganado = ap_total_ganado + da_valor_ganado;

                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'GANADA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                                    dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                                ELSE
                                    da_valor_ganado := 0;
                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'PERDIDA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('PARTIDO PERDIDO  EQUIPO1 APUESTA SIMPLE  VALOR GANADO' || da_valor_ganado
                                    );
                                END IF;

                            ELSE
                                IF da_opcion_no = 'Y' THEN
                                    da_valor_ganado := da_valor_apostado * da_porcentaje_no;
                                    UPDATE apuestas
                                    SET
                                        total_ganado = ap_total_ganado + da_valor_ganado;

                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'GANADA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                                    dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                                ELSE
                                    da_valor_ganado := 0;
                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'PERDIDA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                END IF;
                            END IF;

                        END LOOP;

                        CLOSE detalle_apuesta_tipo_apuesta;
            
                dbms_output.put_line('ganador ambos anotan gol');
            END IF;
            IF ta_tipo_apuesta = 'QUIEN GANA EL PRIMER TIEMPO' AND ta_id_cronograma = id_partido THEN
            
            OPEN detalle_apuesta_tipo_apuesta;
                        LOOP
                            FETCH detalle_apuesta_tipo_apuesta 
                
                --select * from detalle_apuesta;
                             INTO
                                da_id_detalle_apuesta,
                                da_id_apuesta,
                                da_id_tipo_apuesta,
                                da_estado,
                                da_opcion_equipo1,
                                da_opcion_equipo2,
                                da_opcion_empate,
                                da_opcion_si,
                                da_opcion_no,
                                da_opcion_mas,
                                da_opcion_menos,
                                da_valor_apostado,
                                da_valor_ganado,
                                da_porcentaje_equipo1,
                                da_porcentaje_equipo2,
                                da_porcentaje_empate,
                                da_porcentaje_si,
                                da_porcentaje_no,
                                da_porcentaje_mas,
                                da_porcentaje_menos;

                            SELECT
                                nvl(total_ganado, '0')
                            INTO ap_total_ganado
                            FROM
                                apuestas
                            WHERE
                                id = da_id_apuesta;

                            EXIT WHEN detalle_apuesta_tipo_apuesta%notfound; 
   --select * from tipos_apuestas;
   --select * from detalle_apuesta;
                            IF cp_ganador_tiempo1 = cp_id_equipo1 THEN
                                SELECT
                                    nvl(total_ganado, '0')
                                INTO ap_total_ganado
                                FROM
                                    apuestas
                                WHERE
                                    id = da_id_apuesta;

                                IF da_opcion_equipo1 = 'Y' THEN
                                    da_valor_ganado := da_valor_apostado * da_porcentaje_equipo1;
                                    UPDATE apuestas
                                    SET
                                        total_ganado = ap_total_ganado + da_valor_ganado;

                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'GANADA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                                    dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                                ELSE
                                    da_valor_ganado := 0;
                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'PERDIDA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('PARTIDO PERDIDO  EQUIPO1 APUESTA SIMPLE  VALOR GANADO' || da_valor_ganado
                                    );
                                END IF;

                            ELSE
                                IF da_opcion_equipo2 = 'Y' THEN
                                    da_valor_ganado := da_valor_apostado * da_porcentaje_equipo2;
                                    UPDATE apuestas
                                    SET
                                        total_ganado = ap_total_ganado + da_valor_ganado;

                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'GANADA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                                    dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                                ELSE
                                    da_valor_ganado := 0;
                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'PERDIDA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                END IF;
                            END IF;

                        END LOOP;

                        CLOSE detalle_apuesta_tipo_apuesta;
            
            
                dbms_output.put_line('ganador quien gana el primer tiempo');
            END IF;
            IF ta_tipo_apuesta = 'QUIEN GANA EL SEGUNDO TIEMPO' AND ta_id_cronograma = id_partido THEN
            
            OPEN detalle_apuesta_tipo_apuesta;
                        LOOP
                            FETCH detalle_apuesta_tipo_apuesta 
                
                --select * from detalle_apuesta;
                             INTO
                                da_id_detalle_apuesta,
                                da_id_apuesta,
                                da_id_tipo_apuesta,
                                da_estado,
                                da_opcion_equipo1,
                                da_opcion_equipo2,
                                da_opcion_empate,
                                da_opcion_si,
                                da_opcion_no,
                                da_opcion_mas,
                                da_opcion_menos,
                                da_valor_apostado,
                                da_valor_ganado,
                                da_porcentaje_equipo1,
                                da_porcentaje_equipo2,
                                da_porcentaje_empate,
                                da_porcentaje_si,
                                da_porcentaje_no,
                                da_porcentaje_mas,
                                da_porcentaje_menos;

                            SELECT
                                nvl(total_ganado, '0')
                            INTO ap_total_ganado
                            FROM
                                apuestas
                            WHERE
                                id = da_id_apuesta;

                            EXIT WHEN detalle_apuesta_tipo_apuesta%notfound; 
   --select * from tipos_apuestas;
   --select * from detalle_apuesta;
                            IF cp_ganador_tiempo2 = cp_id_equipo1 THEN
                                SELECT
                                    nvl(total_ganado, '0')
                                INTO ap_total_ganado
                                FROM
                                    apuestas
                                WHERE
                                    id = da_id_apuesta;

                                IF da_opcion_equipo1 = 'Y' THEN
                                    da_valor_ganado := da_valor_apostado * da_porcentaje_equipo1;
                                    UPDATE apuestas
                                    SET
                                        total_ganado = ap_total_ganado + da_valor_ganado;

                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'GANADA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                                    dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                                ELSE
                                    da_valor_ganado := 0;
                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'PERDIDA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('PARTIDO PERDIDO  EQUIPO1 APUESTA SIMPLE  VALOR GANADO' || da_valor_ganado
                                    );
                                END IF;

                            ELSE
                                IF da_opcion_equipo2 = 'Y' THEN
                                    da_valor_ganado := da_valor_apostado * da_porcentaje_equipo2;
                                    UPDATE apuestas
                                    SET
                                        total_ganado = ap_total_ganado + da_valor_ganado;

                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'GANADA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                                    dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                                ELSE
                                    da_valor_ganado := 0;
                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'PERDIDA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                END IF;
                            END IF;

                        END LOOP;

                        CLOSE detalle_apuesta_tipo_apuesta;
            
                dbms_output.put_line('ganador quien gana el segundo tiempo');
            END IF;
            IF ta_tipo_apuesta = 'UN GOL EN CADA TIEMPO' AND ta_id_cronograma = id_partido THEN
            
            OPEN detalle_apuesta_tipo_apuesta;
                        LOOP
                            FETCH detalle_apuesta_tipo_apuesta 
                
                --select * from detalle_apuesta;
                             INTO
                                da_id_detalle_apuesta,
                                da_id_apuesta,
                                da_id_tipo_apuesta,
                                da_estado,
                                da_opcion_equipo1,
                                da_opcion_equipo2,
                                da_opcion_empate,
                                da_opcion_si,
                                da_opcion_no,
                                da_opcion_mas,
                                da_opcion_menos,
                                da_valor_apostado,
                                da_valor_ganado,
                                da_porcentaje_equipo1,
                                da_porcentaje_equipo2,
                                da_porcentaje_empate,
                                da_porcentaje_si,
                                da_porcentaje_no,
                                da_porcentaje_mas,
                                da_porcentaje_menos;

                            SELECT
                                nvl(total_ganado, '0')
                            INTO ap_total_ganado
                            FROM
                                apuestas
                            WHERE
                                id = da_id_apuesta;

                            EXIT WHEN detalle_apuesta_tipo_apuesta%notfound; 
   --select * from tipos_apuestas;
   --select * from detalle_apuesta;
                            IF cp_goles_tiempo1 >0 AND cp_goles_tiempo2> 0 THEN
                                SELECT
                                    nvl(total_ganado, '0')
                                INTO ap_total_ganado
                                FROM
                                    apuestas
                                WHERE
                                    id = da_id_apuesta;

                                IF da_opcion_si = 'Y' THEN
                                    da_valor_ganado := da_valor_apostado * da_porcentaje_si;
                                    UPDATE apuestas
                                    SET
                                        total_ganado = ap_total_ganado + da_valor_ganado;

                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'GANADA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                                    dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                                ELSE
                                    da_valor_ganado := 0;
                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'PERDIDA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('PARTIDO PERDIDO  EQUIPO1 APUESTA SIMPLE  VALOR GANADO' || da_valor_ganado
                                    );
                                END IF;

                            ELSE
                                IF da_opcion_no = 'Y' THEN
                                    da_valor_ganado := da_valor_apostado * da_porcentaje_no;
                                    UPDATE apuestas
                                    SET
                                        total_ganado = ap_total_ganado + da_valor_ganado;

                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'GANADA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                    dbms_output.put_line('id_tipo_apuesta ' || ta_id_tipos_apuestas);
                                    dbms_output.put_line('total_ganado en  ap_total_ganado ' || ap_total_ganado);
                                ELSE
                                    da_valor_ganado := 0;
                                    UPDATE detalle_apuesta
                                    SET
                                        estado = 'PERDIDA',
                                        valor_apostado = da_valor_apostado,
                                        valor_ganado = da_valor_ganado
                                    WHERE
                                        id = da_id_detalle_apuesta;

                                END IF;
                            END IF;

                        END LOOP;

                        CLOSE detalle_apuesta_tipo_apuesta;
            
                dbms_output.put_line('ganador un gol en cada tiempo');
            END IF;
        END LOOP;

        CLOSE tipo_apuestas_partido;
    END IF;

END;


--UPDATE CRONOGRAMA_PARTIDOS SET ESTADO = 'FINALIZADO' WHERE ID = 2;
--EXECUTE PROC_FINALIZA_PARTIDO_CALCULOS(2);
-- select * from cronograma_partidos;
--SELECT SALDO FROM USUARIOS WHERE ID = 2;
--SELECT * FROM APUESTAS WHERE ID_USUARIO = 2;
--SELECT * FROM DETALLE_APUESTA WHERE ESTADO = 'GANADA'
--SELECT * FROM TIPOS_APUESTAS  WHERE ID_CRONOGRAMA = 2;
--SELECT * FROM CRONOGRAMA_PARTIDOS  WHERE ID = 2;
