library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;
library rtl;
use rtl.tdc_pack.all;

entity tdc_exp_sum is
    generic (
        depth_g : positive := 4;
        in_width_g : positive := 8;
        out_width_g : positive := 8
    );
    port (
        clock_i  : in std_logic;
        state_i  : in std_logic_vector(in_width_g - 1 downto 0);
        weight_o : out std_logic_vector(out_width_g - 1 downto 0)
    );
end tdc_exp_sum;

architecture tdc_exp_sum_arch of tdc_exp_sum is
    constant state_width_c : positive := in_width_g;
    constant weight_width_c : positive := out_width_g;
    constant sum_depth_c : positive := integer(ceil(log2(real(in_width_g))));

    type state_array_t is array(0 to state_width_c - 1) of unsigned(weight_width_c - 1 downto 0);
    type sums_matrix_t is array (0 to sum_depth_c - 1) of state_array_t;

    signal curr_sums_s, next_sums_s : sums_matrix_t;
begin

    sums_reg : process (clock_i)
    begin
        if rising_edge(clock_i) then
            curr_sums_s <= next_sums_s;
        else
            curr_sums_s <= curr_sums_s;
        end if;
    end process; -- sums_reg

    input : for j in 0 to state_width_c - 1 generate
        next_sums_s(0)(j)(0) <= state_i(j);
        next_sums_s(0)(j)(weight_width_c - 1 downto 1) <= (others => '0');
    end generate; -- input

    sums : for i in 1 to sum_depth_c - 1 generate
        cols : for j in 0 to state_width_c / (2 ** i) - 1 generate
            next_sums_s(i)(j) <= curr_sums_s(i - 1)(2 * j) + curr_sums_s(i - 1)(2 * j + 1);
        end generate; -- cols
    end generate; -- sums

    weight_o <= std_logic_vector(curr_sums_s(sum_depth_c - 1)(0) + curr_sums_s(sum_depth_c - 1)(1));

end tdc_exp_sum_arch; -- tdc_exp_sum_arch