library ieee;
use ieee.std_logic_1164.all;

entity gestor_fifo_tb is
end entity;

architecture tb_fifo_arch of gestor_fifo_tb is
    component fifo is
    	generic (
		FIFO_MAX: integer := 11   -- Número máximo de elementos en la FIFO
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
    end component;
	--ENTRADAS--
    signal reset: std_logic := '0';
    signal clk: std_logic := '0';
    signal write_fifo: std_logic := '0';
    signal read_fifo: std_logic := '0';
    signal fifo_word_wr: std_logic_vector(2 downto 0);
    --SALIDAS--
    signal fifo_full: std_logic := '0';
    signal fifo_empty: std_logic := '0';
    signal fifo_word_rd: std_logic_vector(2 downto 0);
    
	-- INTERNAS --
    SIGNAL fin_test:  std_logic := '0'; 
	constant ciclo : time := 100 ns;
    
	
    begin
    uut: fifo port map (
        RESET => reset,
        CLK => clk,
        WRITE_FIFO => write_fifo,
        READ_FIFO => read_fifo,
        FIFO_WORD_WR => fifo_word_wr,
        FIFO_FULL => fifo_full,
        FIFO_EMPTY => fifo_empty,
        FIFO_WORD_RD => fifo_word_rd  
        
    );

    -- Generación de un reloj para la simulación
    GenCLK: Process
  	begin
		IF (fin_test = '1') THEN
			CLK <= '0';
			wait;
		ELSE
			CLK <= '0';
			wait for ciclo;
			CLK <= '1';
			wait for ciclo;
  	end process GenCLK;
  	
  	GenRESET: Process
  	begin
   	 RESET <= '1';--Asi el estado actual será REPOSO y WRITE_POINTER <= 0; READ_POINTER <= 0;FIFO_EMPTY <= '1';FIFO_FULL <= '0';FIFO_WORD_RD <= (others => '0');
       			--Ademas se reinician punteros y contadores
    	wait for ciclo*2;
   	 RESET <= '0';
    	wait for ciclo*2;
  	end process GenRESET;
  	
  	sim_process: process
    	begin    	
       	--Si WRITE_FIFO == 1 pasaremos al modo ESCRITURA
       	WRITE_FIFO <= '1';
       	FIFO_WORD_WR <= "101"; --Pongo que lo que se escriba sea esto cuando toque
       	--Una vez en el modo ESCRITURA, se escribe en el sitio x lo que corresponda y se incrementan puntero y contador (esto se hace en el programa fifo, aqui no)
       	wait for ciclo;
       	--Salgo del modo ESCRITURA y me voy a REPOSO
       	WRITE_FIFO <= '0';
       	wait for ciclo*2;
       	
       	WRITE_FIFO <= '1';
       	FIFO_WORD_WR <= "001"; --Pongo que lo que se escriba sea esto cuando toque
       	--Una vez en el modo ESCRITURA, se escribe en el sitio x lo que corresponda y se incrementan puntero y contador (esto se hace en el programa fifo, aqui no)
       	wait for ciclo;
       	--Salgo del modo ESCRITURA y me voy a REPOSO
       	WRITE_FIFO <= '0';
       	wait for ciclo*2;

	--AHORA LEERE EL VALOR 101 QUE HE ESCRITO
       	
       	--SI READ_FIFO == 1 pasare al estado LECTURA
       	READ_FIFO <= '1';
       	--Una vez en el estado LECTURA se incrementara el puntero de lectura y el contador solos y se leera lo que haya ("101")   
        wait for ciclo; 
        --Ahora vuelvo al estado de reposo
        READ_FIFO <= '0' ;
        wait for ciclo*2;
        
        WRITE_FIFO <= '1';
       	FIFO_WORD_WR <= "100"; --Pongo que lo que se escriba sea esto cuando toque
       	--Una vez en el modo ESCRITURA, se escribe en el sitio x lo que corresponda y se incrementan puntero y contador (esto se hace en el programa fifo, aqui no)
       	wait for ciclo;
       	--Salgo del modo ESCRITURA y me voy a REPOSO
       	WRITE_FIFO <= '0';
       	wait for ciclo*2;
       	
       	--SI READ_FIFO == 1 pasare al estado LECTURA
       	READ_FIFO <= '1';
       	--Una vez en el estado LECTURA se incrementara el puntero de lectura y el contador solos y se leera lo que haya ("101")   
        wait for ciclo; 
        --Ahora vuelvo al estado de reposo
        READ_FIFO <= '0' ;
        wait for ciclo*5/3;
		--se acaba la simulación
		fin_test <= '1';
		wait;
    end process sim_process;
end tb_fifo_arch;
  	
  	
  	
  	
  	
  	
  	
  	
  	
  	
  	




