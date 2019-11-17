
---alter session set "_ORACLE_SCRIPT"=true; 
 
drop table equipos cascade constraints ;
drop table cronograma_partidos cascade constraints ;
drop table tipos_apuestas cascade constraints ;
drop table bancos cascade constraints ;
drop table comprobantes_documentos cascade constraints ;
drop table detalle_apuesta cascade constraints ;
drop table retiros cascade constraints ;
drop table AUDITORIA cascade constraints ;
drop table apuestas cascade constraints ;

drop table preferencias cascade constraints ;
drop table depositos cascade constraints ;
drop table usuarios cascade constraints ;

drop table medio_pago cascade constraints ;
drop table identificacion cascade constraints ;
drop table ciudades cascade constraints ;
drop table departamentos cascade constraints ;
drop table paises cascade constraints ;
drop table bonos cascade constraints ;
drop table limites_bloqueos cascade constraints ;
drop table legales cascade constraints ;

CREATE  TABLE equipos(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nombre varchar2(255) not null,
registro_activo VARCHAR2(255) NOT NULL
) TABLESPACE BET_ITM;

/*CONSTRAINTS equipos */
 alter table equipos
 add constraint CK_REGISTRO_ACTIVO_EQUIPOS
 CHECK (registro_activo IN ('Y','N'));
 


