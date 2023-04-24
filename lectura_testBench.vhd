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

    signal reset: std_logic := '0';
    signal clk: std_logic := '0';
    signal fifo_empty: std_logic := '0';
    signal fifo_word_rd: std_logic_vector(2 downto 0) := "101";
    signal finished: std_logic := '0';
    
    signal sentido: std_logic;
    signal ciclos: std_logic_vector(1 downto 0);
    signal read_fifo: std_logic;
    signal start: std_logic;
    
	
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
    	Process
  	begin
   	 clk <= '0';
    	wait for 100 ns;
   	 clk <= '1';
    	wait for 100 ns;
  	end process;
  	
  	Process
  	begin
   	 reset <= '1';
    	wait for 100 ns;
   	 reset <= '0';
    	wait;
  	end process;

    -- Proceso para establecer los valores de entrada en la simulación
   	sim_process: process
    	begin
    	
-------------------------------------------------------------------------------------------------------------------------------   	
------------------------------CASO 1: FIFO_WORD_RD = "101" POR LO QUE SENTIDO = 1 Y CICLOS = "01"------------------------------
------------------------------------------------------------------------------------------------------------------------------- 
   	
       	--SI FIFO_EMPTY = 0 y FINISHED = 0, el estado actual pasara a ser LECTURA
       	fifo_empty <= '0';
       	finished <= '0';
        --Una vez alcanzado el estado de LECTURA pasaré por los de START_MOTOR y WAIT_UNTIL_MOTOR directam
        --Leyendo de fifo_word_rd el '101' por lo que sentido = 1 y ciclos = 01
        wait for 100 ns;
        fifo_word_rd <= "101"; --INTRODUZCO EL VALOR DESEADO EN LA FIFO
        wait for 100 ns; 
        fifo_empty <= '1'; --Poniendo a 1 esta variable conseguiriamos quedarnos en el estado IDLE (en este caso 1 no ocurre porque al principio estamos poniendola siempre a 0)
        finished <= '1'; --Poniendo a 1 esta variable conseguiremos pasar del estado WAIT FOR MOTOR  a IDLE de nuevo
        wait for 100 ns;
  
  
  
--------------------------------------------------------------------------------------------------------------------------------------------------------------      
----------------------CASO 2: FIFO_WORD_RD = "101" POR LO QUE SENTIDO = 1 Y CICLOS = "01 pero NO ponemos FINISHED A 1 al final "------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------  
--        fifo_empty <= '0';
--        finished <= '0';
--        --Una vez alcanzado el estado de LECTURA pasaré por los de START_MOTOR y WAIT_UNTIL_MOTOR directam
--        --Leyendo de fifo_word_rd el '101' por lo que sentido = 1 y ciclos = 01
--        wait for 100 ns;
--        fifo_word_rd <= "101"; --INTRODUZCO EL VALOR DESEADO EN LA FIFO
--        wait for 100 ns; 
--        fifo_empty <= '1'; --Poniendo a 1 esta variable conseguiriamos quedarnos en el estado IDLE (en este caso 1 no ocurre porque al principio estamos poniendola siempre a 0)
--        --finished <= '1'; --Poniendo a 1 esta variable conseguiremos pasar del estado WAIT FOR MOTOR  a IDLE de nuevo
--        wait for 100 ns;


    end process;

end tb_lectura_arch;







