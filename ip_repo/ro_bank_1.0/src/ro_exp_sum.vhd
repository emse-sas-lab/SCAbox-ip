library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

library rtl;
use rtl.ro_pack.all;

entity ro_exp_sum is
    generic (
        count_g : positive := 16;
        depth_g : positive := 8;
        width_g : positive := 32
    );
    port (
        clock_i : in std_logic;
        steps_i : in std_logic_vector(count_g * state_width(depth_g) - 1 downto 0);
        step_o  : out std_logic_vector(width_g - 1 downto 0)
    );
end ro_exp_sum;

architecture ro_exp_sum_arch of ro_exp_sum is
    constant state_width_c : positive := state_width(depth_g);
    constant sum_depth_c : positive := integer(ceil(log2(real(count_g))));

    type sum_array_t is array(0 to count_g - 1) of unsigned(width_g - 1 downto 0);
    type sums_matrix_t is array (0 to sum_depth_c - 1) of sum_array_t;

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

    input : for j in 0 to count_g - 1 generate
        next_sums_s(0)(j)(state_width_c - 1 downto 0) <= unsigned(steps_i(state_width_c * (j + 1) - 1 downto state_width_c * j));
        next_sums_s(0)(j)(width_g - 1 downto state_width_c) <= (others => '0');
    end generate; -- input

    sums : for i in 1 to sum_depth_c - 1 generate
        cols : for j in 0 to count_g / (2 ** i) - 1 generate
            next_sums_s(i)(j) <= curr_sums_s(i - 1)(2 * j) + curr_sums_s(i - 1)(2 * j + 1);
        end generate; -- cols
    end generate; -- sums

    step_o <= std_logic_vector(curr_sums_s(sum_depth_c - 1)(0) + curr_sums_s(sum_depth_c - 1)(1));

end ro_exp_sum_arch; -- ro_exp_sum_arch