library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library rtl;
use rtl.ro_pack.all;

entity ro_coder is
    generic (
        depth_g : positive := 8
    );
    port (
        state_i : in std_logic_vector(depth_g - 1 downto 0);
        state_o : out std_logic_vector(state_width(depth_g) - 1 downto 0)
    );
end ro_coder;
architecture ro_coder_arch of ro_coder is

    constant depth_c : unsigned(state_width(depth_g) - 1 downto 0) := to_unsigned(depth_g, state_width(depth_g));

begin
    encoder : process (state_i)
        variable state_v : unsigned(state_width(depth_g) - 1 downto 0);
    begin
        state_v := (others => '0');
        sum : for i in 0 to depth_g - 1 loop
            if state_i(i) = '1' then
                state_v := state_v + 1;
            end if;
        end loop; -- sum

        if state_i(0) = '0' and state_i(depth_g - 1) = '1' then
            state_v := depth_c + depth_c - state_v;
        end if;

        state_o <= std_logic_vector(state_v);
    end process; -- encoder

end ro_coder_arch; -- ro_coder_arch