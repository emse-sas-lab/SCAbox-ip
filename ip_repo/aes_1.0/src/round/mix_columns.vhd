-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file mix_columns.vhd
--! @brief LUT-style mix columns operation
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.mix_prod;
use lib_thirdparty.crypt_pack.all;

entity mix_columns is
	port (
		data_i : in state_t;
		en_i   : in std_logic;
		inv_i  : in std_logic;
		data_o : out state_t
	);
end entity mix_columns;

architecture mix_columns_arch of mix_columns is

	signal data_is, data_os : word_t;

begin
	data_is <= state_to_word(data_i);
	data_o  <= word_to_state(data_os) when en_i = '1' else data_i;

	col_prod : for j in 0 to 3 generate
		prod : entity lib_thirdparty.mix_prod
			port map(
				data_i => data_is(j),
				inv_i  => inv_i,
				data_o => data_os(j)
			);
	end generate; -- col_prod

end architecture mix_columns_arch;