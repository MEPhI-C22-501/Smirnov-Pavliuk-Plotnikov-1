library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity watchdog_timer is
    port (
        i_clk     : in std_logic;                 
        i_reset   : in std_logic;                 
        i_pause   : in std_logic;                 
        i_ticks   : in std_logic_vector(7 downto 0);  
        i_update  : in std_logic;                 
        o_time_up : out std_logic                 
    );
end entity watchdog_timer;

architecture behavioral of watchdog_timer is
    type state_type is (idle, pause, count);
    signal current_state, next_state : state_type := idle;
    signal tick_counter : unsigned(7 downto 0) := (others => '0');
    signal tick_limit   : unsigned(7 downto 0) := (others => '0');
begin

    process (i_clk)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                current_state <= idle;
                tick_counter  <= tick_limit;
                o_time_up     <= '0';
            else
                current_state <= next_state; 
                
                case current_state is
                    when idle =>
                        if i_update = '1' then
                            tick_limit   <= unsigned(i_ticks);
                            tick_counter  <= unsigned(i_ticks);
                            o_time_up    <= '0';
                        end if;
                    when count =>
                        if i_pause = '1' then

                            null;
                        else
                            if tick_counter > 0 then
                                tick_counter <= tick_counter - 1;
                                o_time_up    <= '0';
                            else
                                o_time_up    <= '1';
                            end if;
                        end if;

                    when pause =>
                        null;
                end case;

            end if;
        end if;
    end process;

    process (current_state, i_pause, i_reset, tick_counter)
    begin
        next_state <= current_state;  

        case current_state is
            when idle =>
                if i_reset = '0' then
                    next_state <= count;
                end if;
                
            when count =>
                if i_pause = '1' then
                    next_state <= pause;
                elsif tick_counter = 0 then
                   next_state <= idle;
                else
                    next_state <= count;
                end if;
                
            when pause =>
                if i_pause = '0' then
                    next_state <= count;
                else
                    next_state <= pause;
                end if;

            when others =>
                next_state <= idle;
        end case;
    end process;

end architecture behavioral;
