library ieee;
use ieee.std_logic_1164.all;

entity tau is
    port(data_in:  in std_logic_vector(63 downto 0);
         data_out: out std_logic_vector(63 downto 0)
    );
end tau;

architecture structural of tau is
    begin
        COLUMNS: for i in 0 to 3 generate
            ROWS: for j in 0 to 3 generate
                data_out(63 - 4*i - 16*j downto 63 - 4*i - 16*j - 3)
                    <= data_in(63 - 4*j - 16*i downto 63 - 4*j - 16*i - 3);
            end generate;
        end generate;
    end architecture;
