-- (63..60)(59..56)(55..52)(51..48)
-- (47..44)(43..40)(39..36)(35..32)
-- (31..28)(27..24)(23..20)(19..16)
-- (15..12)(11..08)(07..04)(03..00)
--
-- start = 63 - 4*i - 16*j
-- end = start - 3

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pi is
    port(data_in:  in std_logic_vector(63 downto 0);
         data_out: out std_logic_vector(63 downto 0)
    );
end pi;

architecture structural of pi is
    type masking_nibbles is array(0 to 3) of std_logic_vector(3 downto 0);
    constant masks: masking_nibbles := ("1110", "1101", "1011", "0111");

    begin
        COLUMNS: for i in 0 to 3 generate
            ROWS: for j in 0 to 3 generate
                data_out(63 - 4*i - 16*j downto 63 - 4*i - 16*j - 3)
                    <=  (masks((i+j+0) mod 4) and
                         data_in(63 - 4*i - 16*0 downto 63 - 4*i - 16*0 - 3))
                    xor (masks((i+j+1) mod 4) and
                         data_in(63 - 4*i - 16*1 downto 63 - 4*i - 16*1 - 3))
                    xor (masks((i+j+2) mod 4) and
                         data_in(63 - 4*i - 16*2 downto 63 - 4*i - 16*2 - 3))
                    xor (masks((i+j+3) mod 4) and
                         data_in(63 - 4*i - 16*3 downto 63 - 4*i - 16*3 - 3));
            end generate;
        end generate;
    end architecture;
