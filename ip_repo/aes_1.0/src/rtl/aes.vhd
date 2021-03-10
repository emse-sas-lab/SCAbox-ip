---------------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file aes.vhd
--! @brief top level wrapper
---------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;

library lib_rtl;
use lib_rtl.all;

--! RTL Top level of AES ecryption core.

--! This top level is intented to provide an interface to perform
--! AES128 encryptions using the accelerator.
entity aes is
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
end entity aes;

architecture aes_arch of aes is

	component key_expansion
		port (
			key_i    : in bit128;
			clock_i  : in std_logic;
			resetb_i : in std_logic;
			start_i  : in std_logic;
			count_i  : in bit4;
			inv_i    : in std_logic;
			end_o    : out std_logic;
			key_o    : out bit128
		);
	end component;
	component aes_fsm
		port (
			resetb_i        : in std_logic;
			clock_i         : in std_logic;
			start_i         : in std_logic;
			count_i         : in bit4;
			end_keyexp_i    : in std_logic;
			invb_i          : in std_logic;
			start_keyexp_o  : out std_logic;
			en_mixcolumns_o : out std_logic;
			en_round_o      : out std_logic;
			en_out_o        : out std_logic;
			en_count_o      : out std_logic;
			up_count_o      : out std_logic;
			we_data_o       : out std_logic;
			data_src_o      : out std_logic;
			done_o          : out std_logic
		);
	end component;
	component aes_round
		port (
			data_i          : in bit128;
			key_i           : in bit128;
			en_mixcolumns_i : in std_logic;
			en_round_i      : in std_logic;
			inv_i           : in std_logic;
			data_o          : out bit128
		);
	end component;
	component round_counter
		port (
			clock_i  : in std_logic;
			resetb_i : in std_logic;
			en_i     : in std_logic;
			up_i     : in std_logic;
			count_i  : in bit4;
			count_o  : out bit4
		);
	end component;
	component state_reg
		port (
			data_i   : in bit128;
			resetb_i : in std_logic;
			clock_i  : in std_logic;
			we_i     : in std_logic;
			data_o   : out bit128
		);
	end component;

	signal resetb_s : std_logic;
	signal invb_s : std_logic;
	signal done_s : std_logic;

	signal en_mixcolumns_s : std_logic;
	signal en_round_s : std_logic;
	signal en_count_s : std_logic;
	signal en_out_s : std_logic;
	signal we_data_s : std_logic;
	signal data_src_s : std_logic;
	signal up_count_s : std_logic;

	signal start_keyexp_s : std_logic;
	signal end_keyexp_s : std_logic;

	signal count_s, init_count_s : bit4;
	signal input_data_s, round_data_s, reg_data_s, out_data_s : bit128;
	signal key_s : bit128;

begin
	init_count_s <= x"0" when up_count_s = '1' else x"a";
	resetb_s <= not reset_i;
	invb_s <= not inv_i;

	input_data_s <= data_i when data_src_s = '1' else round_data_s;

	data_o <= reg_data_s when done_s = '1' else out_data_s;
	done_o <= done_s;

	out_reg : state_reg
	port map(
		data_i   => reg_data_s,
		resetb_i => resetb_s,
		clock_i  => clock_i,
		we_i     => done_s,
		data_o   => out_data_s
	);

	round_reg : state_reg
	port map(
		data_i   => input_data_s,
		resetb_i => resetb_s,
		clock_i  => clock_i,
		we_i     => we_data_s,
		data_o   => reg_data_s
	);

	keyexp : key_expansion
	port map(
		key_i    => key_i,
		clock_i  => clock_i,
		count_i  => count_s,
		resetb_i => resetb_s,
		start_i  => start_keyexp_s,
		inv_i    => inv_i,
		end_o    => end_keyexp_s,
		key_o    => key_s
	);

	fsm : aes_fsm
	port map(
		resetb_i        => resetb_s,
		clock_i         => clock_i,
		start_i         => start_i,
		count_i         => count_s,
		end_keyexp_i    => end_keyexp_s,
		invb_i          => invb_s,
		start_keyexp_o  => start_keyexp_s,
		en_mixcolumns_o => en_mixcolumns_s,
		en_round_o      => en_round_s,
		en_out_o        => en_out_s,
		en_count_o      => en_count_s,
		up_count_o      => up_count_s,
		we_data_o       => we_data_s,
		data_src_o      => data_src_s,
		done_o          => done_s
	);

	round : aes_round
	port map(
		data_i          => reg_data_s,
		key_i           => key_s,
		en_mixcolumns_i => en_mixcolumns_s,
		en_round_i      => en_round_s,
		inv_i           => inv_i,
		data_o          => round_data_s
	);

	count : round_counter
	port map(
		clock_i  => clock_i,
		resetb_i => resetb_s,
		en_i     => en_count_s,
		up_i     => up_count_s,
		count_i  => init_count_s,
		count_o  => count_s
	);

end architecture aes_arch;

configuration aes_conf of aes is
	for aes_arch
		for all : state_reg
			use entity lib_thirdparty.state_reg(state_reg_arch);
		end for;
		for keyexp : key_expansion
			use configuration lib_rtl.key_expansion_conf;
		end for;
		for fsm : aes_fsm
			use entity lib_rtl.aes_fsm(aes_fsm_arch);
		end for;
		for round : aes_round
			use configuration lib_rtl.aes_round_conf;
		end for;
		for count : round_counter
			use entity lib_thirdparty.round_counter(round_counter_arch);
		end for;
	end for;
end configuration;