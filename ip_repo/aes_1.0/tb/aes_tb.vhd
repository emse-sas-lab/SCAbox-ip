-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file aes_tb.vhd
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;
use lib_thirdparty.test_pack.all;

library lib_rtl;
use lib_rtl.all;

entity aes_tb is
end entity aes_tb;

architecture aes_tb_arch of aes_tb is

	component aes
		port (
			data_i  : in bit128;
			key_i   : in bit128;
			clock_i : in std_logic;
			reset_i : in std_logic;
			start_i : in std_logic;
			inv_i   : in std_logic;
			data_o  : out bit128;
			done_o  : out std_logic
		);
	end component;

	signal count_test_s : integer := 1;
	signal clock_s : std_logic := '1';
	signal reset_s : std_logic;
	signal start_s : std_logic;
	signal done_s : std_logic;
	signal inv_s : std_logic := '0';

	signal key_s : bit128;
	signal data_is, data_os, data_es : bit128;

	signal cond_s : boolean;

begin

	clock_s <= not clock_s after 50 ns;

	DUT : aes
	port map(
		clock_i => clock_s,
		reset_i => reset_s,
		start_i => start_s,
		key_i   => key_s,
		inv_i   => inv_s,
		data_i  => data_is,
		data_o  => data_os,
		done_o  => done_s
	);

	PUT : process
	begin
		key_s <= std_input_key_c;

		if inv_s = '0' then
			data_is <= std_input_c;
		else
			data_is <= std_output_c;
		end if;

		if count_test_s rem 4 < 2 then
			reset_s <= '1';
			data_es <= (others => '0');
		else
			reset_s <= '0';
		end if;

		start_s <= '0';
		wait for 100 ns;
		reset_s <= '0';
		wait for 200 ns;
		start_s <= '1';
		wait for 100 ns;
		data_es <= (others => '0');
		wait for 100 ns;

		if count_test_s rem 4 = 1 then
			wait for 1300 ns;
		elsif count_test_s rem 4 = 2 then
			wait for 2500 ns;
		else
			wait for 1100 ns;
		end if;

		if inv_s = '0' then
			data_es <= std_output_c;
		else
			data_es <= std_input_c;
		end if;

		inv_s <= not inv_s;

		wait for 200 ns;
		start_s <= '0';
		count_test_s <= count_test_s + 1;

	end process PUT;

	cond_s <= data_os = data_es;
	assert cond_s report "output differs from expected output" severity error;

end architecture aes_tb_arch;

configuration aes_tb_conf of aes_tb is
	for aes_tb_arch
		for DUT : aes
			use configuration lib_rtl.aes_conf;
		end for;
	end for;
end configuration aes_tb_conf;