CREATE  TABLE cronograma_partidos(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY  PRIMARY KEY,
fecha TIMESTAMP NOT NULL,
id_equipo1 NUMBER(22,0) NOT NULL,
id_equipo2 NUMBER(22,0) NOT NULL,
ganador NUMBER(22,0),
goles_equipo1 NUMBER(22,0),
goles_equipo2 NUMBER(22,0),
ganador_tiempo1 NUMBER(22,0),
ganador_tiempo2 NUMBER(22,0),
goles_tiempo1 NUMBER(22,0),
goles_tiempo2 NUMBER(22,0),
estado VARCHAR2(255) NOT NULL,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;
/*CONSTRAINTS */
 alter table cronograma_partidos
 add constraint CK_REGISTRO_ACTIVO_CRONOGRAMA
 CHECK (registro_activo IN ('Y','N'));
 


CREATE TABLE tipos_apuestas(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY  PRIMARY KEY,
id_cronograma NUMBER(22,0) NOT NULL,
tipo_apuesta varchar2(255) NOT NULL,
porcentaje_equipo1 NUMBER(22,2),
porcentaje_equipo2 NUMBER(22,2),
porcentaje_empate NUMBER(22,2),
porcentaje_si NUMBER(22,2),
porcentaje_no NUMBER(22,2),
porcentaje_mas NUMBER(22,2),
porcentaje_menos NUMBER(22,2),
estado VARCHAR2(255) NOT NULL,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;

/*CONSTRAINTS */
 alter table tipos_apuestas
 add constraint CK_REGISTRO_ACTIVO_TIPOS_APUESTAS
 CHECK (registro_activo IN ('Y','N'));
 
 

CREATE TABLE bancos(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY  PRIMARY KEY,
nombre varchar2(255) NOT NULL,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;
 
 
/*CONSTRAINTS */
 alter table bancos
 add constraint CK_REGISTRO_ACTIVO_BANCOS
 CHECK (registro_activo IN ('Y','N'));
 
 
 
CREATE TABLE comprobantes_documentos(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY  PRIMARY KEY,
id_usuario NUMBER(22,0) NOT NULL,
tipo varchar2(255) NOT NULL,
tamaño NUMBER(22,2) NOT NULL,
extension varchar2(255) NOT NULL,
url varchar2(255) NOT NULL,
estado varchar2(255) NOT NULL,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;
  
 
/*CONSTRAINTS */
 alter table comprobantes_documentos
 add constraint CK_REGISTRO_ACTIVO_COMPROBANTES
 CHECK (registro_activo IN ('Y','N'));
 
 alter table comprobantes_documentos
 add constraint CK_OPCIONES_ESTADO_COMPROBANTES
 CHECK (estado IN ('PENDIENTE', 'EN PROCESO', 'RECHAZADA', 'EXITOSO'));
 
 
 
 
 
CREATE TABLE detalle_apuesta(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY  PRIMARY KEY,
id_apuesta NUMBER(22,0),
id_tipo_apuesta NUMBER(22,0),
estado VARCHAR2(255) NOT NULL,
opcion_equipo1 VARCHAR2(1) NOT NULL,
opcion_equipo2 VARCHAR2(1) NOT NULL,
opcion_empate VARCHAR2(1) NOT NULL,
opcion_si VARCHAR2(1) NOT NULL,
opcion_no VARCHAR2(1) NOT NULL,
opcion_mas VARCHAR2(1) NOT NULL,
opcion_menos VARCHAR2(1) NOT NULL,
valor_apostado NUMBER(22,0),
valor_ganado NUMBER(22,0),
porcentaje_equipo1_apostado NUMBER(22,0),
porcentaje_equipo2_apostado  NUMBER(22,0),
porcentaje_empate_apostado  NUMBER(22,0),
porcentaje_si_apostado  NUMBER(22,2),
porcentaje_no_apostado  NUMBER(22,2),
porcentaje_mas_apostado  NUMBER(22,2),
porcentaje_menos_apostado  NUMBER(22,2),
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;
  
 
/*CONSTRAINTS */
 alter table detalle_apuesta
 add constraint CK_REGISTRO_ACTIVO_DETALLE_APUESTA
 CHECK (registro_activo IN ('Y','N'));
 
 alter table detalle_apuesta
 add constraint CK_OPCIONES_ESTADO_DETALLE_APUESTA1
 CHECK (opcion_equipo1 IN ('Y', 'N'));
 
 
 alter table detalle_apuesta
 add constraint CK_OPCIONES_ESTADO_DETALLE_APUESTA2
 CHECK (opcion_equipo2 IN ('Y', 'N'));
 
 
 alter table detalle_apuesta
 add constraint CK_OPCIONES_ESTADO_DETALLE_APUESTA3
 CHECK (opcion_empate IN ('Y', 'N'));

 alter table detalle_apuesta
 add constraint CK_OPCIONES_ESTADO_DETALLE_APUESTA4
 CHECK (opcion_si IN ('Y', 'N'));
 
 alter table detalle_apuesta
 add constraint CK_OPCIONES_ESTADO_DETALLE_APUESTA5
 CHECK (opcion_no IN ('Y', 'N'));
 
  alter table detalle_apuesta
 add constraint CK_OPCIONES_ESTADO_DETALLE_APUESTA6
 CHECK (opcion_mas IN ('Y', 'N'));
 
 alter table detalle_apuesta
 add constraint CK_OPCIONES_ESTADO_DETALLE_APUESTA7
 CHECK (opcion_menos IN ('Y', 'N'));
  
 alter table detalle_apuesta
 add constraint CK_ESTADO_APUESTAS
 CHECK (estado IN ('Abierta','Ganada','Perdida','vendida','Cancelada','Reembolsada','Invalida','Rechazado','Pedido','Parte aprobada'));
 
 
 
 

 
CREATE TABLE retiros(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY  PRIMARY KEY,
id_usuario NUMBER(22,0) NOT NULL,
fecha_solicitud TIMESTAMP DEFAULT SYSDATE NOT NULL,
fecha_desembolso DATE,
id_banco NUMBER(22,0) NOT NULL,
estado varchar2(255) NOT NULL,
validacion_documentos varchar2(1) NOT NULL,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;
  
/*CONSTRAINTS */
 alter table retiros
 add constraint CK_REGISTRO_ACTIVO_RETIROS
 CHECK (registro_activo IN ('Y','N'));
  
 
alter table retiros
 add constraint CK_OPCIONES_ESTADO_RETIROS
 CHECK (estado IN ('PENDIENTE', 'EN PROCESO', 'RECHAZADA', 'EXITOSO'));
 
 
 
 create table AUDITORIA
(   id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY  PRIMARY KEY,
    fecha_hora TIMESTAMP DEFAULT SYSDATE NOT NULL,
    tabla varchar2(255) not null,
    record_id  NUMBER(22,0) NOT NULL,
    action varchar2(255) not null,
    usuario varchar2(255) not null,
    ip varchar2(255) not null,
    registro_activo VARCHAR2(1) NOT NULL
)
tablespace BET_AUDITING;


/*CONSTRAINTS */
 alter table AUDITORIA
 add constraint CK_REGISTRO_ACTIVO_AUDITORIA
 CHECK (registro_activo IN ('Y','N'));
 
 
  
 

 
 
 
  
CREATE  TABLE apuestas(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
fecha_apuesta TIMESTAMP DEFAULT SYSDATE NOT NULL,
id_usuario NUMBER(22,0) NOT NULL,
total NUMBER(22,0) NOT NULL,
total_ganado NUMBER(22,0),
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;


 alter table apuestas
 add constraint CK_APUESTAS_REGISTRO_ACTIVO
 CHECK (registro_activo IN ('Y','N'));
 



 
  
CREATE  TABLE preferencias(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_usuario NUMBER(22,0) NOT NULL,
idioma_correo varchar2(255) not null,
boletin_informativo varchar2(1) not null,
correo_apuestas_deporte varchar2(1) not null,
envio_sms varchar2(1) not null,
notificaciones_navegador varchar2(1) not null,
aviso_boleto_apuesta varchar2(1) not null,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;


 alter table preferencias
 add constraint CK_REGISTRO_ACTIVO_PREFERENCIAS
 CHECK (registro_activo IN ('Y','N'));
 
 
 alter table preferencias
 add constraint CK_BOLETIN_PREFERENCIAS
 CHECK (boletin_informativo IN ('Y','N'));


 alter table preferencias
 add constraint CK_CORREO_DEPORTE_PREFERENCIAS
 CHECK (correo_apuestas_deporte IN ('Y','N')); 
 
 

 alter table preferencias
 add constraint CK_ENVIO_SMS_PREFERENCIAS
 CHECK (envio_sms IN ('Y','N')); 

 
 alter table preferencias
 add constraint CK_NOTIFICACION_PREFERENCIAS
 CHECK (notificaciones_navegador IN ('Y','N'));


 alter table preferencias
 add constraint CK_AVISO_PREFERENCIAS
 CHECK (aviso_boleto_apuesta IN ('Y','N'));




  
CREATE  TABLE depositos(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_medio_pago NUMBER(22,0) not null,
id_usuario NUMBER(22,0) not NULL,
fecha_deposito TIMESTAMP DEFAULT SYSDATE NOT NULL,
valor NUMBER(22,0) NOT NULL,
estado varchar2(1) not null,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;

/*CONSTRAINTS */
 alter table depositos
 add constraint CK_REGISTRO_ACTIVO_DEPOSITOS
 CHECK (registro_activo IN ('Y','N'));
  
 
alter table depositos
 add constraint CK_OPCIONES_ESTADO_DEPOSITOS
 CHECK (estado IN ('PENDIENTE', 'EN PROCESO', 'RECHAZADA', 'EXITOSO'));
 
 
 
 
 
CREATE  TABLE usuarios(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nombre1 varchar2(255) not null,
nombre2 varchar2(255),
apellido1 varchar2(255) not null,
apellido2 varchar2(255),
id_identificacion NUMBER(22,0) not null,
nacionalidad varchar2(255) not null,
fecha_nacimiento DATE NOT NULL,
direccion varchar2(255) not null,
correo varchar2(255) not null,
contraseña varchar2(255) not null,
id_ciudad_residencia number(22,0) not null,
celular varchar2(255) not null,
direccion2 varchar2(255),
zona_horaria varchar2(255),
lugar_nacimiento varchar2(255) not null,
titulo varchar2(255) not null,
id_legales number(22,0) not null,
saldo NUMBER(22,0) NOT NULL,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;



/*CONSTRAINTS */
 alter table usuarios
 add constraint CK_REGISTRO_ACTIVO_USUARIOS
 CHECK (registro_activo IN ('Y','N'));
 
 
   
 
 
 
CREATE  TABLE medio_pago(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nombre VARCHAR2(255) NOT NULL,
valor_maximo NUMBER(22,0) not null,
valor_minimo NUMBER(22,0) NOT NULL,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;


/*CONSTRAINTS */
 alter table medio_pago
 add constraint CK_REGISTRO_ACTIVO_MEDIO_PAGO
 CHECK (registro_activo IN ('Y','N'));
  
 
 
 
CREATE  TABLE identificacion(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
numeroid NUMBER(22,0) not null,
tipo_doc VARCHAR2(255) NOT NULL,
fecha_expedicion date not null,
id_ciudad_expedicion NUMBER(22,0) not null,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;


/*CONSTRAINTS */
 alter table identificacion
 add constraint CK_REGISTRO_ACTIVO_IDENTIFICACION
 CHECK (registro_activo IN ('Y','N'));
  

 
 
 
CREATE  TABLE ciudades(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_departamento NUMBER(22,0) not null,
nombre varchar(255) not null,
codigo_zip VARCHAR2(255) NOT NULL,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;


/*CONSTRAINTS */
 alter table ciudades
 add constraint CK_REGISTRO_ACTIVO_CIUDADES
 CHECK (registro_activo IN ('Y','N'));
  

 
 
 
CREATE  TABLE departamentos(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nombre VARCHAR2(255) NOT NULL,
id_pais NUMBER(22,0) not null,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;


/*CONSTRAINTS */
 alter table departamentos
 add constraint CK_REGISTRO_ACTIVO_DEPARTAMENTOS
 CHECK (registro_activo IN ('Y','N'));
  
  
  

 
CREATE  TABLE paises(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nombre VARCHAR2(255) NOT NULL,
prefijo_pais VARCHAR2(255) not null,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;


/*CONSTRAINTS */
 alter table paises
 add constraint CK_REGISTRO_ACTIVO_PAIS
 CHECK (registro_activo IN ('Y','N'));
  
 
 

 
CREATE  TABLE bonos(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
codigo VARCHAR2(255) NOT NULL,
valor NUMBER(22,0) not null,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;


/*CONSTRAINTS */
 alter table bonos
 add constraint CK_REGISTRO_ACTIVO_BONO
 CHECK (registro_activo IN ('Y','N'));
ALTER TABLE BONOS ADD constraint FK_identificacion_unica_BONOS unique(codigo);
  
 
 
 
 
create  TABLE limites_bloqueos(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_usuario NUMBER(22,0) not null,
montodiario NUMBER(22,0),
montosemanal NUMBER(22,0),
montomensual NUMBER(22,0),
perdidadiario NUMBER(22,0),
perdidasemanal NUMBER(22,0),
perdidamensual NUMBER(22,0),
tiempo_cerrar_sesion NUMBER(22,0) not null,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;


/*CONSTRAINTS */
 alter table limites_bloqueos
 add constraint CK_REGISTRO_ACTIVO_limites_bloqueos
 CHECK (registro_activo IN ('Y','N'));
  
  alter table limites_bloqueos
 add constraint CK_MONTOdiario_limites_bloqueos
 CHECK (montodiario > 0);
  
 
CREATE  TABLE legales(
id NUMBER(22,0) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
terminos_condiciones VARCHAR2(1) NOT NULL,
autorizacion_recepcion_info VARCHAR2(1) NOT NULL,
registro_activo VARCHAR2(1) NOT NULL
) TABLESPACE BET_ITM;


/*CONSTRAINTS */
 alter table legales
 add constraint CK_REGISTRO_ACTIVO_legales
 CHECK (registro_activo IN ('Y','N'));
 
 alter table legales
 add constraint CK_TERMINOS_limites_legales
 CHECK (terminos_condiciones IN ('Y','N'));
 
 
 alter table legales
 add constraint CK_RECEPCIO_INFO_limites_legales
 CHECK (autorizacion_recepcion_info IN ('Y','N'));
  
  
  
  
  /*******CREAMOS LOS FK */
    
  ALTER TABLE cronograma_partidos ADD CONSTRAINT FK_EQUIPO1 FOREIGN KEY (id_equipo1)
	  REFERENCES equipos (id) ENABLE;
      
      
  ALTER TABLE cronograma_partidos ADD CONSTRAINT FK_EQUIPO2 FOREIGN KEY (id_equipo2)
	  REFERENCES equipos (id) ENABLE;
      
      
  ALTER TABLE tipos_apuestas ADD CONSTRAINT FK_CRONOGRAMA FOREIGN KEY (id_cronograma)
	  REFERENCES cronograma_partidos (id) ENABLE;
      
      
  ALTER TABLE detalle_apuesta ADD CONSTRAINT FK_APUESTA FOREIGN KEY (id_apuesta)
	  REFERENCES apuestas (id) ENABLE;
            
      
       ALTER TABLE detalle_apuesta ADD CONSTRAINT FK_TIPO_APUESTA FOREIGN KEY (id_tipo_apuesta)
	  REFERENCES tipos_apuestas (id) ENABLE;



       ALTER TABLE comprobantes_documentos ADD CONSTRAINT FK_USUARIO FOREIGN KEY (id_usuario)
	  REFERENCES usuarios (id) ENABLE;
      
      
       ALTER TABLE retiros ADD CONSTRAINT FK_BANCO FOREIGN KEY (id_banco)
	  REFERENCES bancos (id) ENABLE;
      
      
       ALTER TABLE retiros ADD CONSTRAINT FK_CUENTA_usuario_retiros FOREIGN KEY (id_usuario)
	  REFERENCES usuarios (id) ENABLE;


       ALTER TABLE apuestas ADD CONSTRAINT FK_USUARIO_apuestas FOREIGN KEY (id_usuario)
	  REFERENCES usuarios (id) ENABLE;
      
      
       ALTER TABLE depositos ADD CONSTRAINT FK_medio_pago FOREIGN KEY (id_medio_pago)
	  REFERENCES medio_pago (id) ENABLE;
      
      
       ALTER TABLE depositos ADD CONSTRAINT FK_cuenta_usuario_deposito FOREIGN KEY (id_usuario)
	  REFERENCES usuarios (id) ENABLE;
      
      
      
       ALTER TABLE usuarios ADD CONSTRAINT FK_identificacion FOREIGN KEY (id_identificacion)
	  REFERENCES identificacion (id) ENABLE;
      ALTER TABLE usuarios ADD constraint FK_identificacion_unica unique(id_identificacion);
      
      
      
      
       ALTER TABLE preferencias ADD CONSTRAINT FK_PREPRERENCIAS FOREIGN KEY (id_usuario)
	  REFERENCES usuarios (id) ENABLE;
      ALTER TABLE preferencias ADD constraint FK_preferencia_unica unique(id_usuario);
      
      
      
      
       ALTER TABLE usuarios ADD CONSTRAINT FK_CIUDAD_RESIDENCIA FOREIGN KEY (id_ciudad_residencia)
	  REFERENCES ciudades (id) ENABLE;
      ALTER TABLE usuarios ADD constraint FK_ciudad_residencia_unica unique(id_ciudad_residencia);
      
        
      
      
       ALTER TABLE usuarios ADD CONSTRAINT FK_LEGALES FOREIGN KEY (id_legales)
	  REFERENCES legales (id) ENABLE;
      
      
      
      
      
      
       ALTER TABLE identificacion ADD CONSTRAINT FK_ciudad_expedicion FOREIGN KEY (id_ciudad_expedicion)
	  REFERENCES ciudades (id) ENABLE;
      
      
       ALTER TABLE ciudades ADD CONSTRAINT FK_departamentos FOREIGN KEY (id_departamento)
	  REFERENCES departamentos (id) ENABLE;
      
      
       ALTER TABLE departamentos ADD CONSTRAINT FK_paises FOREIGN KEY (id_pais)
	  REFERENCES paises (id) ENABLE;
      
      
       ALTER TABLE limites_bloqueos ADD CONSTRAINT FK_usuario_bloqueos FOREIGN KEY (id_usuario)
	  REFERENCES usuarios (id) ENABLE;
      
      