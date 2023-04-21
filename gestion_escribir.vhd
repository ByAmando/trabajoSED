library ieee;
use ieee.std_logic_1164.all;

entity gestor_escritura is
    port (
        -- ENTRADAS --
        BUTTON_1: in std_logic;
        BUTTON_2: in std_logic;
        FIFO_FULL: in std_logic;
        RESET: in std_logic;
        CLK: in std_logic;
        -- SALIDAS
        WRITE_FIFO: out std_logic;
      	WORD_FIFO_WR : out std_logic_vector(2 downto 0); 
        LED : out std_logic
    );
end entity;

architecture arch_gestor_escritura of gestor_escritura is
	TYPE ESTADOS_FIFO IS(REPOSO, ESCRITURA);
	--estado_c = Señal que contiene el estado siguiente y procede de un proceso combinacional --
	--estado_s = Señal que contiene el estado actual de los biestables
	SIGNAL estado_c, estado_s: ESTADOS_FIFO;
	
	SIGNAL WORD_FIFO_WR_aux : std_logic_vector (2 downto 0) := "000";
	

    -- AHORA HABRIA QUE IMPLEMENTAR MAQUINA DE MOORE --
BEGIN
	
	
	--ESTE PROCESO NO SE SI HARIA FALTA
	PROCESS(CLK, RESET)
	BEGIN
		IF (RESET = '1') THEN
			estado_s <= REPOSO;
			WORD_FIFO_WR <= "000";
		ELSIF (CLK'EVENT) AND (CLK='1') THEN		-- Este proceso hace la asignacion del estado_s
			estado_s <= estado_c;
			WORD_FIFO_WR <= WORD_FIFO_WR_aux;
		END IF;
	END PROCESS;
		
		
		
	PROCESS (estado_s, BUTTON_1, BUTTON_2, FIFO_FULL)

	BEGIN
		CASE estado_s is				--Este proceso (Maquina Moore) hace lo que seria el diagrama de bolas para pasar de un estado a otro.
			WHEN REPOSO =>
				WRITE_FIFO <= '0';		
				IF ((BUTTON_1 = '1') OR (BUTTON_2 = '1')) AND (FIFO_FULL = '0') THEN
					estado_c <= ESCRITURA;					
				END IF;
				IF ((BUTTON_1 = '1') AND (BUTTON_2 = '1')) THEN --Para el caso de que se pulsen los dos botones a la vez
					estado_c <= REPOSO;
				END IF;
				IF (FIFO_FULL = '1') THEN
					LED <= '1';
				ELSIF (FIFO_FULL = '0') THEN 
					LED <= '0';			
				END IF;
			WHEN ESCRITURA =>
				WRITE_FIFO <= '1';
				IF ((BUTTON_1 = '1') AND (FIFO_FULL = '0')) THEN
					WORD_FIFO_WR_aux <= "101"; --EL bit mas significativo indica que es el boton 1 el pulsado y el resto de bits tienen la constante "01"
				END IF;
				IF ((BUTTON_2 = '1') AND (FIFO_FULL = '0')) THEN
					WORD_FIFO_WR_aux <= "001";
				END IF;
				IF ((BUTTON_1 = '0') AND (BUTTON_2 = '0')) OR (FIFO_FULL = '1') THEN --Para volver a reposo si se da que no hay botones pulsados o cola llena
					WORD_FIFO_WR_aux <= "000";
					estado_c <= REPOSO;
					
				END IF;
			WHEN OTHERS =>
				estado_c <= REPOSO;
		END CASE;
	END PROCESS;
END arch_gestor_escritura;


    











