CREATE OR REPLACE PROCEDURE Proc_Soft_Deletion(
                            Tabla VARCHAR2,
                            id NUMBER
                           ) IS
    csr_id     INTEGER;
    stmt       VARCHAR2(200);
    rows_added NUMBER;
BEGIN
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
