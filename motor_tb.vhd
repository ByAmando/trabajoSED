library ieee;
use ieee.std_logic_1164.all;

entity motor_stepper_tb is
end entity;

architecture tb_arch of motor_stepper_tb is
    component motor_stepper is
        port (
            -- ENTRADAS --
            RESET : in std_logic;
            CLK_SLOW : in std_logic;
            START : in std_logic;
            SENTIDO: in std_logic;
            CICLOS: in std_logic_vector(1 downto 0);
            -- SALIDAS
            MOTOR_OUT: out std_logic_vector(3 downto 0);
            FINISHED: out std_logic
        );
    end component;

    signal reset: std_logic := '0';
    signal clk_slow: std_logic := '0';
    signal start: std_logic := '0';
    signal sentido: std_logic := '0';
    signal ciclos: std_logic_vector(1 downto 0) := "00";
    signal motor_out: std_logic_vector(3 downto 0) := "0000";
    signal finished: std_logic := '0';
	
    begin
    uut: motor_stepper port map (
        RESET => reset,
        CLK_SLOW => clk_slow,
        START => start,
        SENTIDO => sentido,
        CICLOS => ciclos,
        MOTOR_OUT => motor_out,
        FINISHED => finished
    );
    
    -- Clock SLOW generator
    process
    begin
        while true loop
            clk_slow <= not clk_slow after 10 ns;
            wait for 5 ns;
        end loop;
    end process;

--    -- Test case 1: RESET signal
--    process
--    begin
--        reset <= '1';
--        wait for 10 ns;
--        reset <= '0';
--        wait for 50 ns;
--        assert (motor_out = "0000") report "Test case 1 failed: MOTOR_OUT should be '0000'" severity error;
--        assert (finished = '0') report "Test case 1 failed: FINISHED should be '0'" severity error;
--        wait;
--    end process;
	-- Test case 2: Run motor for 1 cycle
    process
    begin
    
   	 wait for 20 ns;
        start <= '1';
        wait for 20 ns;
        
        sentido <= '1';
        ciclos <= "01";
        
  
        
        
        wait for 100 ns;
        assert (motor_out = "0001") report "Test case 2 failed: MOTOR_OUT should be '0001'" severity error;
        assert (finished = '1') report "Test case 2 failed: FINISHED should be '1'" severity error;
        wait;
    end process;

--    -- Test case 3: Run motor for 2 cycles
--    process
--    begin
--        start <= '1';
--        sentido <= '1';
--        ciclos <= "10";
--        wait for 220 ns;
--        assert (motor_out = "0100") report "Test case 3 failed: MOTOR_OUT should be '0100'" severity error;
--        assert (finished = '1') report "Test case 3 failed: FINISHED should be '1'" severity error;
--        wait;
--    end process;
--
--    -- Test case 4: Run motor for 3 cycles
--    process
--    begin
--        start <= '1';
--        sentido <= '0';
--        ciclos <= "11";
--        wait for 350 ns;
--        assert (motor_out = "1100") report "Test case 4 failed: MOTOR_OUT should be '1100'" severity error;
--    end process;
end architecture;
