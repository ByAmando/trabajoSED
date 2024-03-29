library ieee;
use ieee.std_logic_1164.all;

entity fifo is
	generic (
		FIFO_MAX: integer := 11   -- N�mero m�ximo de elementos en la FIFO
	);
    port (
        -- ENTRADAS --
        CLK : in std_logic;
        RESET : in std_logic;
        WRITE_FIFO : in std_logic;
        READ_FIFO : in std_logic;
        FIFO_WORD_WR : in std_logic_vector(2 downto 0);
        -- SALIDAS
        FIFO_WORD_RD : out std_logic_vector(2 downto 0);
        FIFO_EMPTY : out std_logic;
        FIFO_FULL : out std_logic
    );
    
end entity;



architecture arch_fifo of fifo is
	TYPE ESTADOS_FIFO IS(REPOSO, ESCRITURA, LECTURA);
	--estado_c = Se�al que contiene el estado siguiente y procede de un proceso combinacional --
	--estado_s = Se�al que contiene el estado actual de los biestables
	SIGNAL estado_c, estado_s: ESTADOS_FIFO;
	
	--CREAMOS UN NUEVO TIPO DE SE�AL LLAMADA tipo_FIFO_DATA que consiste en un array de 12
	--componentes y cada componente es un std_logic_vector de 3 bits.
	type tipo_FIFO_DATA is array(0 to FIFO_MAX) of std_logic_vector(2 downto 0);
    	signal FIFO_DATA: tipo_FIFO_DATA:= (others=>(others=>'0'));
    	
    	--Definimos e instanciamos los punteros que vamos a usar para recorrer el array de arriba
    	--Definimos e instanciamos una variable que lleve la cuenta de las palabras en cola.
    	signal WRITE_POINTER: integer := 0;
    	signal READ_POINTER: integer := 0;
    	signal FIFO_COUNT: integer := 0;
    	signal WRITE_POINTER_aux: integer := 0;
    	signal READ_POINTER_aux: integer := 0;
    	signal FIFO_COUNT_aux: integer := 0;
    	signal FIFO_EMPTY_aux: std_logic := '0';
    	signal FIFO_FULL_aux: std_logic := '0';
	
	

    -- AHORA HABRIA QUE IMPLEMENTAR MAQUINA DE MOORE --
BEGIN
	
	
	--ESTE PROCESO NO SE SI HARIA FALTA
	PROCESS(CLK, RESET)
	BEGIN
		IF (RESET = '1') THEN
            		FIFO_EMPTY <= '1';
            		FIFO_FULL <= '0';
			estado_s <= REPOSO;
		ELSIF (CLK'EVENT) AND (CLK='1') THEN		-- Este proceso hace la asignacion del estado_s
			estado_s <= estado_c;
			WRITE_POINTER <= WRITE_POINTER_aux;	
			--Tengo que comprobar aqui si el puntero de escritura esta en el limite para actualizarlo a tiempo
			IF (WRITE_POINTER_aux >= FIFO_MAX + 1) THEN
				WRITE_POINTER <= 0;
			END IF;
			READ_POINTER <= READ_POINTER_aux;
			--Tengo que comprobar aqui si el puntero de lectura esta en el limite para actualizarlo a tiempo
			IF (READ_POINTER_aux = FIFO_MAX) THEN
				READ_POINTER <= 0;
			END IF;
			--Actualizo el resto de se�ales
			FIFO_EMPTY <= FIFO_EMPTY_aux;
			FIFO_FULL <= FIFO_FULL_aux;
			FIFO_COUNT <= FIFO_COUNT_aux;

		END IF;
	END PROCESS;
		
			
	PROCESS (estado_s, WRITE_FIFO, READ_FIFO, FIFO_WORD_WR)	
	BEGIN
		
		CASE estado_s is				--Este proceso (Maquina Moore) hace lo que seria el diagrama de bolas para pasar de un estado a otro.
			WHEN REPOSO =>
				IF (FIFO_COUNT = 0) THEN
					FIFO_EMPTY_aux <= '1'; --No hay nada en la cola
				END IF;
				IF (FIFO_COUNT /= 0) THEN
					FIFO_EMPTY_aux <= '0'; --Indico que hay algo en la cola
				END IF;
				IF (FIFO_COUNT = FIFO_MAX + 1) THEN
					FIFO_FULL_aux <= '1';  --Indico que la cola esta llena
				END IF;
				IF(FIFO_COUNT /= FIFO_MAX + 1) THEN
					FIFO_FULL_aux <= '0'; --Indico que la cola aun no est� llena
				END IF;
				IF (WRITE_FIFO = '1') THEN
					estado_c <= ESCRITURA;
				END IF;
				IF (READ_FIFO = '1') THEN
					estado_c <= LECTURA;
				END IF;					
			WHEN ESCRITURA =>
				FIFO_DATA(WRITE_POINTER) <= FIFO_WORD_WR;
				WRITE_POINTER_aux <= WRITE_POINTER + 1;				
				FIFO_COUNT_aux <= FIFO_COUNT + 1;
				IF (WRITE_FIFO = '0') THEN
					estado_c <= REPOSO;
				END IF;	
			WHEN LECTURA =>
				FIFO_WORD_RD <= FIFO_DATA(READ_POINTER);
				READ_POINTER_aux <= READ_POINTER + 1;	
				FIFO_COUNT_aux <= FIFO_COUNT - 1;
				IF (READ_FIFO = '0') THEN
					estado_c <= REPOSO;
				END IF;									
			WHEN OTHERS =>
				estado_c <= REPOSO;
		END CASE;
	END PROCESS;
END arch_fifo;

    
    




