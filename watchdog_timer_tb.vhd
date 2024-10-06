 library ieee;
use ieee.std_logic_1164.all;

entity watchdog_timer_tb is
end entity watchdog_timer_tb;

architecture tb of watchdog_timer_tb is
    signal clk     : std_logic;
    signal i_reset   : std_logic;
    signal i_pause   : std_logic;
    signal i_ticks   : std_logic_vector(7 downto 0);
    signal i_update  : std_logic;
    signal o_time_up : std_logic;

    component watchdog_timer
        port (
            i_clk     : in std_logic;
            i_reset   : in std_logic;
            i_pause   : in std_logic;
            i_ticks   : in std_logic_vector(7 downto 0);
            i_update  : in std_logic;
            o_time_up : out std_logic
        );
    end component;

    component watchdog_timer_tester
        port (
            i_clk     : out std_logic;
            i_reset   : out std_logic;
            i_pause   : out std_logic;
            i_ticks   : out std_logic_vector(7 downto 0);
            i_update  : out std_logic;
            o_time_up : in std_logic
        );
    end component;

begin
    t1: watchdog_timer
        port map (
            i_clk     => clk,
            i_reset   => i_reset,
            i_pause   => i_pause,
            i_ticks   => i_ticks,
            i_update  => i_update,
            o_time_up => o_time_up
        );

    t2: watchdog_timer_tester
        port map (
            i_clk     => clk,
            i_reset   => i_reset,
            i_pause   => i_pause,
            i_ticks   => i_ticks,
            i_update  => i_update,
            o_time_up => o_time_up
        );

end architecture tb;
