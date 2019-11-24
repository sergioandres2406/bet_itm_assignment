
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
        da_id_detalle_apuesta detalle_apuesta.id%type;
        da_estado detalle_apuesta.estado%TYPE;
        
        
        
        CURSOR tipo_apuestas_partido is 
        SELECT id,tipo_apuesta   FROM tipos_apuestas where id_cronograma = id_partido;
      
      CURSOR DETALLE_APUESTA_TIPO_APUESTA  IS
      SELECT ID FROM detalle_apuesta WHERE ID_TIPO_APUESTA = ta_id_tipos_apuestas;
BEGIN
   cambio_estado := 'FINALIZADO';
   SELECT GANADOR, ID_EQUIPO1,ID_EQUIPO2,ganador_tiempo1,ganador_tiempo2,goles_tiempo1,goles_tiempo2
   INTO 
   cp_equipo_ganador ,cp_id_equipo1,cp_id_equipo2,cp_ganador_tiempo1,cp_ganador_tiempo2,cp_goles_tiempo1,cp_goles_tiempo2
   FROM cronograma_partidos WHERE ID = id_partido; 
   
   
   
   --update cronograma_partidos set  estado = cambio_estado where id = id_partido;    
   --update tipos_apuestas set estado = cambio_estado where id_crongrama = id_partido; 
    
   
    OPEN tipo_apuestas_partido; 
   LOOP 
   FETCH tipo_apuestas_partido into ta_id_tipos_apuestas,ta_tipo_apuesta; 
       
        if ta_tipo_apuesta = 'SIMPLE' THEN
        
        END IF;
        if ta_tipo_apuesta = 'MAS/MENOS(0,5)' THEN
        
        END IF;
        if ta_tipo_apuesta = 'MAS/MENOS(1,5)' THEN
        
        END IF;
        if ta_tipo_apuesta = 'MAS/MENOS(2,5)' THEN
        
        END IF;
        if ta_tipo_apuesta = 'MAS/MENOS(3,5)' THEN
        
        END IF;
        if ta_tipo_apuesta = 'AMBOS ANOTAN GOL' THEN
        
        END IF;
        
         if ta_tipo_apuesta = 'QUIEN GANA EL PRIMER TIEMPO' THEN
        
        END IF;
        if ta_tipo_apuesta = 'QUIEN GANA EL SEGUNDO TIEMPO' THEN
        
        END IF;
         if ta_tipo_apuesta = 'UN GOL EN CADA TIEMPO' THEN
        
        END IF;
        
        OPEN DETALLE_APUESTA_TIPO_APUESTA; 
        LOOP 
        FETCH DETALLE_APUESTA_TIPO_APUESTA into id_detalle_apuesta; 
   
   
         EXIT WHEN DETALLE_APUESTA_TIPO_APUESTA%notfound; 
      
         END LOOP; 
         CLOSE DETALLE_APUESTA_TIPO_APUESTA; 

   
      EXIT WHEN tipo_apuestas_partido%notfound; 
      
   END LOOP; 
   CLOSE tipo_apuestas_partido; 

   
  
    select id into id_tipos_apuestas from tipos_apuestas where  id_cronograma = ;
    exec PROC_FINALIZA_PARTIDO_DET_APUESTAS(
    
END;


/**  PROCEDIMIENTO QUE ACTUALIZA DETALLE APUESTAS LUEGO QUE UN PARTIDO ES FINALIZADO  */

CREATE OR REPLACE PROCEDURE PROC_FINALIZA_PARTIDO_DET_APUESTAS(
                            
                            id_tipo_apuesta NUMBER
                           ) IS
   
BEGIN
  
  select cp.id_equipo1 equipo1, cp.id_equipo2 equipo2,cp.ganador,
         cp.goles_equipo1,cp.goles_equipo2,cp.ganador_tiempo1,cp.ganador_tiempo2,cp.estado
        ta.

SELECT da.id_apuesta ID_Apuesta,da.id_tipo_apuesta ID_Tipo_apuesta, cp.estado Estado_Partido,
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
inner join equipos e2 on cp.id_equipo2=e2.id;



    
END;

