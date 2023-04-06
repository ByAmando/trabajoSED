library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncing is
    port (
        -- ENTRADAS --
        CLK : in std_logic;
        RESET : in std_logic;
        BUTTON_IN : in std_logic;
        -- SALIDAS
        BUTTON_OUT : out std_logic
    );
end entity;

architecture arch_debouncing of debouncing is

    -- CODIGO DEL ALUMNO --

	-- DEFINICIONES --
	TYPE estado IS (alto, bajo);
	SIGNAL estActual, estFuturo : estado;
	
	SHARED VARIABLE CICLOS_ON : INTEGER RANGE 0 to 255;
	SHARED VARIABLE CICLOS_OFF : INTEGER RANGE 0 to 255;
	
	CONSTANT CICLOS_MIN : INTEGER := 7;
		
BEGIN

	-- DECLARACIONES --
	estActual <= bajo;
	estFuturo <= bajo;
	
	-- PROCESO DE SINCRONIZACION
	sincronizacion : PROCESS (RESET, CLK)
	BEGIN
	
		IF (RESET = '1') THEN
			BUTTON_OUT <= '0';
		ELSIF (CLK'EVENT) AND (CLK = '1') THEN
			estActual <= estFuturo;
		END IF;
	
	END PROCESS sincronizacion;

	-- MAQUINA DE ESTADOS --
	maqEstados : PROCESS (estActual)
	BEGIN
	
		CASE estActual IS
			WHEN alto =>
				IF (BUTTON_IN = '1') THEN
					estFuturo <= alto;
					
					CICLOS_ON := CICLOS_ON + 1;
					IF (CICLOS_ON = CICLOS_MIN) THEN
						BUTTON_OUT <= '1';
						CICLOS_ON := 0;
					END IF;
				ELSE
					estFuturo <= bajo;
					CICLOS_ON := 0;
				END IF;
			WHEN bajo =>
				IF (BUTTON_IN = '1') THEN
					estFuturo <= alto;
					CICLOS_OFF := 0;
				ELSE
					estFuturo <= bajo;
					
					CICLOS_OFF := CICLOS_OFF + 1;
					IF (CICLOS_OFF = CICLOS_MIN) THEN
						BUTTON_OUT <= '0';
						CICLOS_OFF := 0;
					END IF;
				END IF;
								
		END CASE;
	END PROCESS maqEstados;
end architecture;
    


