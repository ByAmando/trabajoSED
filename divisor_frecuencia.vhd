library ieee;
use ieee.std_logic_1164.all;

entity divisor_frecuencia is
    port (
        -- ENTRADAS --
        CLK : in std_logic;
        RESET : in std_logic;
        -- SALIDAS
        CLK_SLOW : out std_logic
    );
end entity;

architecture arch_divisor_frecuencia of divisor_frecuencia is

    -- CODIGO DEL ALUMNO --
	
	-- DEFINICIONES --
	TYPE estado IS (slow, desborda);
	SIGNAL estActual, estFuturo : estado;

	SIGNAL CLK_SLOW_ANT : std_logic;

	CONSTANT F_CLK : INTEGER := 100000000;
	CONSTANT F_CLK_SLOW : INTEGER := 2;
	CONSTANT N_MAX : INTEGER := F_CLK / F_CLK_SLOW;
	
	SHARED VARIABLE CONTADOR : INTEGER := 0;
	
BEGIN
	
	-- DECLARACIONES --
	estActual <= slow;
	estFuturo <= slow;
	CLK_SLOW_ANT <= '0';
	CLK_SLOW <= CLK_SLOW_ANT;
	
	-- PROCESO DE SINCRONIZACION
	sincronizacion : PROCESS (RESET, CLK)
	BEGIN
	
		IF (RESET = '1') THEN
			CLK_SLOW_ANT <= '0';
			CLK_SLOW <= CLK_SLOW_ANT;
		ELSIF (CLK'EVENT) AND (CLK = '1') THEN
			CLK_SLOW <= CLK_SLOW_ANT;
			estActual <= estFuturo;
		END IF;
	
	END PROCESS sincronizacion;

	-- MAQUINA DE ESTADOS --
	maqEstados : PROCESS (estActual)
	BEGIN
	
		CASE estActual IS
			WHEN slow =>
				IF (CONTADOR < N_MAX) THEN
					estFuturo <= slow;
				ELSE
					estFuturo <= desborda;
				END IF;
				
				CONTADOR := CONTADOR + 1;
				
			WHEN desborda =>
				CLK_SLOW_ANT <= not CLK_SLOW_ANT;
				CONTADOR := 0;
				
				estFuturo <= slow;
				
		END CASE;
	END PROCESS maqEstados;

end architecture;
    

