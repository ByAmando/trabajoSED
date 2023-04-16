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

	-- ----------------------------------------------------------------------------
    	-- DEFINICIONES 
    	-- ----------------------------------------------------------------------------
	
	-- Estados --
	TYPE estado2 IS (reposo, cuenta_alto, alto);
	SIGNAL estActual2, estFuturo2 : estado2;
	
	-- Contadores --
	SIGNAL CICLOS : std_logic_vector ( 2 DOWNTO 0 );
	
	-- Señales intermedias --
	SIGNAL out_int : std_logic;  	-- Variables intermedias para almacenar el valor del boton final
	SIGNAL CICLOS_int : std_logic_vector ( 2 DOWNTO 0 );
    SIGNAL PRUEBA1, PRUEBA2 : std_logic;  	-- Variable para pruebas
		
BEGIN
   	-- ----------------------------------------------------------------------------
    	-- Se asigna “estActual2”. Proceso sincrono. Solo depende del reloj y de RESET. 
    	-- ----------------------------------------------------------------------------
	sincronizacion2 : PROCESS (RESET, CLK)
	BEGIN
	
		IF (RESET = '1') THEN 			-- Si pulsamos reset pasamos al estado reposo y reseteamos el valor del boton
			estActual2 <= reposo;
			BUTTON_OUT <= '0';
			CICLOS <= "000";
		ELSIF (CLK'EVENT) AND (CLK = '1') THEN
			estActual2 <= estFuturo2; 	-- En cada flanco de reloj hacemos estActual2 igual a estFuturo2
			BUTTON_OUT <= out_int; 	-- Usamos una variable intermedia out_int para pasarle el valor a BUTTON_OUT
			CICLOS <= CICLOS_int;  -- Usamos una variable intermedia CICLOS_int para pasarle el valor a CICLOS
		END IF;
	
	END PROCESS sincronizacion2;

	-- ------------------------------------------------------------------------
    	-- Se asigna la salida del boton.  Proceso combinacional.  
    	-- ------------------------------------------------------------------------
    maqEstados2 : PROCESS (estActual2)
	BEGIN		
		CASE estActual2 IS
			WHEN reposo =>
				
				IF (BUTTON_IN = '1') THEN
					estFuturo2 <= cuenta_alto;
				ELSE
					estFuturo2 <= reposo;
					out_int <= '0';
					CICLOS_int <= "000";
				END IF;	
				
			WHEN cuenta_alto =>
			
				IF (BUTTON_IN = '1') THEN
					IF (CICLOS = "110") THEN
						estFuturo2 <= alto;
						CICLOS_int <= "000";
					ELSE
						CICLOS_int <= std_logic_vector(unsigned(CICLOS) + 1);
PRUEBA1 <= '0';
PRUEBA2 <= '1';
					END IF;
				ELSE
PRUEBA1 <= '1';
PRUEBA2 <= '0';
					estFuturo2 <= reposo;
				END IF;	
				
			WHEN alto =>
				out_int <= '1';
				
				IF (BUTTON_IN = '1') THEN
					estFuturo2 <= alto;
				ELSE
					estFuturo2 <= reposo;		
				END IF;
				
		END CASE;
		
	END PROCESS maqEstados2;
        
end architecture;
    







