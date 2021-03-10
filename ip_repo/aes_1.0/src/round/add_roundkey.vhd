-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file add_roundkey.vhd
--! @brief XOR between data block and round key
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;

entity add_roundkey is
    port (
        data_i : in state_t;
        key_i  : in state_t;
        en_i   : in std_logic;
        data_o : out state_t);
end entity add_roundkey;

architecture add_roundkey_arch of add_roundkey is

    signal data_s : state_t;

begin
    data_o <= data_s when en_i = '1' else data_i;

    row : for i in 0 to 3 generate
        col : for j in 0 to 3 generate
            data_s(i)(j) <= data_i(i)(j) xor key_i(i)(j);
        end generate;
    end generate;

end architecture add_roundkey_arch;