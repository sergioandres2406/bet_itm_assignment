CREATE OR REPLACE FUNCTION f_validar_movimiento (
    id_usuarios   NUMBER,
    monto         NUMBER,
    movimiento    NUMBER
) RETURN NUMBER IS
    cantidad_documentos   NUMBER;
    saldo_actual          NUMBER;
    cantidad_bancos       NUMBER;
BEGIN
    SELECT
        u.saldo,
        nvl(cp.cantidad_documento, 0) cantidad_documento,
        nvl(b.cantidad_bancos, 0) cantidad_bancos
    INTO
        saldo_actual,
        cantidad_documentos,
        cantidad_bancos
    FROM
        usuarios u
        LEFT JOIN (
            SELECT
                id_usuario id_usuario,
                nvl(COUNT(*), 0) cantidad_documento
            FROM
                comprobantes_documentos
            GROUP BY
                id_usuario
        ) cp ON u.id = cp.id_usuario
        LEFT JOIN (
            SELECT
                id_usuario id_usuario,
                nvl(COUNT(*), 0) cantidad_bancos
            FROM
                bancovsusuarios
            GROUP BY
                id_usuario
        ) b ON u.id = b.id_usuario
    WHERE
        u.id = id_usuarios
        AND u.registro_activo = 'Y';


/*VERIFICA LA CANTIDAD DE DOCUMENTOS SEA IGUAL A 4 QUE SON LOS SIGUIENTES: 

A) Factura servicios públicos con nombre y dirección.
B) Comprobante de Depósito
C) Identificación con nombre y fecha de nacimiento
D) Foto personal sosteniendo su documento de identificación legible.

SI NO LOS TIENE RETORNA 1

VERIFICA LA CANTIDAD DE BANCOS QUE TIENE UN USUARIO Y TIPO MOVIMIENTO, SI NO LO TIENE 

TIPOS MOVIMIENTOS
1: RETIRO
2: DEPOSITO

RETORNA 2

VERIFICA EL SALDO ACTUAL SI ES NEGATIVO 
RETORNA 3  

*/

    CASE
        WHEN cantidad_documentos < 4 THEN
            RETURN 1;
        WHEN cantidad_bancos = 0 AND movimiento = 1 THEN
            RETURN 2;
        WHEN ( saldo_actual - monto ) < 0 AND movimiento = 1 THEN
            RETURN 3;
        ELSE
            RETURN 0;
    END CASE;

EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20001, 'USUARIO NO EXISTE');
END;

SELECT
    f_validar_movimiento(4545, 200, 1)
FROM
    dual;
    
    
--- =============================================================================================================
--- =============================================================================================================
--- =============================================================================================================


CREATE OR REPLACE PROCEDURE sp_crear_movimiento (
    id_usuario   NUMBER,
    monto        NUMBER,
    sw           NUMBER,
    formo_pago   NUMBER
) IS
BEGIN
    IF ( sw = 1 ) THEN
        INSERT INTO retiros (
            id_usuario,
            estado,
            valor,
            registro_activo
        ) VALUES (
            id_usuario,
            'PENDIENTE',
            monto,
            'Y'
        );

    ELSE
        INSERT INTO depositos (
            id_medio_pago,
            id_usuario,
            valor,
            estado,
            registro_activo
        ) VALUES (
            formo_pago,
            id_usuario,
            monto,
            'PENDIENTE',
            'Y'
        );

    END IF;
END;

EXEC sp_crear_movimiento(1, 20000, 2, 1);

--- =============================================================================================================
--- =============================================================================================================
--- =============================================================================================================


CREATE OR REPLACE PROCEDURE sp_validar_movimiento (
    id_usuario      NUMBER,
    sw              NUMBER,
    id_movimiento   NUMBER
) IS
    estado            NUMBER;
    monto             NUMBER;
    fp_valor_minino   NUMBER;
    fp_valor_maximo   NUMBER;
    forma_pago        NUMBER;
BEGIN
    IF sw = 1 THEN
        SELECT
            valor
        INTO monto
        FROM
            retiros
        WHERE
            id_usuario = id_usuario
            AND id = id_movimiento
            AND registro_activo = 'Y'
            AND estado = 'PENDIENTE';

    ELSE
        SELECT
            d.valor,
            mp.valor_minimo,
            mp.valor_maximo,
            mp.nombre
        INTO
            monto,
            fp_valor_minino,
            fp_valor_maximo,
            forma_pago
        FROM
            depositos    d
            INNER JOIN medio_pago   mp ON d.id_medio_pago = mp.id
        WHERE
            d.id_usuario = id_usuario
            AND d.id = id_movimiento
            AND d.registro_activo = 'Y'
            AND d.estado = 'PENDIENTE';

    END IF;

    SELECT
        f_validar_movimiento(id_usuario, monto, sw)
    INTO estado
    FROM
        dual;

    IF sw = 1 THEN
        CASE
            WHEN estado = 1 THEN
                UPDATE retiros
                SET
                    estado = 'RECHAZADA',
                    observaciones = 'EL MOVIMIENTO FUE RECHAZADA FALTA DOCUMENTACION'
                WHERE
                    id = id_movimiento;

            WHEN estado = 2 THEN
                UPDATE retiros
                SET
                    estado = 'RECHAZADA',
                    observaciones = 'NO TIENE NINGUN BANCO REGISTRADO'
                WHERE
                    id = id_movimiento;

            WHEN estado = 3 THEN
                UPDATE retiros
                SET
                    estado = 'RECHAZADA',
                    observaciones = 'SALDO INSUFICIENTE'
                WHERE
                    id = id_movimiento;

            WHEN estado = 0 THEN
                UPDATE retiros
                SET
                    estado = 'EXITOSO'
                WHERE
                    id = id_movimiento;
        END CASE;
    ELSE
        CASE
            WHEN estado = 1 THEN
                UPDATE depositos
                SET
                    estado = 'RECHAZADA',
                    observaciones = 'EL MOVIMIENTO FUE RECHAZADA FALTA DOCUMENTACION'
                WHERE
                    id = id_movimiento;

            WHEN estado = 2 THEN
                UPDATE depositos
                SET
                    estado = 'RECHAZADA',
                    observaciones = 'NO TIENE NINGUN BANCO REGISTRADO'
                WHERE
                    id = id_movimiento;

            WHEN estado = 3 THEN
                UPDATE depositos
                SET
                    estado = 'RECHAZADA',
                    observaciones = 'SALDO INSUFICIENTE'
                WHERE
                    id = id_movimiento;

            WHEN monto <fp_valor_minino or monto>fp_valor_maximo  THEN
                UPDATE depositos
                SET
                    estado = 'RECHAZADA',
                    observaciones = 'EL MONTOS MAXIMOS Y MINIMOS DE LA FORMA DE PAGO: '||forma_pago||', NO ESTA EN EL RANGO PERMITIDO.'
                WHERE
                    id = id_movimiento;

            WHEN estado = 0 THEN
                UPDATE depositos
                SET
                    estado = 'EXITOSO'
                WHERE
                    id = id_movimiento;
        END CASE;
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20001, 'EL USUARIO NO TIENE MOVIMIENTOS');
END;

EXEC sp_validar_movimiento(1, 1, 6)