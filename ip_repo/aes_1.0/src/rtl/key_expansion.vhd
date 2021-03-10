-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file key_expansion.vhd
--! @brief Top level for key expansion
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;
use lib_thirdparty.all;

library lib_round;
use lib_round.mix_columns;

library lib_rtl;
use lib_rtl.key_expander;
use lib_rtl.key_expansion_fsm;

entity key_expansion is
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
end entity key_expansion;

architecture key_expansion_arch of key_expansion is

	component key_expansion_fsm
		port (
			clock_i        : in std_logic;
			resetb_i       : in std_logic;
			start_i        : in std_logic;
			invb_i         : in std_logic;
			key_changedb_i : std_logic;
			count_i        : in bit4;
			end_o          : out std_logic;
			we_key_o       : out std_logic
		);
	end component;
	component key_expander
		port (
			key_i  : in bit128;
			rcon_i : in bit8;
			inv_i  : in std_logic;
			key_o  : out bit128
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
	component mix_columns
		port (
			data_i : in state_t;
			en_i   : in std_logic;
			inv_i  : in std_logic;
			data_o : out state_t
		);
	end component;

	signal en_mix_s : std_logic;
	signal we_key_s : std_logic;
	signal key_changedb_s : std_logic;
	signal invb_s : std_logic;

	signal rcon_s : bit8;
	signal key_s, round_key_s : bit128;
	signal reg_key_s : keyexp_t;
	signal key_mix_s : state_t;
	signal we_reg_s : bit11;

begin
	invb_s <= not inv_i;
	key_changedb_s <= '1' when key_i = reg_key_s(0) else '0';
	en_mix_s <= '0' when count_i = x"a" or count_i = x"0" else inv_i;

	rcon_s <= rcon_c(to_integer(unsigned(count_i)));
	key_s <= reg_key_s(to_integer(unsigned(count_i)));
	key_o <= state_to_bit128(key_mix_s);

	fsm : key_expansion_fsm port map(
		clock_i        => clock_i,
		resetb_i       => resetb_i,
		start_i        => start_i,
		invb_i         => invb_s,
		key_changedb_i => key_changedb_s,
		count_i        => count_i,
		end_o          => end_o,
		we_key_o       => we_key_s
	);

	expander : key_expander
	port map(
		key_i  => key_s,
		rcon_i => rcon_s,
		inv_i  => inv_i,
		key_o  => round_key_s
	);

	mix : mix_columns
	port map(
		data_i => bit128_to_state(key_s),
		inv_i  => '1',
		en_i   => en_mix_s,
		data_o => key_mix_s
	);

	key_register : for k in 0 to 10 generate
		key_register0 : if k = 0 generate
			we_reg_s(0) <= '1' and we_key_s when count_i = x"0" else
			'0';
			reg0 : state_reg
			port map(
				data_i   => key_i,
				clock_i  => clock_i,
				resetb_i => resetb_i,
				we_i     => we_reg_s(0),
				data_o   => reg_key_s(0)
			);
		end generate;

		key_registern : if k > 0 generate
			we_reg_s(k) <= '1' and we_key_s when count_i = std_logic_vector(to_unsigned(k - 1, 4)) else
			'0';
			reg : state_reg
			port map(
				data_i   => round_key_s,
				clock_i  => clock_i,
				resetb_i => resetb_i,
				we_i     => we_reg_s(k),
				data_o   => reg_key_s(k)
			);
		end generate;
	end generate; -- key_register
end architecture key_expansion_arch;

configuration key_expansion_conf of key_expansion is
	for key_expansion_arch
		for fsm : key_expansion_fsm
			use entity lib_rtl.key_expansion_fsm(key_expansion_fsm_arch);
		end for;
		for expander : key_expander
			use entity lib_rtl.key_expander(key_expander_arch);
		end for;
		for mix : mix_columns
			use entity lib_round.mix_columns(mix_columns_arch);
		end for;

		for key_register
			for key_register0
				for all : state_reg
					use entity lib_thirdparty.state_reg(state_reg_arch);
				end for;
			end for;

			for key_registern
				for all : state_reg
					use entity lib_thirdparty.state_reg(state_reg_arch);
				end for;
			end for;
		end for;
	end for;
end configuration;