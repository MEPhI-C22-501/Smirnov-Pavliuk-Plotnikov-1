library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity watchdog_timer_tester is
    port (
        i_clk     : out std_logic;
        i_reset   : out std_logic;
        i_pause   : out std_logic;
        i_ticks   : out std_logic_vector(7 downto 0);
        i_update  : out std_logic;
        o_time_up : in std_logic
    );
end entity watchdog_timer_tester;

architecture tester of watchdog_timer_tester is
    signal clk : std_logic := '0';
    constant clk_period : time := 10 ns;
begin
    clk_process : process 
    begin
        i_clk <= '0';
        wait for clk_period / 2;
        i_clk <= '1';
        wait for clk_period / 2;
    end process;
    test_process : process
    begin
        i_reset <= '1';
        i_pause <= '0';
        i_update <= '0';
        i_ticks <= (others => '0');
        wait for clk_period * 2;
        i_reset <= '0';

        i_ticks <= std_logic_vector(to_unsigned(10, 8));
        i_update <= '1';
        wait for clk_period;
        i_update <= '0';
        
        wait for clk_period * 8;
		  
        i_pause <= '1';
        wait for clk_period * 3;
        i_pause <= '0';

        wait for clk_period * 10;
        
        i_reset <= '1';
        wait for clk_period * 5;
        i_reset <= '0';

        wait for clk_period * 20;
        wait;
    end process;
end architecture tester;
