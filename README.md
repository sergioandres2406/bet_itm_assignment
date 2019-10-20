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

PÚBLICO
Listas de control de aceso
============================================ ================================================== ====
DBA_NETWORK_ACLS: Muestra la lista de control de acceso a las asignaciones de los hosts de la red. El privilegio SELECT en esta vista se otorga únicamente a la función SELECT_CATALOG_ROLE.
DBA_NETWORK_ACL_PRIVILEGES: muestra los privilegios de red definidos en todas las listas de control de acceso que están asignadas actualmente a los hosts de la red. El privilegio SELECT en esta vista se otorga únicamente a la función SELECT_CATALOG_ROLE.
USER_NETWORK_ACL_PRIVILEGES : muestra el estado de los privilegios de red para que el usuario actual acceda a los hosts de la red. El privilegio SELECT en la vista se otorga a PUBLIC.
================================================== ================================================
Búsqueda de información sobre los privilegios y roles del usuario
=========================================== ================================================== =====
ALL_COL_PRIVS: describe todas las concesiones de objetos de columna para las cuales el usuario actual o PUBLIC es el propietario, otorgante o concesionario del objeto
ALL_COL_PRIVS_MADE : enumera las concesiones de objetos de columna para las cuales el usuario actual es propietario o otorgante de objetos.
ALL_COL_PRIVS_RECD : describe las concesiones de objetos de columna para las cuales el usuario actual o PUBLIC es el concesionario
ALL_TAB_PRIVS : enumera las concesiones en objetos donde el usuario o PUBLIC es el concesionario
ALL_TAB_PRIVS_MADE : enumera todas las concesiones de objetos realizadas por el usuario actual o realizadas en los objetos propiedad de El usuario actual.
ALL_TAB_PRIVS_RECD : enumera las concesiones de objetos para las cuales el usuario o PUBLIC es el concesionario
DBA_COL_PRIVS : describe todas las concesiones de objetos de columna en la base de datos
DBA_TAB_PRIVS : enumera todas las concesiones de todos los objetos en la base de datos
DBA_ROLES : esta vista enumera todos los roles que existen en la base de datos, incluido el seguro Roles de aplicación. Tenga en cuenta que no incluye la función PUBLIC.
DBA_ROLE_PRIVS : Muestra los papeles otorgados a los usuarios y roles
DBA_SYS_PRIVS : privilegios del sistema Listas otorgados a los usuarios y roles
SESSION_ROLES : enumera todas las funciones que están habilitadas para el usuario actual. Tenga en cuenta que no incluye la función PUBLIC.
ROLE_ROLE_PRIVS: Esta vista describe los roles otorgados a otros roles. La información se proporciona solo sobre los roles a los que el usuario tiene acceso.
ROLE_SYS_PRIVS : esta vista contiene información sobre los privilegios del sistema otorgados a los roles. La información se proporciona solo sobre los roles a los que el usuario tiene acceso.
ROLE_TAB_PRIVS : esta vista contiene información sobre los privilegios de objeto otorgados a los roles. La información se proporciona solo sobre los roles a los que el usuario tiene acceso.
USER_COL_PRIVS : describe las concesiones de objetos de columna para las cuales el usuario actual es el propietario del objeto, el otorgante o el concesionario
USER_COL_PRIVS_MADE : describe las concesiones de objetos de columna para las cuales el usuario actual es el otorgante
USER_COL_PRIVS_RECD: Describe las concesiones de objetos de columna para las cuales el usuario actual es el concesionario
USER_ROLE_PRIVS : enumera los roles otorgados al usuario actual
USER_TAB_PRIVS: enumera las concesiones en todos los objetos donde el usuario actual es el concesionario
USER_SYS_PRIVS : enumera los privilegios del sistema otorgados al usuario actual
USER_TAB_PRIVS_MADE: enumera las concesiones en todos los objetos propiedad del usuario actual
USER_TAB_PRIVS_RECD: listas de objetos subvenciones para el cual el usuario actual es el concesionario
session_privs: Lista los privilegios que actualmente están habilitados para los usuarios
SESSION_ROLES: se enumeran las funciones que actualmente están habilitados para el usuario
