library ieee;
use ieee.std_logic_1164.all;

entity gestor_lectura is
    port (
        -- ENTRADAS --
        CLK : in std_logic;
        RESET : in std_logic;
        FIFO_EMPTY : in std_logic;
        FIFO_WORD_RD : in std_logic_vector(2 downto 0);
        FINISHED : in std_logic;
        -- SALIDAS
        READ_FIFO: out std_logic;
        SENTIDO: out std_logic;
        CICLOS: out std_logic_vector(1 downto 0);
        START: out std_logic
    );
end entity;

architecture arch_gestor_lectura of gestor_lectura is
	TYPE ESTADOS_FIFO IS(IDLE, LECTURA, START_MOTOR, WAIT_FOR_MOTOR);
	--estado_c = Señal que contiene el estado siguiente y procede de un proceso combinacional --
	--estado_s = Señal que contiene el estado actual de los biestables
	SIGNAL estado_c, estado_s: ESTADOS_FIFO; 
	
	signal sentido_aux: std_logic;
	signal start_aux: std_logic;
	signal read_fifo_aux: std_logic;
	signal ciclos_aux: std_logic_vector (1 downto 0);								
BEGIN	
	
	PROCESS(CLK, RESET)
	BEGIN
		IF (RESET = '1') THEN
			estado_s <= IDLE;
			SENTIDO <= '0';
			START <='0';
			READ_FIFO <= '0';
			CICLOS <= "00";
		ELSIF (CLK'EVENT) AND (CLK='1') THEN		-- Este proceso hace la asignacion del estado_s
			estado_s <= estado_c;
			SENTIDO <= sentido_aux;
			START <= start_aux;
			READ_FIFO <= read_fifo_aux;
			CICLOS <= ciclos_aux;
			
		END IF;
	END PROCESS;
		
	PROCESS (estado_s, FIFO_WORD_RD, FIFO_EMPTY, FINISHED)	
	BEGIN
		
		CASE estado_s is				--Este proceso hace lo que seria el diagrama de bolas para pasar de un estado a otro.
			WHEN IDLE =>
				read_fifo_aux <= '0';
				start_aux <= '0';
				sentido_aux <= '0';   --El bit + significativo es el del sentido 
				ciclos_aux <= "00";
				IF (FIFO_EMPTY /= '0' ) AND (FINISHED = '0') THEN  
					estado_c <= LECTURA;
				END IF;
			WHEN LECTURA =>
				read_fifo_aux <= '1';				
				estado_c <= START_MOTOR;
				
			WHEN START_MOTOR =>
				read_fifo_aux <= '0';
				start_aux <= '1';
				sentido_aux <= FIFO_WORD_RD(2);   --El bit + significativo es el del sentido 
				ciclos_aux <= FIFO_WORD_RD (1 downto 0); --El resto de bits son el numero de ciclos				
				estado_c <=WAIT_FOR_MOTOR;					
				
			WHEN WAIT_FOR_MOTOR =>
				start_aux <= '0';
				sentido_aux <= FIFO_WORD_RD(2);   
				ciclos_aux <= FIFO_WORD_RD (1 downto 0); 				
				IF( FINISHED = '1') THEN
					estado_c <= IDLE;
				END IF;
			WHEN OTHERS =>
				estado_c <= IDLE;
		END CASE;
	END PROCESS;
END arch_gestor_lectura;
    








