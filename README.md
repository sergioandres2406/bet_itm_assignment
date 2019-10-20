TRABAJO  ENTREGABLE EN EQUIPOS.

PUNTO TEÓRICO 4

Roles and privileges:

Explain what's the purpose of the PUBLIC role, which privileges has it and which users have this role?
Explain the difference between these views: DBA_SYS_PRIVS, DBA_TAB_PRIVS and DBA_ROLE_PRIVS
When we talk about privileges in Oracle, we find three main categories of privileges, which are: SYSTEM priveleges, OBJECT privileges and Privilege hierarchy, define what is the purpose of each category and provide some examples of privileges which belong to each one of them.
Create the following roles with the privileges required as follows:
To be defined ***


Tanto SYS como SYSTEM son usuarios predeterminados, creados con la creación de la base de datos. Aunque tienen mucho poder, ya que se les otorga el rol de DBA , siguen siendo usuarios comunes. Debido a que SYS posee el diccionario de datos, se lo considera un poco más especial que SYSTEM.
Pero SYS tiene el privilegio SYSDBA que SYSTEM no tiene. Esto hace posible que SYS se convierta en un usuario muy muy poderoso. Este es el caso cuando se conecta como sys / contraseña como SYSDBA o / como sysdba . La frase as sysdba es una solicitud para adquirir los privilegios asociados con los privilegios del sistema SYSDBA (ver aquí ).
La diferencia se vuelve clara si intenta cerrar la base de datos como SYS ordinario: como resultado, obtiene privilegios insuficientes. Sin embargo, si está conectado como SYSDBA , es posible.
Tenga en cuenta que SYSDBA no es un rol , es un privilegio . Lo encontrará en system_privilege_map , no en dba_roles .
En cualquier momento, alguien se conecta como SYSDBA, resulta que está siendo SYS. Es decir, si SYSDBA se otorga a JOHN y John se conecta como SYSDBA y selecciona un usuario de dual, revela que en realidad es SYS.
SYS también es especial porque no es posible crear un activador en el esquema sys. Además, un disparador de inicio de sesión no se ejecuta cuando sys se conecta a la base de datos.
SYS
SYS es el propietario de la base de datos y el propietario del diccionario de datos.
Nunca cree objetos en el esquema SYS.
Los objetos que pertenecen a SYS no se pueden exportar .
SISTEMA
SYSTEM es un usuario de administración privilegiado, y normalmente posee tablas proporcionadas por Oracle que no son el diccionario. No cree sus propios objetos en SYSTEM.
PÚBLICO
El script sql.bsq, que se ejecuta cuando se crea una base de datos , crea la función pública:
crear rol público
/ /
Sin embargo, este rol no es visible en dba_roles porque está oculto en esta vista ( where ... name not in ('PUBLIC', '_NEXT_USER').
Cualquier privilegio otorgado al público automáticamente se convierte en un privilegio para otros usuarios también.
INTERNO
INTERNAL es un usuario especial obsoleto (a partir de 8i) al que se le permite acceder a la base de datos incluso cuando la base de datos está en estado NOMOUNT o MOUNT. Este usuario generalmente se usa para el mantenimiento físico de la base de datos. El usuario interno no se mantiene en el datadictionary sino en el archivo de contraseña de Oracle . El mecanismo interno ha sido reemplazado por el privilegio SYSDBA y SYSOPER en Oracle 8 y más allá.
