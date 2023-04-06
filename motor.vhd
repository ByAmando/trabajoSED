library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity motor_stepper is
    port (
		-- ENTRADAS --
        CLK : in std_logic;
        RESET : in std_logic;
        CLK_SLOW : in std_logic;
        START : in std_logic;
        SENTIDO: in std_logic;
		CICLOS: in std_logic_vector(1 downto 0);
        -- SALIDAS
        MOTOR_OUT: out std_logic_vector(3 downto 0);
        FINISHED: out std_logic
    );
end entity;

architecture arch_motor_stepper of motor_stepper is

    -- CODIGO DEL ALUMNO --
	
	-- DEFINICIONES --
	TYPE estado IS (reposo, estado1, estado2, estado3, estado4, estado5, estado6, estado7, estado8);
	SIGNAL estActual, estFuturo : estado;
	
	SHARED VARIABLE CONTADOR : INTEGER RANGE 0 to 255;
	
BEGIN
	
	-- DECLARACIONES --
	estActual <= reposo;
	estFuturo <= reposo;
	MOTOR_OUT <= (OTHERS => '0');
	FINISHED <= '0';
	
	-- PROCESO DE SINCRONIZACION
	sincronizacion : PROCESS (RESET, CLK_SLOW)
	BEGIN
	
		IF (RESET = '1') THEN
			MOTOR_OUT <= "0000";
		ELSIF (CLK_SLOW'EVENT) AND (CLK_SLOW = '1') THEN
			estActual <= estFuturo;
			
		END IF;
	
	END PROCESS sincronizacion;
	
	-- MAQUINA DE ESTADOS --
	maqEstados : PROCESS (estActual)
	BEGIN
	
		CASE estActual IS
			WHEN reposo =>
				FINISHED <= '0';
				MOTOR_OUT <= "0000";
				
				IF (START = '1') THEN
					IF (SENTIDO = '1') THEN
						estFuturo <= estado1;
					ELSE
						estFuturo <= estado7;
					END IF;
				ELSE
					estFuturo <= reposo;
				END IF;
			WHEN estado1 =>
				MOTOR_OUT <= "1000";
				
				IF (SENTIDO = '1') THEN
					estFuturo <= estado2;
				ELSE
				
					CONTADOR := to_integer(unsigned(CICLOS) - 1);
					IF (CONTADOR /= 0) THEN
						estFuturo <= estado8;
					ELSE
						FINISHED <= '1';
						estFuturo <= reposo;
					END IF;
				END IF;
			WHEN estado2 =>
				MOTOR_OUT <= "1100";
				
				IF (SENTIDO = '1') THEN
					estFuturo <= estado3;
				ELSE
					estFuturo <= estado1;
				END IF;
			WHEN estado3 =>
				MOTOR_OUT <= "0100";
				
				IF (SENTIDO = '1') THEN
					estFuturo <= estado4;
				ELSE
					estFuturo <= estado2;
				END IF;
			WHEN estado4 =>
				MOTOR_OUT <= "0110";
				
				IF (SENTIDO = '1') THEN
					estFuturo <= estado5;
				ELSE
					estFuturo <= estado3;
				END IF;
			WHEN estado5 =>
				MOTOR_OUT <= "0010";
				
				IF (SENTIDO = '1') THEN
					estFuturo <= estado6;
				ELSE
					estFuturo <= estado4;
				END IF;
			WHEN estado6 =>
				MOTOR_OUT <= "0011";
				
				IF (SENTIDO = '1') THEN
					estFuturo <= estado7;
				ELSE
					estFuturo <= estado5;
				END IF;
			WHEN estado7 =>
				MOTOR_OUT <= "0001";
				
				IF (SENTIDO = '1') THEN
				
					CONTADOR := to_integer(unsigned(CICLOS) - 1);
					
					IF (CONTADOR /= 0) THEN
						estFuturo <= estado8;
					ELSE
						FINISHED <= '1';
						estFuturo <= reposo;
					END IF;
				ELSE
					estFuturo <= estado6;
				END IF;
			WHEN estado8 =>
				MOTOR_OUT <= "1001";
				
				IF (SENTIDO = '1') THEN
					estFuturo <= estado1;
				ELSE
					estFuturo <= estado7;
				END IF;
		END CASE;
	END PROCESS maqEstados;

end architecture;
    



