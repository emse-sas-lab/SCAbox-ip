-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file sub_bytes.vhd
--! @brief LUT-style sub-bytes operation
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;

library lib_round;
use lib_round.all;

entity sub_bytes is
    port (
        data_i : in state_t;
        en_i   : in std_logic;
        inv_i  : in std_logic;
        data_o : out state_t);
end entity sub_bytes;

architecture sub_bytes_arch of sub_bytes is

    signal data_s, data_inv_s : state_t;

begin
    data_o <= data_s when inv_i = '0' and en_i = '1' else
        data_inv_s when inv_i = '1' and en_i = '1' else
        data_i;

    row : for i in 0 to 3 generate
        col : for j in 0 to 3 generate
            data_s(i)(j) <= sbox_c(to_integer(unsigned(data_i(i)(j))));
            data_inv_s(i)(j) <= inv_sbox_c(to_integer(unsigned(data_i(i)(j))));
        end generate col;
    end generate row;
end sub_bytes_arch;