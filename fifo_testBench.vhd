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

    signal reset: std_logic := '0';
    signal clk: std_logic := '0';
    signal write_fifo: std_logic := '0';
    signal read_fifo: std_logic := '0';
    signal fifo_word_wr: std_logic_vector(2 downto 0);
    
    signal fifo_full: std_logic := '0';
    signal fifo_empty: std_logic := '0';
    signal fifo_word_rd: std_logic_vector(2 downto 0);
    
    
    
	
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
    	Process
  	begin
   	 clk <= '0';
    	wait for 100 ns;
   	 clk <= '1';
    	wait for 100 ns;
  	end process;
  	
  	Process
  	begin
   	 reset <= '1';--Asi el estado actual será REPOSO y WRITE_POINTER <= 0; READ_POINTER <= 0;FIFO_EMPTY <= '1';FIFO_FULL <= '0';FIFO_WORD_RD <= (others => '0');
       			--Ademas se reinician punteros y contadores
    	wait for 100 ns;
   	 reset <= '0';
    	wait for 100 ns;
  	end process;
  	

  	sim_process: process
    	begin   
-------------------------------------------------------------------------------------------------------------------------
---------------------------------CASO 1: HAGO QUE ESCRIBA SUCESIVAMENTE 5,4,1 Y QUE LEA DOS VECES------------------------
------------------------------------------------------------------------------------------------------------------------- 

	
--------------------------------------------------------------------------
-----------------------------ESCRIBO EL 5---------------------------------
--------------------------------------------------------------------------
       	--Si WRITE_FIFO == 1 pasaremos al modo ESCRITURA
       	write_fifo <= '1';
       	fifo_word_wr <= "101"; --Pongo que lo que se escriba sea esto cuando toque
       	--Una vez en el modo ESCRITURA, se escribe en el sitio x lo que corresponda y se incrementan puntero y contador (esto se hace en el programa fifo, aqui no)
       	wait for 100 ns;
       	--Salgo del modo ESCRITURA y me voy a REPOSO
       	write_fifo <= '0';
       	wait for 300 ns;
       	
--------------------------------------------------------------------------
-----------------------------ESCRIBO EL 1---------------------------------
--------------------------------------------------------------------------
       	
       	write_fifo <= '1';
       	fifo_word_wr <= "001"; --Pongo que lo que se escriba sea esto cuando toque
       	--Una vez en el modo ESCRITURA, se escribe en el sitio x lo que corresponda y se incrementan puntero y contador (esto se hace en el programa fifo, aqui no)
       	wait for 100 ns;
       	--Salgo del modo ESCRITURA y me voy a REPOSO
       	write_fifo <= '0';
       	wait for 300 ns;
       	
       	
       	
       	
-----------------------------------------------------------------------------------
---------------------AHORA LEERE EL VALOR DE LA POSIC X A LA QUE APUNTE EL PUNTERO
-----------------------------------------------------------------------------------
       	
       	--SI READ_FIFO == 1 pasare al estado LECTURA
       	read_fifo <= '1';
       	--Una vez en el estado LECTURA se incrementara el puntero de lectura y el contador solos y se leera lo que haya ("101")   
        wait for 100 ns; 
        --Ahora vuelvo al estado de reposo
        read_fifo <= '0' ;
        wait for 300 ns;
        
        
--------------------------------------------------------------------------
-----------------------------ESCRIBO EL 4---------------------------------
--------------------------------------------------------------------------
        
        write_fifo <= '1';
       	fifo_word_wr <= "100"; --Pongo que lo que se escriba sea esto cuando toque
       	--Una vez en el modo ESCRITURA, se escribe en el sitio x lo que corresponda y se incrementan puntero y contador (esto se hace en el programa fifo, aqui no)
       	wait for 100 ns;
       	--Salgo del modo ESCRITURA y me voy a REPOSO
       	write_fifo <= '0';
       	wait for 300 ns;
       	
       	
-----------------------------------------------------------------------------------
---------------------AHORA LEERE EL VALOR DE LA POSIC X A LA QUE APUNTE EL PUNTERO
-----------------------------------------------------------------------------------       	
       	
       	read_fifo <= '1';
       	--Una vez en el estado LECTURA se incrementara el puntero de lectura y el contador solos y se leera lo que haya ("101")   
        wait for 100 ns; 
        --Ahora vuelvo al estado de reposo
        read_fifo <= '0' ;
        wait for 300 ns;
        
        --Despues de los 50 ns se supone que volveriamos a empezar, es decir, se activaria RESET y blabla
        --assert false report "Fin de la simulación" severity failure;
    end process;
end tb_fifo_arch;
  	
  	
  	
  	
  	
  	
  	
  	
  	
  	
  	







