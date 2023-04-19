library ieee;
use ieee.std_logic_1164.all;

entity gestor_lectura_tb is
end entity;

architecture tb_lectura_arch of gestor_lectura_tb is
    component gestor_lectura is
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
    end component;
	--ENTRADAS--
    signal reset: std_logic := '0';
    signal clk: std_logic := '0';
    signal fifo_empty: std_logic := '0';
    signal fifo_word_rd: std_logic_vector(2 downto 0) := "101";
    signal finished: std_logic := '0';
    --SALIDAS--
    signal sentido: std_logic;
    signal ciclos: std_logic_vector(1 downto 0);
    signal read_fifo: std_logic;
    signal start: std_logic;
	--INTERNAS--
	SIGNAL fin_test: std_logic := 0;
	
	--Constante para el ciclo de reloj--
	constant ciclo : time := 100 ns;
    
	
    begin
    uut: gestor_lectura port map (
        RESET => reset,
        CLK => clk,
        FIFO_EMPTY => fifo_empty,
        FIFO_WORD_RD => fifo_word_rd,
        FINISHED => finished,
        START => start,
        SENTIDO => sentido,
        CICLOS => ciclos,
        READ_FIFO => read_fifo
        
    );

    -- Generación de un reloj para la simulación
    GenCLK:	Process
  	begin
		IF(fin_test = '1')  THEN
			CLK <= '0';
			wait;
		ELSE
			CLK <= '0';
			wait for ciclo/2;
			CLK <= '1';
			wait for ciclo/2;
		END IF;
  	end process GenCLK;
  	
  	GenReset: Process
  	begin
		RESET <= '1';
		wait for ciclo*2;
		RESET <= '0';
		wait;
  	end process GenReset;

    -- Proceso para establecer los valores de entrada en la simulación
   	sim_process: process
    	begin
       	--SI FIFO_EMPTY /= 0 y FINISHED = 0, el estado actual pasara a ser LECTURA
       	FIFO_EMPTY <= '0';
       	FINISHED <= '0';
        --Una vez alcanzado el estado de LECTURA pasaré por los de START_MOTOR y WAIT_UNTIL_MOTOR directam
        --Leyendo de fifo_word_rd el '101' por lo que sentido = 1 y ciclos = 01
        --Ahora al poner reset = 0 entrare en el bucle de comprobar si clk cambia en vez de en el del reset.
        --Al tener fifo_empty == 0 y Finished = 1, me mantengo en el estado de espera 100ns y luego vuelvo a empezar
        wait for ciclo;
        FIFO_WORD_RD <= "101";
        wait for ciclo; 
        FIFO_EMPTY <= '0';
        FINISHED <= '1';
        wait for ciclo;
		fin_test <= '1';
		wait;
    end process sim_process;

end tb_lectura_arch;





