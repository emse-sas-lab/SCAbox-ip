-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file mix_prod.vhd
--! @brief Mix column Gallois field product for an AES state column
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;

entity mix_prod is
	port (
		data_i : in col_state_t;
		inv_i  : in std_logic;
		data_o : out col_state_t
	);
end mix_prod;

architecture mix_prod_arch of mix_prod is
	signal data2_s : col_state_t;
	signal data4_s : col_state_t;
	signal data8_s : col_state_t;
	signal data3_s : col_state_t;
	signal data9_s : col_state_t;
	signal datab_s : col_state_t;
	signal datad_s : col_state_t;
	signal datae_s : col_state_t;

	signal data_s, data_inv_s : col_state_t;

begin
	data_o <= data_s when inv_i = '0' else
		data_inv_s;

	even_prod : for j in 0 to 3 generate
		data2_s(j) <= (data_i(j)(6 downto 0) & '0') xor "00011011" when data_i(j)(7) = '1' else
		data_i(j)(6 downto 0) & '0';
		data4_s(j) <= (data2_s(j)(6 downto 0) & '0') xor "00011011" when data2_s(j)(7) = '1' else
		data2_s(j)(6 downto 0) & '0';
		data8_s(j) <= (data4_s(j)(6 downto 0) & '0') xor "00011011" when data4_s(j)(7) = '1' else
		data4_s(j)(6 downto 0) & '0';
	end generate;

	odd_prod : for j in 0 to 3 generate
		data3_s(j) <= data2_s(j) xor data_i(j);
		data9_s(j) <= data8_s(j) xor data_i(j);
		datab_s(j) <= (data8_s(j) xor data2_s(j)) xor data_i(j);
		datad_s(j) <= (data8_s(j) xor data4_s(j)) xor data_i(j);
		datae_s(j) <= (data8_s(j) xor data4_s(j)) xor data2_s(j);
	end generate;

	data_s(0) <= data2_s(0) xor data3_s(1) xor data_i(2) xor data_i(3);
	data_s(1) <= data_i(0) xor data2_s(1) xor data3_s(2) xor data_i(3);
	data_s(2) <= data_i(0) xor data_i(1) xor data2_s(2) xor data3_s(3);
	data_s(3) <= data3_s(0) xor data_i(1) xor data_i(2) xor data2_s(3);

	data_inv_s(0) <= datae_s(0) xor datab_s(1) xor datad_s(2) xor data9_s(3);
	data_inv_s(1) <= data9_s(0) xor datae_s(1) xor datab_s(2) xor datad_s(3);
	data_inv_s(2) <= datad_s(0) xor data9_s(1) xor datae_s(2) xor datab_s(3);
	data_inv_s(3) <= datab_s(0) xor datad_s(1) xor data9_s(2) xor datae_s(3);

end architecture mix_prod_arch;