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
        
        
------------------------------------------------------------------------------------------------------------------       
----------------------------------------CASO 1: BOTON 1 ACTIVO----------------------------------------------------
------------------------------------------------------------------------------------------------------------------ 

--      SI FIFO_Button_! OR button_" == 1 AND FIFO_FULL == 0, el estado actual pasara a ser ESCRITURA
        fifo_full <= '0'; --Indicamos quela fifo esta vacia y se puede escribir
        button_1 <='1';   --Escribimos con el boton 1
        wait for 100 ns;
        button_1 <= '0';  --Con esta condicion o con la de abajo comentada, pasariamos a reposo de nuevo
        --fifo_full <= '1';
        wait for 100 ns;


------------------------------------------------------------------------------------------------------------------       
----------------------------------------CASO 2: BOTON 2 ACTIVO----------------------------------------------------
------------------------------------------------------------------------------------------------------------------  
--        fifo_full <= '0'; --Indicamos quela fifo esta vacia y se puede escribir
--        button_2 <='1';   --Escribimos con el boton 2
--        wait for 100 ns;
--        button_2 <= '0';  --Con esta condicion o con la de abajo comentada, pasariamos a reposo de nuevo
--        --fifo_full <= '1';
--        wait for 100 ns;
 
--------------------------------------------------------------------------------------------------------------------------        
----------------------------------------CASO 3: LOS DOS BOTONES ACTIVOS A LA VEZ------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--AUNQUE SE SUPONE QUE ESTE CASO NO DEBE DARSE EN LA REALIDAD, NOSOTROS LO HEMOS MODELADO PARA QUE PERMANEZCA EN REPOSO---
 
--        fifo_full <= '0';
--        button_1 <= '1'; --ACTIVO BOTON 1
--        button_2 <= '1'; --ACTIVO BOTON 2
--        wait for 100 ns;
        
------------------------------------------------------------------------------------------------------------------         
----------------------------------------CASO 4: LA COLA ESTÁ LLENA------------------------------------------------
------------------------------------------------------------------------------------------------------------------  
--        button_1 <= '0';
--        button_2 <= '1'; --Activo este por ej
--        fifo_full <= '1'; --Marco que fifo esta lleno asi que da igual el boton que pulse, me mantendré en reposo
--        wait for 100 ns;

        
    end process;
end tb_escritura_arch;











