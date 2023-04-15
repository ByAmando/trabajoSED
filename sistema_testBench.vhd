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
        BUTTON_1 : in std_logic;
        BUTTON_2 : in std_logic;
        BUTON_RESET : in std_logic;
        -- SALIDAS
        MOTOR_OUT: out std_logic_vector(3 downto 0)
    );
    end component;

    signal button_reset: std_logic := '0';
    signal clk: std_logic := '0';
    signal button_1: std_logic := '0';
    signal button_2: std_logic := '0';


    signal motor_out: std_logic_vector(3 downto 0);
    
    
    
	
    begin
    uut: fifo port map (
        BUTON_RESET => button_reset,
        CLK => clk,
        BUTTON_1 => button_1,
        BUTTON_2 => button_2,
        MOTOR_OUT => motor_out  
        
    );

    -- Generación de un reloj para la simulación
    	Process
  	begin
   	 CLK <= '0';
    	wait for 100 ns;
   	 CLK <= '1';
    	wait for 100 ns;
  	end process;
    -- Generación de un reset para la simulación 
  	Process
  	begin
   	 RESET <= '1';
    	wait for 100 ns;
   	 RESET <= '0';
    	wait for 100 ns;
  	end process;
  	
  	
  	sim_process: process
    	begin    	
       	--Seleccionamos el button 1
       	BUTTON_1 <= '1';
       	BUTTON_2 <= '0';
       	wait for 300 ns;
       	
       	--Seleccionamos el button 2
       	BUTTON_2 <= '1';
       	BUTTON_1 <= '0';
       	wait for 300 ns;

    end process;
end tb_fifo_arch;
  	
  	
  	
  	
  	
  	
  	
  	
  	
  	
  	





