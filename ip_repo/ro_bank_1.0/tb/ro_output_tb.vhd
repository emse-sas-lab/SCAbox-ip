library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library rtl;
use rtl.all;
use rtl.ro_pack.all;

entity ro_output_tb is
    constant count_c : positive := 16;
    constant depth_c : positive := 8;
    constant width_c : positive := 32;

    constant sel_width_c : positive := sel_width(count_c);
    constant state_width_c : positive := state_width(depth_c);
end ro_output_tb;

architecture ro_output_tb_arch of ro_output_tb is

    signal clock_s : std_logic := '1';
    signal step_s : std_logic_vector(width_c - 1 downto 0);
    signal steps_s : std_logic_vector(count_c * state_width_c - 1 downto 0);
    signal state_is : std_logic_vector(count_c * state_width_c - 1 downto 0) := (others => '0');
    signal state_os : std_logic_vector(state_width_c - 1 downto 0) := (others => '0');
    signal sel_s : std_logic_vector(sel_width_c - 1 downto 0) := (others => '0');

begin
    clock_s <= not clock_s after 10 ns;
    sel_s <= std_logic_vector(unsigned(sel_s) + 1) after 40 ns;
    state_is <= std_logic_vector(unsigned(state_is) - 1) after 20 ns;

    DUT : entity rtl.ro_output(ro_output_arch)
        generic map(
            count_g => count_c,
            depth_g => depth_c,
            width_g => width_c
        )
        port map(
            clock_i => clock_s,
            state_i => state_is,
            sel_i   => sel_s,
            step_o  => step_s,
            steps_o => steps_s,
            state_o => state_os
        );

end ro_output_tb_arch; -- ro_output_tb_arch