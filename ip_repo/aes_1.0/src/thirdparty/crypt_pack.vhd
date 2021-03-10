-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file crypt_pack.vhd
--! @brief Utilities package for crypto-algorithms
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package crypt_pack is
	subtype bit4 is std_logic_vector(3 downto 0);
	subtype bit8 is std_logic_vector(7 downto 0);
	subtype bit11 is std_logic_vector(10 downto 0);
	subtype bit16 is std_logic_vector(15 downto 0);
	subtype bit32 is std_logic_vector(31 downto 0);
	subtype bit128 is std_logic_vector(127 downto 0);

	type sbox_t is array(0 to 255) of bit8;
	type row_state_t is array(0 to 3) of bit8;
	type col_state_t is array(0 to 3) of bit8;
	type row_key_t is array(0 to 3) of bit8;
	type state_t is array(0 to 3) of row_state_t;
	type word_t is array(0 to 3) of col_state_t;
	type keyexp_t is array(0 to 10) of bit128;
	type keyexp_state_t is array(0 to 10) of state_t;
	type rcon_t is array(0 to 10) of bit8;

	function state_to_bit128(data_i : state_t) return bit128;
	function state_to_word(data_i : state_t) return word_t;
	function word_to_bit128(data_i : word_t) return bit128;
	function word_to_state(data_i : word_t) return state_t;
	function bit128_to_state(data_i : bit128) return state_t;
	function bit128_to_word(data_i : bit128) return word_t;
	function "xor" (L, R : col_state_t) return col_state_t;

	constant rcon_c : rcon_t :=
	(
	x"01", x"02", x"04", x"08", x"10", x"20", x"40", x"80", x"1b", x"36", x"00"
	);

	-- sbox ordered by rows
	constant sbox_c : sbox_t :=
	(
	x"63", x"7c", x"77", x"7b", x"f2", x"6b", x"6f", x"c5",
	x"30", x"01", x"67", x"2b", x"fe", x"d7", x"ab", x"76",
	x"ca", x"82", x"c9", x"7d", x"fa", x"59", x"47", x"f0",
	x"ad", x"d4", x"a2", x"af", x"9c", x"a4", x"72", x"c0",
	x"b7", x"fd", x"93", x"26", x"36", x"3f", x"f7", x"cc",
	x"34", x"a5", x"e5", x"f1", x"71", x"d8", x"31", x"15",
	x"04", x"c7", x"23", x"c3", x"18", x"96", x"05", x"9a",
	x"07", x"12", x"80", x"e2", x"eb", x"27", x"b2", x"75",
	x"09", x"83", x"2c", x"1a", x"1b", x"6e", x"5a", x"a0",
	x"52", x"3b", x"d6", x"b3", x"29", x"e3", x"2f", x"84",
	x"53", x"d1", x"00", x"ed", x"20", x"fc", x"b1", x"5b",
	x"6a", x"cb", x"be", x"39", x"4a", x"4c", x"58", x"cf",
	x"d0", x"ef", x"aa", x"fb", x"43", x"4d", x"33", x"85",
	x"45", x"f9", x"02", x"7f", x"50", x"3c", x"9f", x"a8",
	x"51", x"a3", x"40", x"8f", x"92", x"9d", x"38", x"f5",
	x"bc", x"b6", x"da", x"21", x"10", x"ff", x"f3", x"d2",
	x"cd", x"0c", x"13", x"ec", x"5f", x"97", x"44", x"17",
	x"c4", x"a7", x"7e", x"3d", x"64", x"5d", x"19", x"73",
	x"60", x"81", x"4f", x"dc", x"22", x"2a", x"90", x"88",
	x"46", x"ee", x"b8", x"14", x"de", x"5e", x"0b", x"db",
	x"e0", x"32", x"3a", x"0a", x"49", x"06", x"24", x"5c",
	x"c2", x"d3", x"ac", x"62", x"91", x"95", x"e4", x"79",
	x"e7", x"c8", x"37", x"6d", x"8d", x"d5", x"4e", x"a9",
	x"6c", x"56", x"f4", x"ea", x"65", x"7a", x"ae", x"08",
	x"ba", x"78", x"25", x"2e", x"1c", x"a6", x"b4", x"c6",
	x"e8", x"dd", x"74", x"1f", x"4b", x"bd", x"8b", x"8a",
	x"70", x"3e", x"b5", x"66", x"48", x"03", x"f6", x"0e",
	x"61", x"35", x"57", x"b9", x"86", x"c1", x"1d", x"9e",
	x"e1", x"f8", x"98", x"11", x"69", x"d9", x"8e", x"94",
	x"9b", x"1e", x"87", x"e9", x"ce", x"55", x"28", x"df",
	x"8c", x"a1", x"89", x"0d", x"bf", x"e6", x"42", x"68",
	x"41", x"99", x"2d", x"0f", x"b0", x"54", x"bb", x"16"
	);

	-- inverse sbox ordered by rows
	constant inv_sbox_c : sbox_t :=
	(
	x"52", x"09", x"6A", x"D5", x"30", x"36", x"A5", x"38", x"BF", x"40", x"A3", x"9E", x"81", x"F3", x"D7", x"FB",
	x"7C", x"E3", x"39", x"82", x"9B", x"2F", x"FF", x"87", x"34", x"8E", x"43", x"44", x"C4", x"DE", x"E9", x"CB",
	x"54", x"7B", x"94", x"32", x"A6", x"C2", x"23", x"3D", x"EE", x"4C", x"95", x"0B", x"42", x"FA", x"C3", x"4E",
	x"08", x"2E", x"A1", x"66", x"28", x"D9", x"24", x"B2", x"76", x"5B", x"A2", x"49", x"6D", x"8B", x"D1", x"25",
	x"72", x"F8", x"F6", x"64", x"86", x"68", x"98", x"16", x"D4", x"A4", x"5C", x"CC", x"5D", x"65", x"B6", x"92",
	x"6C", x"70", x"48", x"50", x"FD", x"ED", x"B9", x"DA", x"5E", x"15", x"46", x"57", x"A7", x"8D", x"9D", x"84",
	x"90", x"D8", x"AB", x"00", x"8C", x"BC", x"D3", x"0A", x"F7", x"E4", x"58", x"05", x"B8", x"B3", x"45", x"06",
	x"D0", x"2C", x"1E", x"8F", x"CA", x"3F", x"0F", x"02", x"C1", x"AF", x"BD", x"03", x"01", x"13", x"8A", x"6B",
	x"3A", x"91", x"11", x"41", x"4F", x"67", x"DC", x"EA", x"97", x"F2", x"CF", x"CE", x"F0", x"B4", x"E6", x"73",
	x"96", x"AC", x"74", x"22", x"E7", x"AD", x"35", x"85", x"E2", x"F9", x"37", x"E8", x"1C", x"75", x"DF", x"6E",
	x"47", x"F1", x"1A", x"71", x"1D", x"29", x"C5", x"89", x"6F", x"B7", x"62", x"0E", x"AA", x"18", x"BE", x"1B",
	x"FC", x"56", x"3E", x"4B", x"C6", x"D2", x"79", x"20", x"9A", x"DB", x"C0", x"FE", x"78", x"CD", x"5A", x"F4",
	x"1F", x"DD", x"A8", x"33", x"88", x"07", x"C7", x"31", x"B1", x"12", x"10", x"59", x"27", x"80", x"EC", x"5F",
	x"60", x"51", x"7F", x"A9", x"19", x"B5", x"4A", x"0D", x"2D", x"E5", x"7A", x"9F", x"93", x"C9", x"9C", x"EF",
	x"A0", x"E0", x"3B", x"4D", x"AE", x"2A", x"F5", x"B0", x"C8", x"EB", x"BB", x"3C", x"83", x"53", x"99", x"61",
	x"17", x"2B", x"04", x"7E", x"BA", x"77", x"D6", x"26", x"E1", x"69", x"14", x"63", x"55", x"21", x"0C", x"7D"
	);
