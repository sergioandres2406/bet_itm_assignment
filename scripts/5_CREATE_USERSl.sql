
/*Create 10 users
Each user should have a profile assigned from the ones created previously.
All of the profiles created should be used at least once.
All of the users should be able to login into the system*/


alter session set "_ORACLE_SCRIPT"=true;
 
--CREAMOS EL USUARIO SVASQUEZ --
CREATE USER developer IDENTIFIED BY developer;

CREATE USER web_application IDENTIFIED BY web_application;

CREATE USER dba_admin IDENTIFIED BY dba_admin;

CREATE USER analyst IDENTIFIED BY analyst;

CREATE USER support_III IDENTIFIED BY support_III;

CREATE USER reporter IDENTIFIED BY reporter;

CREATE USER auditor IDENTIFIED BY auditor;

CREATE USER developer2 IDENTIFIED BY developer2;

CREATE USER analyst2 IDENTIFIED BY analyst2;

CREATE USER auditor2 IDENTIFIED BY auditor2;


ALTER USER developer 
PROFILE developer; 
GRANT CREATE SESSION TO developer;

ALTER USER web_application 
PROFILE web_application;
GRANT CREATE SESSION TO web_application;

ALTER USER dba_admin 
PROFILE dba_admin;
GRANT CREATE SESSION TO dba_admin;

ALTER USER analyst 
PROFILE analyst;
GRANT CREATE SESSION TO analyst;

ALTER USER support_III 
PROFILE support_III;
GRANT CREATE SESSION TO support_III;


ALTER USER reporter 
PROFILE reporter;
GRANT CREATE SESSION TO reporter;

ALTER USER auditor 
PROFILE auditor;
GRANT CREATE SESSION TO auditor;


ALTER USER developer2 
PROFILE developer;
GRANT CREATE SESSION TO developer2;


ALTER USER analyst2 
PROFILE analyst;
GRANT CREATE SESSION TO analyst2;


ALTER USER auditor2 
PROFILE auditor;
GRANT CREATE SESSION TO auditor2;

