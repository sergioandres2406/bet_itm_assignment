
/***** AQUI ESTOY IMPLEMENTANDO EL SP QUE HACE LOS CALCULOS DE LOS PARTIDOS
CUANDO FINALIZAN 
Crear un procedimiento que coloque un partido en estado 
"FINALIZADO",en ese momento deberá calcular las 
ganancias y pérdidas de cada apuesta hecha asociada a ese partido.

update cronograma_partidos set estado = ´FINALIZADO'
UPDATE TIPOS_APUESTAS SET ESTADO FINALIZADA

select * from tipos_apuestas;
***/


CREATE OR REPLACE PROCEDURE Proc_Finaliza_Partido(
                            
                            id_partido NUMBER
                           ) IS
        cambio_estado varchar2(255); 
        cp_id_equipo1  cronograma_partidos.id_equipo1%TYPE;
        cp_id_equipo2 cronograma_partidos.id_equipo2%TYPE;
        cp_equipo_ganador cronograma_partidos.ganador%TYPE;
        cp_goles_equipo1  cronograma_partidos.goles_equipo1%TYPE;
        cp_goles_equipo2  cronograma_partidos.goles_equipo2%TYPE;
        cp_ganador_tiempo1 cronograma_partidos.ganador_tiempo1%TYPE;
        cp_ganador_tiempo2 cronograma_partidos.ganador_tiempo2%TYPE;
        cp_goles_tiempo1  cronograma_partidos.goles_tiempo1%TYPE;
        cp_goles_tiempo2  cronograma_partidos.goles_tiempo2%TYPE;
        ta_id_tipos_apuestas tipos_apuestas.id%type;
        ta_tipo_apuesta tipos_apuestas.tipo_apuesta%type;
        ta_id_cronograma tipos_apuestas.id_cronograma%TYPE;
        da_id_detalle_apuesta detalle_apuesta.id%type;
        da_id_apuesta detalle_apuesta.id_apuesta%TYPE;
        da_estado detalle_apuesta.estado%TYPE;
        da_id_tipo_apuesta detalle_apuesta.id_tipo_apuesta%TYPE;
        da_opcion_equipo1 detalle_apuesta.opcion_equipo1%TYPE;
        da_opcion_equipo2 detalle_apuesta.opcion_equipo2%TYPE;
        da_opcion_empate detalle_apuesta.opcion_empate%TYPE;
        da_opcion_si detalle_apuesta.opcion_si%TYPE;
        da_opcion_no detalle_apuesta.opcion_no%TYPE;
        da_opcion_mas detalle_apuesta.opcion_mas%TYPE;
        da_opcion_menos detalle_apuesta.opcion_menos%TYPE;
        da_porcentaje_equipo1 detalle_apuesta.porcentaje_equipo1_apostado%TYPE;
        da_porcentaje_equipo2 detalle_apuesta.porcentaje_equipo2_apostado%TYPE;
        da_porcentaje_empate detalle_apuesta.porcentaje_empate_apostado%TYPE;
        da_porcentaje_si detalle_apuesta.porcentaje_si_apostado%TYPE;
        da_porcentaje_no detalle_apuesta.porcentaje_no_apostado%TYPE;
        da_porcentaje_mas detalle_apuesta.porcentaje_mas_apostado%TYPE;
        da_porcentaje_menos detalle_apuesta.porcentaje_menos_apostado%TYPE;
        da_valor_ganado detalle_apuesta.valor_ganado%TYPE;
        da_valor_apostado detalle_apuesta.valor_apostado%TYPE;
        ap_total_ganado apuestas.total_ganado%TYPE;
        
        CURSOR tipo_apuestas_partido is 
        SELECT id,tipo_apuesta,id_cronograma   FROM tipos_apuestas where id_cronograma = id_partido;
       --SELECT id,tipo_apuesta,ID_CRONOGRAMA   FROM tipos_apuestas where id_cronograma = 2;
      CURSOR DETALLE_APUESTA_TIPO_APUESTA  IS
      SELECT ID,id_apuesta,id_tipo_apuesta,estado,opcion_equipo1,opcion_equipo2,
            opcion_empate,opcion_si,opcion_no,opcion_mas,opcion_menos,
            valor_apostado,valor_ganado,porcentaje_equipo1_apostado,
            porcentaje_equipo2_apostado,porcentaje_empate_apostado,
            porcentaje_si_apostado,porcentaje_no_apostado,
            porcentaje_mas_apostado,porcentaje_menos_apostado
      FROM detalle_apuesta WHERE id_tipo_apuesta = ta_id_tipos_apuestas;