end crypt_pack;

package body crypt_pack is

	function state_to_bit128(data_i : state_t) return bit128 is
		variable data_v : bit128;
	begin
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				data_v(127 - 32 * j - 8 * i downto 120 - 32 * j - 8 * i) := data_i(i)(j);
			end loop;
		end loop;

		return data_v;
	end function;

	function state_to_word(data_i : state_t) return word_t is
		variable data_v : word_t;
	begin
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				data_v(i)(j) := data_i(j)(i);
			end loop;
		end loop;

		return data_v;
	end function;

	function word_to_bit128(data_i : word_t) return bit128 is
		variable data_v : bit128;
	begin
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				data_v(127 - 32 * i - 8 * j downto 120 - 32 * i - 8 * j) := data_i(i)(j);
			end loop;
		end loop;

		return data_v;
	end function;

	function word_to_state(data_i : word_t) return state_t is
		variable data_v : state_t;
	begin
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				data_v(i)(j) := data_i(j)(i);
			end loop;
		end loop;

		return data_v;
	end function;

	function bit128_to_state(data_i : bit128) return state_t is
		variable data_v : state_t;
	begin
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				data_v(i)(j) := data_i(127 - 32 * j - 8 * i downto 120 - 32 * j - 8 * i);
			end loop;
		end loop;

		return data_v;
	end function;

	function bit128_to_word(data_i : bit128) return word_t is
		variable data_v : word_t;
	begin
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				data_v(i)(j) := data_i(127 - 32 * i - 8 * j downto 120 - 32 * i - 8 * j);
			end loop;
		end loop;

		return data_v;
	end function;

	function "xor" (l, r : col_state_t) return col_state_t is
		variable result : col_state_t;
	begin
		for i in 0 to 3 loop
			result(i) := l(i) xor r(i);
		end loop;
		return result;
	end "xor";

end crypt_pack;