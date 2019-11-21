CREATE OR REPLACE FUNCTION F_Validar_Session(id_cliente number) return BOOLEAN
IS
CANTIDAD_SESSIONES NUMBER;
BEGIN

SELECT COUNT(id) INTO CANTIDAD_SESSIONES FROM sesiones WHERE ID_USUARIO= id_cliente AND ESTADO='Activo';

IF CANTIDAD_SESSIONES>0 THEN
RETURN TRUE;
   ELSE   
   RETURN FALSE;
   END IF;

END ;

---PROBAR LA FUNCIÓN
set serveroutput on
declare
SESSION_VALIDA VARCHAR(100);

BEGIN
SESSION_VALIDA := case F_Validar_Session(1) when true then 'true' when false then 'false' else NULL end;

 DBMS_OUTPUT.PUT_LINE(SESSION_VALIDA);

END;



/***** AQUI ESTOY IMPLEMENTANDO EL SP QUE HACE LOS CALCULOS DE LOS PARTIDOS
CUANDO FINALIZAN ***/


CREATE OR REPLACE PROCEDURE Proc_Finaliza_Partido(
                            
                            id_partido NUMBER
                           ) IS
    total_ganancias number;
    total_perdidas  number;
    estado varchar2(255);
BEGIN
  select estado into estado 
  from cronograma_partidos where id = id_partido;
  IF estado <> 'FINALIZADO' THEN
    update cronograma_partidos set  estado = 'FINALIZADO' where id = id_partido;    
   END IF;
   
    stmt := 'update '||Tabla||' SET REGISTRO_ACTIVO=''N'' WHERE ID= :cid AND REGISTRO_ACTIVO=''Y'' ';
    csr_id := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(csr_id, stmt, DBMS_SQL.NATIVE);
    DBMS_SQL.BIND_VARIABLE(csr_id, ':cid', id);
    rows_added := DBMS_SQL.EXECUTE(csr_id);
    IF rows_added=0 THEN
    DBMS_OUTPUT.PUT_LINE('EL ID NO EXISTE');
    ELSE
    DBMS_OUTPUT.PUT_LINE(rows_added||' row added');
    END IF; 
    DBMS_SQL.CLOSE_CURSOR(csr_id);
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20001,'LA TABLA NO EXISTE');
END;


EXEC Proc_Soft_Deletion('SESIONESSDF',1);