BEGIN
   cambio_estado := 'FINALIZADO';
   SELECT GANADOR, ID_EQUIPO1,ID_EQUIPO2,ganador_tiempo1,ganador_tiempo2,goles_tiempo1,goles_tiempo2
   INTO 
   cp_equipo_ganador ,cp_id_equipo1,cp_id_equipo2,cp_ganador_tiempo1,cp_ganador_tiempo2,cp_goles_tiempo1,cp_goles_tiempo2
   FROM cronograma_partidos WHERE ID = id_partido; 
   
   
   
   update cronograma_partidos set  estado = cambio_estado where id = id_partido;    
   update tipos_apuestas set estado = cambio_estado where id_cronograma = id_partido; 
    
   
    OPEN tipo_apuestas_partido; 
   LOOP 
   FETCH tipo_apuestas_partido into ta_id_tipos_apuestas,ta_tipo_apuesta,ta_id_cronograma; 
       
        if ta_tipo_apuesta = 'SIMPLE' AND ta_id_cronograma = id_partido  THEN
        --select * from tipos_apuestas where  tipo_apuesta = 'SIMPLE' AND  ID_CRONOGRAMA = 2;
                 OPEN DETALLE_APUESTA_TIPO_APUESTA; 
                LOOP 
                FETCH DETALLE_APUESTA_TIPO_APUESTA 
                --select * from detalle_apuesta;
                into da_id_detalle_apuesta,da_id_apuesta,da_id_tipo_apuesta,da_estado,da_opcion_equipo1,
                da_opcion_equipo2,da_opcion_empate,da_opcion_si,da_opcion_no,
                da_opcion_mas,da_opcion_menos,da_valor_apostado,da_valor_ganado,
                da_porcentaje_equipo1,da_porcentaje_equipo2,da_porcentaje_empate, 
                da_porcentaje_si,da_porcentaje_no, da_porcentaje_mas,da_porcentaje_menos; 
                 select NVL(total_ganado,'0') into ap_total_ganado from apuestas where id = da_id_apuesta;
   --select * from tipos_apuestas;
   --select * from detalle_apuesta;
                      if cp_equipo_ganador = cp_id_equipo1 then
                          select NVL(total_ganado,'0') into ap_total_ganado from apuestas where id = da_id_apuesta;
                            
                         if da_opcion_equipo1 = 'Y' then
                            da_valor_ganado := da_valor_apostado * da_porcentaje_equipo1;
                             update apuestas set total_ganado = ap_total_ganado + da_valor_ganado;
                            UPDATE detalle_apuesta SET estado = 'GANADA', valor_apostado = da_valor_apostado,valor_ganado = da_valor_ganado  WHERE id = da_id_detalle_apuesta; 
                            dbms_output.put_line('id_tipo_apuesta '|| ta_id_tipos_apuestas);
                            dbms_output.put_line('PARTIDO ganado  EQUIPO1 APUESTA SIMPLE VALOR GANADO '|| da_valor_ganado); 
                            dbms_output.put_line('total_ganado en  ap_total_ganado '|| ap_total_ganado);
                         else
                            da_valor_ganado := 0;
                             UPDATE detalle_apuesta SET estado = 'PERDIDA', valor_apostado = da_valor_apostado,valor_ganado = da_valor_ganado  WHERE id = da_id_detalle_apuesta;
                             dbms_output.put_line('PARTIDO PERDIDO  EQUIPO1 APUESTA SIMPLE  VALOR GANADO'|| da_valor_ganado); 
                         END IF;
                      ELSE                                                    
                            if cp_equipo_ganador = cp_id_equipo2 then
                                if da_opcion_equipo2 = 'Y' then
                                    da_valor_ganado := da_valor_apostado * da_porcentaje_equipo2;
                                    UPDATE detalle_apuesta SET estado = 'GANADA', valor_apostado = da_valor_apostado,valor_ganado = da_valor_ganado  WHERE id = da_id_detalle_apuesta; 
                                    dbms_output.put_line('valor ganado PARTIDO EQUIPO2  '|| da_valor_ganado);
                                 else
                                    da_valor_ganado := 0;
                                    UPDATE detalle_apuesta SET estado = 'PERDIDA', valor_apostado = da_valor_apostado,valor_ganado = da_valor_ganado  WHERE id = da_id_detalle_apuesta;
                                    dbms_output.put_line('PARTIDO PERDIDO  EQUIPO1 APUESTA SIMPLE  VALOR GANADO'|| da_valor_ganado);
                                end if;
                            end if;
                       end if;
                        
                       
                        
                    
                 EXIT WHEN DETALLE_APUESTA_TIPO_APUESTA%notfound; 
      
                 END LOOP; 
                 CLOSE DETALLE_APUESTA_TIPO_APUESTA; 
           
        ELSE
             if ta_tipo_apuesta = 'MAS/MENOS(0,5)' THEN
                dbms_output.put_line('ganador mas menos 0.5');
                dbms_output.put_line('TIPO DE APUESTA '|| ta_tipo_apuesta); 
             ELSE
                
                IF ta_tipo_apuesta = 'MAS/MENOS(1,5)' THEN
                dbms_output.put_line('ganador mas menos 1.5');
                END IF;
            END IF;
        END IF;
        
        
       
        if ta_tipo_apuesta = 'MAS/MENOS(2,5)' THEN
            dbms_output.put_line('ganador mas menos 2.5');
        END IF;
        if ta_tipo_apuesta = 'AMBOS ANOTAN GOL' THEN
            dbms_output.put_line('ganador ambos anotan gol');
        END IF;
        
         if ta_tipo_apuesta = 'QUIEN GANA EL PRIMER TIEMPO' THEN
            dbms_output.put_line('ganador quien gana el primer tiempo');
        END IF;
        if ta_tipo_apuesta = 'QUIEN GANA EL SEGUNDO TIEMPO' THEN
            dbms_output.put_line('ganador quien gana el segundo tiempo');
        END IF;
         if ta_tipo_apuesta = 'UN GOL EN CADA TIEMPO' THEN
            dbms_output.put_line('ganador un gol en cada tiempo');
        END IF;
        
   

   
      EXIT WHEN tipo_apuestas_partido%notfound; 
      
   END LOOP; 
   CLOSE tipo_apuestas_partido; 

   
  
END;


--EXECUTE Proc_Finaliza_Partido(2);


--SELECT SALDO FROM USUARIOS WHERE ID = 2;
--SELECT * FROM APUESTAS WHERE ID_USUARIO = 2;
--SELECT * FROM DETALLE_APUESTA WHERE ESTADO = 'GANADA'
--SELECT ESTADO FROM TIPOS_APUESTAS  WHERE ID_CRONOGRAMA = 2;
--SELECT ESTADO FROM CRONOGRAMA_PARTIDOS  WHERE ID = 2;
