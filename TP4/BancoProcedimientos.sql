use bancoFinal;
    
    -- punto 3
    DELIMITER //
    CREATE PROCEDURE verCuentas()
    BEGIN
	-- selecciona el nummero de cuenta y el saldo de la tabla cuentas
    select
    numero_cuenta, saldo
    from 
    cuentas;
    end //
	delimiter;
    call verCuentas()


    -- punto 4
    DELIMITER // 
    CREATE PROCEDURE CuentasConSaldoMayorQue(IN limite Decimal (10,2))
    BEGIN
    select
    numero_cuenta,
    saldo
    from cuentas
    where saldo>limite;
    end//
    delimiter;
    call CuentasConSaldoMayorQue(2000.00);
    
    
    
    -- punto 5
    DELIMITER //
    create procedure TotalMovimientosDelMes(IN cuenta INT, OUT total DECIMAL(10,2))
    BEGIN
		 SELECT IFNULL(SUM(
        CASE tipo
            WHEN 'Credito' THEN importe
            WHEN 'Debito' THEN -importe
            ELSE 0
        END
    ), 0)
    INTO total
    FROM movimientos
    WHERE numero_cuenta = cuenta
      AND MONTH(fecha) = MONTH(CURDATE())
      AND YEAR(fecha) = YEAR(CURDATE());
    end//
    delimiter ;
    
    
    -- punto 6
DELIMITER //

DROP PROCEDURE IF EXISTS DepositarMovimiento;
//
CREATE PROCEDURE DepositarMovimiento(
    IN p_cuenta INT,
    IN p_monto DECIMAL(10,2)
)
BEGIN
    INSERT INTO movimientos (numero_cuenta, fecha, tipo, importe)
    VALUES (p_cuenta, CURDATE(), 'CREDITO', p_monto);
    -- el trigger AFTER INSERT actualizará saldo e historial
END;
//
DELIMITER ;
    
    -- punto 7
DELIMITER //
DROP PROCEDURE IF EXISTS ExtraerMovimiento;
//
CREATE PROCEDURE ExtraerMovimiento(
    IN p_cuenta INT,
    IN p_monto DECIMAL(10,2)
)
BEGIN
    DECLARE saldo_actual DECIMAL(10,2);
    SELECT saldo INTO saldo_actual FROM cuentas WHERE numero_cuenta = p_cuenta;

    IF saldo_actual >= p_monto THEN
        INSERT INTO movimientos (numero_cuenta, fecha, tipo, importe)
        VALUES (p_cuenta, CURDATE(), 'DEBITO', p_monto);
        -- trigger saludará saldo e historial
    END IF;
END;
//
DELIMITER ;
    
    
    -- punto 8
DROP TRIGGER IF EXISTS tr_actualizar_saldo ;
DELIMITER //

CREATE TRIGGER tr_actualizar_saldo 
AFTER INSERT ON movimientos 
FOR EACH ROW -- SIEMPRE
BEGIN 
	IF NEW.tipo = 'Debito' THEN 
		UPDATE cuentas SET saldo = saldo - NEW.importe WHERE numero_cuenta = NEW.numero_cuenta ;
	ELSE 
		UPDATE cuentas SET saldo = saldo + NEW.importe WHERE numero_cuenta = NEW.numero_cuenta ;
    END IF;
    
END//


DELIMITER ; 

    
    -- punto 9
-- Eliminamos el trigger anterior antes de volver a crearlo
DROP TRIGGER IF EXISTS tr_actualizar_saldo;

DELIMITER //

