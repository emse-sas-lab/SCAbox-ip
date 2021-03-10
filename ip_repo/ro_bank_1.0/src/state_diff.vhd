library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library rtl;
use rtl.ro_pack.all;

entity state_diff is
    generic (
        depth_g : positive := 8
    );
    port (
        clock_i : in std_logic;
        last_i  : in std_logic_vector(state_width(depth_g) - 1 downto 0);
        curr_i  : in std_logic_vector(state_width(depth_g) - 1 downto 0);
        step_o  : out std_logic_vector(state_width(depth_g) - 1 downto 0)
    );
end state_diff;

architecture state_diff_arch of state_diff is
    constant state_width_c : positive := state_width(depth_g);
    constant offset_c : unsigned := to_unsigned(depth_g + depth_g, state_width_c);
begin
    step : process (last_i, curr_i)
    begin
        if unsigned(last_i) > unsigned(curr_i) then
            step_o <= std_logic_vector(offset_c + unsigned(curr_i) - unsigned(last_i));
        else
            step_o <= std_logic_vector(unsigned(curr_i) - unsigned(last_i));
        end if;
    end process; -- step

end state_diff_arch; -- state_diff_arch