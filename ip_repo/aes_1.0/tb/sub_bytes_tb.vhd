-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file sub_bytes_tb.vhd
-------------------------------------------------------

library ieee;
library lib_round;
library lib_thirdparty;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use lib_thirdparty.crypt_pack.all;
use lib_round.all;

entity sub_bytes_tb is
end entity;

architecture sub_bytes_tb_arch of sub_bytes_tb is

	component sub_bytes
		port (
			data_i : in state_t;
			en_i   : in std_logic;
			inv_i  : in std_logic;
			data_o : out state_t
		);
	end component;

	signal data_is, data_os : state_t;

begin
	DUT : sub_bytes
	port map(
		data_i => data_is,
		en_i   => '1',
		inv_i  => '0',
		data_o => data_os
	);

	PUT : process
		variable count : std_logic_vector(7 downto 0) := "00000000";
	begin
		wait for 100 ns;
		if count = "11111111" then
			count := "00000000";
		else
			count := std_logic_vector(count + 1);
		end if;
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				data_is(i)(j) <= std_logic_vector(count);
			end loop;
		end loop;
	end process PUT;

end architecture sub_bytes_tb_arch;

configuration sub_bytes_tb_conf of sub_bytes_tb is
	for sub_bytes_tb_arch
		for DUT : sub_bytes
			use entity lib_round.sub_bytes(sub_bytes_arch);
		end for;
	end for;
end configuration;