CREATE TRIGGER tr_actualizar_saldo 
AFTER INSERT ON movimientos 
FOR EACH ROW
BEGIN 
    -- Declaramos variables locales para guardar el saldo anterior y el nuevo saldo
    DECLARE v_saldo_anterior DECIMAL(10,2);
    DECLARE v_saldo_actual DECIMAL(10,2);

    --  Obtenemos el saldo anterior de la cuenta antes de actualizar
    SELECT saldo INTO v_saldo_anterior
    FROM cuentas
    WHERE numero_cuenta = NEW.numero_cuenta;

    --  Actualizamos el saldo según el tipo de movimiento
    IF NEW.tipo = 'Debito' THEN 
        -- Si el movimiento es Débito, restamos el importe al saldo
        UPDATE cuentas 
        SET saldo = saldo - NEW.importe 
        WHERE numero_cuenta = NEW.numero_cuenta;
    ELSE 
        -- Si el movimiento es Crédito, sumamos el importe al saldo
        UPDATE cuentas 
        SET saldo = saldo + NEW.importe 
        WHERE numero_cuenta = NEW.numero_cuenta;
    END IF;

    --  Obtenemos el saldo actual (luego de la actualización)
    SELECT saldo INTO v_saldo_actual
    FROM cuentas
    WHERE numero_cuenta = NEW.numero_cuenta;

    -- Insertamos un registro en el historial de movimientos
    -- Guardamos el número de cuenta, el movimiento, y los saldos antes y después
    INSERT INTO historial_movimientos (
        numero_cuenta,
        numero_movimiento,
        saldo_anterior,
        saldo_actual
    ) 
    VALUES (
        NEW.numero_cuenta,       -- Cuenta afectada
        NEW.numero_movimiento,   -- Movimiento que generó el cambio
        v_saldo_anterior,        -- Saldo antes del movimiento
        v_saldo_actual           -- Saldo después del movimiento
    );

END//
DELIMITER ;


-- EJERCICIO 10

DELIMITER //

DROP PROCEDURE IF EXISTS TotalMovimientosDelMes;
//
CREATE PROCEDURE TotalMovimientosDelMes(
    IN in_cuenta INT,               -- número de cuenta a consultar
    OUT out_total DECIMAL(10,2)     -- total de movimientos del mes actual
)
BEGIN
    DECLARE v_importe DECIMAL(10,2);
    DECLARE v_tipo ENUM('Credito','Debito');
    DECLARE fin BOOLEAN DEFAULT FALSE;

    -- Cursor que obtiene los movimientos del mes actual para la cuenta indicada
    DECLARE cur_movimientos CURSOR FOR
        SELECT importe, tipo
        FROM movimientos
        WHERE numero_cuenta = in_cuenta
          AND MONTH(fecha) = MONTH(CURDATE())
          AND YEAR(fecha) = YEAR(CURDATE());  -- para asegurar mismo año

    -- Manejador de fin de cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

    -- Inicializamos el total en 0
    SET out_total = 0;

    -- Abrimos el cursor
    OPEN cur_movimientos;

    -- Recorremos los movimientos del mes actual
    loop_cursor: LOOP
        FETCH cur_movimientos INTO v_importe, v_tipo;

        IF fin THEN
            LEAVE loop_cursor;
        END IF;

        -- Sumamos o restamos según el tipo de movimiento
        IF v_tipo = 'Credito' THEN
            SET out_total = out_total + v_importe;
        ELSE
            SET out_total = out_total - v_importe;
        END IF;

    END LOOP loop_cursor;

    -- Cerramos el cursor
    CLOSE cur_movimientos;

END//
DELIMITER ;

    
-- EJERCICIO 11
DELIMITER //

DROP PROCEDURE IF EXISTS AplicarInteres;
//
CREATE PROCEDURE AplicarInteres(
    IN in_porcentaje DECIMAL(5,2),   -- porcentaje en formato 2.00 = 2%
    IN in_saldoMinimo DECIMAL(10,2)
)
BEGIN
    DECLARE v_numeroCuenta INT;
    DECLARE v_saldo DECIMAL(10,2);
    DECLARE v_interes DECIMAL(10,2);
    DECLARE fin BOOLEAN DEFAULT FALSE;

    DECLARE cur_cuentas CURSOR FOR
        SELECT numero_cuenta, saldo
        FROM cuentas
        WHERE saldo > in_saldoMinimo;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;
    
    OPEN cur_cuentas; 
    loop_cursor : LOOP 
		FETCH cur_cuentas INTO v_numeroCuenta, v_saldo;
        
        IF fin THEN
			leave loop_cursor;
        END IF ;
        
        SET v_interes = v_saldo * (in_porcentaje / 100);
        SET v_saldo = v_saldo + v_interes;
        UPDATE cuentas SET saldo = v_saldo WHERE numero_cuenta = v_numeroCuenta ;
        
    END LOOP loop_cursor;
    CLOSE cur_cuentas;
END//
DELIMITER ;
