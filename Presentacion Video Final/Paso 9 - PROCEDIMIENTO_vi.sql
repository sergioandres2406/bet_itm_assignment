CREATE OR REPLACE PROCEDURE sp_cerrar_sesion

IS
BEGIN

UPDATE SESIONES SET FECHA_FIN_SESION=CAST(sysdate AS TIMESTAMP) WHERE id in (
select id_sesion from V_SESIONES_ACTIVAS where diferencia_horas<0
);

END;
exec sp_cerrar_sesion;