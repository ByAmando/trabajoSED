library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sistema is
    port (
        -- ENTRADAS --
        CLK : in std_logic;
        BUTTON_1 : in std_logic;
        BUTTON_2 : in std_logic;
        BUTON_RESET : in std_logic; -- Este es el botÃ³n de reset

        -- SALIDAS
        MOTOR_OUT: out std_logic_vector(3 downto 0)
    );
end entity;

architecture arch_sistema of sistema is
	
	SHARED VARIABLE FIFO_MAX: integer := 11;
	SHARED VARIABLE CONTADOR1 : INTEGER RANGE 0 to 255;
	CONSTANT F_CLK : INTEGER := 100000000;
	CONSTANT F_CLK_SLOW : INTEGER := 2;
	CONSTANT N_MAX : INTEGER := F_CLK / F_CLK_SLOW;
	SHARED VARIABLE CONTADOR : INTEGER := 0;
	SHARED VARIABLE CICLOS_ON : INTEGER RANGE 0 to 255;
	SHARED VARIABLE CICLOS_OFF : INTEGER RANGE 0 to 255;
	CONSTANT CICLOS_MIN : INTEGER := 7;
	
	TYPE estados1 IS (reposo, estado1, estado2, estado3, estado4, estado5, estado6, estado7, estado8);
	TYPE estados2 IS (slow, desborda);
	TYPE estados3 IS (alto, bajo);
	TYPE ESTADOS_FIFO_1 IS(IDLE, LECTURA, START_MOTOR, WAIT_FOR_MOTOR);
	TYPE ESTADOS_FIFO_2 IS(REPOSO, ESCRITURA);
	TYPE ESTADOS_FIFO_3 IS(REPOSO, ESCRITURA, LECTURA);
	
	SIGNAL FIFO_EMPTY : std_logic;
	SIGNAL FIFO_WORD_RD : std_logic_vector(2 downto 0);
	SIGNAL FINISHED :  std_logic;
	SIGNAL READ_FIFO:  std_logic;
	SIGNAL SENTIDO: std_logic;
	SIGNAL CICLOS: std_logic_vector(1 downto 0);
	SIGNAL START: std_logic;
	SIGNAL FIFO_FULL: std_logic;
	SIGNAL WRITE_FIFO: std_logic;
	SIGNAL WORD_FIFO_WR: std_logic_vector(2 downto 0);
	SIGNAL LED: std_logic;
	SIGNAL CLK_SLOW : std_logic;
	SIGNAL CLK_SLOW_ANT : std_logic;
	SIGNAL BUTTON_OUT : std_logic;
	SIGNAL BUTTON_IN : std_logic;
	
	SIGNAL estActual1, estFuturo1 : estados1;
	SIGNAL estActual2, estFuturo2 : estados2;
	SIGNAL estActual3, estFuturo3 : estados3;
	SIGNAL estado_c1, estado_s1: ESTADOS_FIFO_1; 	
	SIGNAL estado_c2, estado_s2: ESTADOS_FIFO_2;
	SIGNAL estado_c3, estado_s3: ESTADOS_FIFO_3;
	

	
	--CREAMOS UN NUEVO TIPO DE SEÑAL LLAMADA tipo_FIFO_DATA que consiste en un array de 12
	--componentes y cada componente es un std_logic_vector de 3 bits.
	type tipo_FIFO_DATA is array(0 to FIFO_MAX) of std_logic_vector(2 downto 0);
	signal FIFO_DATA: tipo_FIFO_DATA:= (others=>(others=>'0'));
    	
	--Definimos e instanciamos los punteros que vamos a usar para recorrer el array de arriba
	--Definimos e instanciamos una variable que lleve la cuenta de las palabras en cola.
	signal WRITE_POINTER: integer range 0 to FIFO_MAX := 0;
	signal READ_POINTER: integer range 0 to FIFO_MAX := 0;
	signal FIFO_COUNT: integer range 0 to FIFO_MAX := 0;

		
	
