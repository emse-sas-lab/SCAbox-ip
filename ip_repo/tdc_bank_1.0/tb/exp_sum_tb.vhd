library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library rtl;
use rtl.tdc_pack.all;

entity exp_sum_tb is
end exp_sum_tb;

architecture exp_sum_tb_arch of exp_sum_tb is

    constant depth_c : positive := 2;

    signal clock_s : std_logic := '0';
    signal state_s : std_logic_vector(state_width(depth_c) - 1 downto 0) := (others => '0');
    signal weight_s : std_logic_vector(weight_width(depth_c) - 1 downto 0);
    component exp_sum is
        generic (
            depth_g : positive := 4
        );
        port (
            clock_i  : in std_logic;
            state_i  : in std_logic_vector(state_width(depth_g) - 1 downto 0);
            weight_o : out std_logic_vector(weight_width(depth_g) - 1 downto 0)
        );
    end component;
begin
    clock_s <= not clock_s after 2.5 ns;
    state_s <= std_logic_vector(unsigned(state_s) + 1) after 5 ns;

    DUT : exp_sum
    generic map(
        depth_g => depth_c
    )
    port map(
        clock_i  => clock_s,
        state_i  => state_s,
        weight_o => weight_s
    );

end exp_sum_tb_arch; -- exp_sum_tb_arch