library ieee;
use ieee.std_logic_1164.all;

entity gestor_escritura_tb is
end entity;

architecture tb_escritura_arch of gestor_escritura_tb is
    component gestor_escritura is
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
    end component;

    signal reset: std_logic := '0';
    signal clk: std_logic := '0';
    signal fifo_full: std_logic := '0';
    signal button_1: std_logic := '0';
    signal button_2: std_logic := '0';
    signal word_fifo_wr: std_logic_vector(2 downto 0);
    signal write_fifo: std_logic;
    signal led: std_logic;
    
	
    begin
    uut: gestor_escritura port map (
        RESET => reset,
        CLK => clk,
        FIFO_FULL => fifo_full,
        BUTTON_1 => button_1,
        BUTTON_2 => button_2,
        LED => led,
        WRITE_FIFO => write_fifo,
        WORD_FIFO_WR => word_fifo_wr
        
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
    	
       	RESET <= '1'; --Asi el estado actual será REPOSO
       	
       	--SI FIFO_Button_! OR button_" == 1 AND FIFO_FULL == 0, el estado actual pasara a ser ESCRITURA
       	--Para este caso activo el boton 1
       	FIFO_FULL <= '0';
       	BUTTON_1 <= '1'; 
       	BUTTON_2 <='0';     
        wait for 50 ns; 
        --Ahora estoy en escritura y tengo que poner a 1 el WRITE_fIFO
        WRITE_FIFO <= '1';
        --Al ser el boton 1 el accionado en este ejemplo y la constante 01 ---> "101" es lo que ira en WORD_FIFO_WR
        WORD_FIFO_WR <= "101";
        wait for 50 ns;
        --Ahora pongo las condiciones para volver desde ESCRITURA a REPOSO, pudiendose darse que los dos boones esten a cero o que FIFO_FULL=1, pongo las dos por si acaso
        BUTTON_1 <= '0';
        FIFO_FULL <= '1';
        wait for 50 ns;
        assert false report "Fin de la simulación" severity failure;
    end process;
end tb_escritura_arch;