BEGIN


	-- DECLARACIONES --
	estActual1 <= reposo;
	estFuturo1 <= reposo;
	MOTOR_OUT <= (OTHERS => '0');
	FINISHED <= '0';
	
	-- PROCESO DE SINCRONIZACION
	sincronizacion1 : PROCESS (BUTON_RESET, CLK_SLOW)
	BEGIN
	
		IF (BUTON_RESET = '1') THEN
			MOTOR_OUT <= "0000";
		ELSIF (CLK_SLOW'EVENT) AND (CLK_SLOW = '1') THEN
			estActual1 <= estFuturo1;
			
		END IF;
	
	END PROCESS sincronizacion1;
	
	-- MAQUINA DE ESTADOS --
	maqEstados1 : PROCESS (estActual1)
	BEGIN
	
		CASE estActual1 IS
			WHEN reposo =>
				FINISHED <= '0';
				MOTOR_OUT <= "0000";
				
				IF (START = '1') THEN
					IF (SENTIDO = '1') THEN
						estFuturo1 <= estado1;
					ELSE
						estFuturo1 <= estado7;
					END IF;
				ELSE
					estFuturo1 <= reposo;
				END IF;
			WHEN estado1 =>
				MOTOR_OUT <= "1000";
				
				IF (SENTIDO = '1') THEN
					estFuturo1 <= estado2;
				ELSE
				
					CONTADOR1 := to_integer(unsigned(CICLOS) - 1);
					IF (CONTADOR1 /= 0) THEN
						estFuturo1 <= estado8;
					ELSE
						FINISHED <= '1';
						estFuturo1 <= reposo;
					END IF;
				END IF;
			WHEN estado2 =>
				MOTOR_OUT <= "1100";
				
				IF (SENTIDO = '1') THEN
					estFuturo1 <= estado3;
				ELSE
					estFuturo1 <= estado1;
				END IF;
			WHEN estado3 =>
				MOTOR_OUT <= "0100";
				
				IF (SENTIDO = '1') THEN
					estFuturo1 <= estado4;
				ELSE
					estFuturo1 <= estado2;
				END IF;
			WHEN estado4 =>
				MOTOR_OUT <= "0110";
				
				IF (SENTIDO = '1') THEN
					estFuturo1 <= estado5;
				ELSE
					estFuturo1 <= estado3;
				END IF;
			WHEN estado5 =>
				MOTOR_OUT <= "0010";
				
				IF (SENTIDO = '1') THEN
					estFuturo1 <= estado6;
				ELSE
					estFuturo1 <= estado4;
				END IF;
			WHEN estado6 =>
				MOTOR_OUT <= "0011";
				
				IF (SENTIDO = '1') THEN
					estFuturo1 <= estado7;
				ELSE
					estFuturo1 <= estado5;
				END IF;
			WHEN estado7 =>
				MOTOR_OUT <= "0001";
				
				IF (SENTIDO = '1') THEN
				
					CONTADOR1 := to_integer(unsigned(CICLOS) - 1);
					
					IF (CONTADOR1 /= 0) THEN
						estFuturo1 <= estado8;
					ELSE
						FINISHED <= '1';
						estFuturo1 <= reposo;
					END IF;
				ELSE
					estFuturo1 <= estado6;
				END IF;
			WHEN estado8 =>
				MOTOR_OUT <= "1001";
				
				IF (SENTIDO = '1') THEN
					estFuturo1 <= estado1;
				ELSE
					estFuturo1 <= estado7;
				END IF;
		END CASE;
END PROCESS maqEstados1;


-----------MODULO DE FRECUENCIA-----------------

-- DEFINICIONES --

	
	-- DECLARACIONES --
	estActual2 <= slow;
	estFuturo2 <= slow;
	CLK_SLOW_ANT <= '0';
	CLK_SLOW <= CLK_SLOW_ANT;
	
	-- PROCESO DE SINCRONIZACION
	sincronizacion2 : PROCESS (BUTON_RESET, CLK)
	BEGIN
	
		IF (BUTON_RESET = '1') THEN
			CLK_SLOW_ANT <= '0';
			CLK_SLOW <= CLK_SLOW_ANT;
		ELSIF (CLK'EVENT) AND (CLK = '1') THEN
			CLK_SLOW <= CLK_SLOW_ANT;
			estActual2 <= estFuturo2;
		END IF;
	
	END PROCESS sincronizacion2;

	-- MAQUINA DE ESTADOS --
	maqEstados2 : PROCESS (estActual2)
	BEGIN
	
		CASE estActual2 IS
			WHEN slow =>
				IF (CONTADOR < N_MAX) THEN
					estFuturo2 <= slow;
				ELSE
					estFuturo2 <= desborda;
				END IF;
				
				CONTADOR := CONTADOR + 1;
				
			WHEN desborda =>
				CLK_SLOW_ANT <= not CLK_SLOW_ANT;
				CONTADOR := 0;
				
				estFuturo2 <= slow;
				
		END CASE;
END PROCESS maqEstados2;



-----------MODULO DE ANTIREBOTES----------------


	-- DECLARACIONES --
	estActual3 <= bajo;
	estFuturo3 <= bajo;
	
	-- PROCESO DE SINCRONIZACION
	sincronizacion3 : PROCESS (BUTON_RESET, CLK)
	BEGIN
	
		IF (BUTON_RESET = '1') THEN
			BUTTON_OUT <= '0';
		ELSIF (CLK'EVENT) AND (CLK = '1') THEN
			estActual3 <= estFuturo3;
		END IF;
	
	END PROCESS sincronizacion3;

	-- MAQUINA DE ESTADOS --
	maqEstados3 : PROCESS (estActual3)
	BEGIN
	
		CASE estActual3 IS
			WHEN alto =>
				IF (BUTTON_IN = '1') THEN
					estFuturo3 <= alto;
					
					CICLOS_ON := CICLOS_ON + 1;
					IF (CICLOS_ON = CICLOS_MIN) THEN
						BUTTON_OUT <= '1';
						CICLOS_ON := 0;
					END IF;
				ELSE
					estFuturo3 <= bajo;
					CICLOS_ON := 0;
				END IF;
			WHEN bajo =>
				IF (BUTTON_IN = '1') THEN
					estFuturo3 <= alto;
					CICLOS_OFF := 0;
				ELSE
					estFuturo3 <= bajo;
					
					CICLOS_OFF := CICLOS_OFF + 1;
					IF (CICLOS_OFF = CICLOS_MIN) THEN
						BUTTON_OUT <= '0';
						CICLOS_OFF := 0;
					END IF;
				END IF;
								
		END CASE;
	END PROCESS maqEstados3;


------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------MODULO LECTURA FIFO----------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
										
	
PROCESS(CLK, BUTON_RESET)
BEGIN
	IF (BUTON_RESET = '1') THEN
		estado_s1 <= IDLE;
	ELSIF (CLK'EVENT) AND (CLK='1') THEN		-- Este proceso hace la asignacion del estado_s
		estado_s1 <= estado_c1;
	END IF;
END PROCESS;
		
PROCESS (estado_s1, FIFO_WORD_RD, FIFO_EMPTY, FINISHED)	
BEGIN
		
	CASE estado_s1 is				--Este proceso hace lo que seria el diagrama de bolas para pasar de un estado a otro.
		WHEN IDLE =>
			IF (FIFO_EMPTY /= '0' ) AND (FINISHED = '0') THEN  
				SENTIDO <= '0';
				START <='0';
				READ_FIFO <= '0';	--Aunque estas variables valen ya 0 porque en este estado no se inicializan, yo las pongo a cero por si acaso.
				estado_c1 <= LECTURA;
			END IF;
		WHEN LECTURA =>
			READ_FIFO <= '1';				
			estado_c1 <= START_MOTOR;
				
		WHEN START_MOTOR =>
			READ_FIFO <= '0';
			START <= '1';
			SENTIDO <= FIFO_WORD_RD(2);   --El bit + significativo es el del sentido 
			CICLOS <= FIFO_WORD_RD (1 downto 0); --El resto de bits son el numero de ciclos				
			estado_c1 <=WAIT_FOR_MOTOR;					
				
		WHEN WAIT_FOR_MOTOR =>
			START <= '0'; --Se nos dice que se pone a cero
			SENTIDO <= FIFO_WORD_RD(2);
			CICLOS <= FIFO_WORD_RD (1 downto 0);
			IF( FINISHED = '1') THEN
				estado_c1 <= IDLE;
			END IF;
		WHEN OTHERS =>
			estado_c1 <= IDLE;
	END CASE;
END PROCESS;



------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------MODULO ESCRITURA FIFO------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

	
PROCESS(CLK, BUTON_RESET)
BEGIN
	IF (BUTON_RESET = '1') THEN
		estado_s2 <= REPOSO;
	ELSIF (CLK'EVENT) AND (CLK='1') THEN		-- Este proceso hace la asignacion del estado_s
		estado_s2 <= estado_c2;
	END IF;
END PROCESS;
		
		
		
PROCESS (estado_s2, BUTTON_1, BUTTON_2, FIFO_FULL)
	
BEGIN
		
	CASE estado_s2 is				--Este proceso (Maquina Moore) hace lo que seria el diagrama de bolas para pasar de un estado a otro.
		WHEN REPOSO =>
			IF ((BUTTON_1 = '1') OR (BUTTON_2 = '1')) AND (FIFO_FULL = '0') THEN
				estado_c2 <= ESCRITURA;				
			END IF;
		WHEN ESCRITURA =>
			WRITE_FIFO <= '1';
			IF ((BUTTON_1 = '1') AND (FIFO_FULL = '0')) THEN
				WORD_FIFO_WR <= "101"; --EL bit mas significativo indica que es el boton 1 el pulsado y el resto de bits tienen la constante "01"
			END IF;
			IF ((BUTTON_2 = '1') AND (FIFO_FULL = '0')) THEN
				WORD_FIFO_WR <= "001";
			END IF;
			IF ((BUTTON_1 = '0') AND (BUTTON_2 = '0')) OR (FIFO_FULL = '1') THEN
				estado_c2 <= REPOSO;
			END IF;
		WHEN OTHERS =>
			estado_c2 <= REPOSO;
	END CASE;
END PROCESS;





------------------------------------------------------------------------------------------------------------------------
--------------------------------------------MODULO FIFO CIRCULAR----------------------------------------------
------------------------------------------------------------------------------------------------------------------------

	
	
--ESTE PROCESO NO SE SI HARIA FALTA
PROCESS(CLK, BUTON_RESET)
BEGIN
	IF (BUTON_RESET = '1') THEN
		WRITE_POINTER <= 0;
            	READ_POINTER <= 0;
            	FIFO_COUNT <= 0;
            	FIFO_EMPTY <= '1';
            	FIFO_FULL <= '0';
            	FIFO_WORD_RD <= (others => '0');
		estado_s3 <= REPOSO;
	ELSIF (CLK'EVENT) AND (CLK='1') THEN		-- Este proceso hace la asignacion del estado_s
		estado_s3 <= estado_c3;
	END IF;
END PROCESS;
		
			
PROCESS (estado_s3, WRITE_FIFO, READ_FIFO, WORD_FIFO_WR)	
BEGIN
		
	CASE estado_s3 is				--Este proceso (Maquina Moore) hace lo que seria el diagrama de bolas para pasar de un estado a otro.
		WHEN REPOSO =>
			IF (FIFO_COUNT = 0) THEN
				FIFO_EMPTY <= '1';
			END IF;
			IF (FIFO_COUNT /= 0) THEN
				FIFO_EMPTY <= '0';
			END IF;
			IF (FIFO_COUNT = FIFO_MAX + 1) THEN
				FIFO_FULL <= '1';
			END IF;
			IF(FIFO_COUNT /= FIFO_MAX + 1) THEN
				FIFO_FULL <= '0';
			END IF;
			IF (WRITE_FIFO = '1') THEN
				estado_c3 <= ESCRITURA;
			END IF;
			IF (READ_FIFO = '1') THEN
				estado_c3 <= LECTURA;
			END IF;					
		WHEN ESCRITURA =>
			FIFO_DATA(WRITE_POINTER) <= WORD_FIFO_WR;
			WRITE_POINTER <= WRITE_POINTER + 1;
			IF (WRITE_POINTER = FIFO_MAX+1) THEN
				WRITE_POINTER <= 0;
			END IF;
			FIFO_COUNT <= FIFO_COUNT + 1;
			IF (WRITE_FIFO = '0') THEN
				estado_c3 <= REPOSO;
			END IF;	
		WHEN LECTURA =>
			FIFO_WORD_RD <= FIFO_DATA(READ_POINTER);
			READ_POINTER <= READ_POINTER + 1;
			IF (READ_POINTER = FIFO_MAX+1) THEN
				READ_POINTER <= 0;
			END IF;
			FIFO_COUNT <= FIFO_COUNT - 1;
			IF (READ_FIFO = '0') THEN
				estado_c3 <= REPOSO;
			END IF;									
		WHEN OTHERS =>
			estado_c3 <= REPOSO;
	END CASE;
END PROCESS;

end arch_sistema;
    
