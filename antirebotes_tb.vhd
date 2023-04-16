library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncing_tb is
end entity;

architecture tb_arch_debouncing of debouncing_tb is
	component debouncing is
		port (
			-- ENTRADAS --
			CLK : in std_logic;
			RESET : in std_logic;
			BUTTON_IN : in std_logic;
			-- SALIDAS --
			BUTTON_OUT : out std_logic
		);
    	end component;
    
    	-- ENTRADAS --
    	SIGNAL clk: std_logic := '0';
	SIGNAL reset: std_logic := '0';
   	SIGNAL button_in: std_logic := '0';
   	
   	-- SALIDAS --
    	SIGNAL button_out: std_logic := '0';
    	
        -- INTERNAS --
        SIGNAL fin_test:  std_logic := '0' ;        -- Indica fin de simulación. Se pone a '1' al final de la simulacion. 
                                                    -- Se utiliza para bloquear el reloj y apreciar mejor el final de la simulación.
    
        constant ciclo : time := 100 ns;

begin
	uut: debouncing port map (
        CLK => clk,
	RESET => reset,
        BUTTON_IN => button_in,
        BUTTON_OUT => button_out
    );
	
    -- ======================================================================
    -- Proceso del reloj. Se ejecuta hasta que FIN_test='1'
    -- ======================================================================
    GenCLK: process
    begin
        if (fin_test='1') THEN
            clk <= '0';         WAIT;     -- Bloquea el reloj
        ELSE
            clk <= '0';     wait for ciclo/2;
            clk <= '1';     wait for ciclo/2;
        END IF;
    end process GenCLK;

   -- Test case 1: RESET signal
   tb1: process
   begin
       reset <= '1';
       wait for ciclo*2;
       reset <= '0';
       assert (button_out = '0') report "Test case 1 failed: BUTTON_OUT should be '0'" severity error;
       wait;
   end process tb1;
	
   -- Test case 3: Run motor for 2 cycles
   tb2: process
   begin
       button_in <= '0';
       wait for ciclo*3;
       button_in <= '1';
       wait for ciclo*10;
       assert (button_out = '1') report "Test case 2.1 failed: BUTTON_OUT should be '1'" severity error;
       button_in <= '0';
       wait for ciclo*10;
       assert (button_out = '0') report "Test case 2.2 failed: BUTTON_OUT should be '0'" severity error;
       fin_test <= '1';
       wait;
   end process tb2;
	
end tb_arch_debouncing;
    




