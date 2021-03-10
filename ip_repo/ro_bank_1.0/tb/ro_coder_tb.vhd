library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library rtl;
use rtl.all;
use rtl.ro_pack.all;

entity ro_coder_tb is
end ro_coder_tb;

architecture ro_coder_tb_arch of ro_coder_tb is

    constant depth_c : positive := 8;

    signal clock_s : std_logic := '0';
    signal state_is : std_logic_vector(depth_c - 1 downto 0);
    signal state_os : std_logic_vector(state_width(depth_c) - 1 downto 0);
    signal count_s : positive := 0;
begin

    clock_s <= not clock_s after 10 ns;

    DUT : entity rtl.ro_coder(ro_coder_arch)
        generic map(
            depth_c => depth_c
        )
        port map(
            state_i => state_is,
            state_o => state_os
        );

    PUT : process (count_s)
    begin
        if count_s < depth_c then
            state_is(count_s - 1 downto 0) <= (others => '1');
            state_is(depth_c - 1 downto count_s) <= (others => '0');
        else
            state_is(count_s - depth_c - 1 downto 0) <= (others => '0');
            state_is(depth_c - 1 downto count_s - depth_c) <= (others => '1');
        end if;
    end process; -- PUT

    counter : process (clock_s)
    begin
        if rising_edge(clock_s) then
            if count_s < 2 * depth_c then
                count_s <= count_s + 1;
            else
                count_s <= 0;
            end if;
        end if;
    end process; -- counter
end ro_coder_tb_arch; -- ro_coder_tb_arch