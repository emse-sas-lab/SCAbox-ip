-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file shift_rows.vhd
--! @brief AES shift rows
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;

entity shift_rows is
	port (
		data_i : in state_t;
		en_i   : in std_logic;
		inv_i  : in std_logic;
		data_o : out state_t);
end entity shift_rows;

architecture shift_rows_arch of shift_rows is

	signal data_s, data_inv_s : state_t;

begin
	data_o <= data_s when inv_i = '0' and en_i = '1' else
		data_inv_s when inv_i = '1' and en_i = '1' else
		data_i;

	row : for i in 0 to 3 generate
		col : for j in 0 to 3 generate
			-- left shift i times
			data_s(i)(j) <= data_i(i)((j + i) mod 4);
			data_inv_s(i)((j + i) mod 4) <= data_i(i)(j);
		end generate;
	end generate;

end architecture shift_rows_arch;