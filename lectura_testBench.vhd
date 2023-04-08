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
   	 CLK <= '0';
    	wait for 5 ns;
   	 CLK <= '1';
    	wait for 5 ns;
  	end process;

    -- Proceso para establecer los valores de entrada en la simulación
   	sim_process: process
    	begin
       	RESET <= '1'; --Asi el estado actual será IDLE
       	--SI FIFO_EMPTY /= 0 y FINISHED = 0, el estado actual pasara a ser LECTURA
       	FIFO_EMPTY <= '1';
       	FINISHED <= '0';
        --Una vez alcanzado el estado de LECTURA pasaré por los de START_MOTOR y WAIT_UNTIL_MOTOR directam
        --Leyendo de fifo_word_rd el '101' por lo que sentido = 1 y ciclos = 01
        
        --Ahora al poner reset = 0 entrare en el bucle de comprobar si clk cambia en vez de en el del reset.
        --Al tener fifo_empty == 0 y Finished = 1, me mantengo en el estado de espera 100ns y luego vuelvo a empezar
        wait for 50 ns; 
        RESET <= '0';
        FIFO_EMPTY <= '0';
        FINISHED <= '1';
        wait for 100 ns;
        assert false report "Fin de la simulación" severity failure;
    end process;

end tb_lectura_arch;


