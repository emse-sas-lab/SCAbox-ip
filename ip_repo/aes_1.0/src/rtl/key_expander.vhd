-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file key_expander.vhd
--! @brief Key expansion top level combinatorial
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;

library lib_round;
use lib_round.all;

entity key_expander is
	port (
		key_i  : in bit128;
		rcon_i : in bit8;
		inv_i  : in std_logic;
		key_o  : out bit128
	);
end entity key_expander;

architecture key_expander_arch of key_expander is

	signal key_s : word_t;
	signal rot_s : word_t;
	signal sub_s : word_t;
	signal xor_s : word_t;
	signal mix_s : state_t;
	signal rcon_s : col_state_t;

begin

	key_s <= bit128_to_word(key_i);
	key_o <= word_to_bit128(xor_s);

	rcon_s(0) <= rcon_i;
	rcon_s(1) <= x"00";
	rcon_s(2) <= x"00";
	rcon_s(3) <= x"00";

	--rotword
	rot_s(0)(3) <= key_s(3)(0);
	rot_s(0)(0) <= key_s(3)(1);
	rot_s(0)(1) <= key_s(3)(2);
	rot_s(0)(2) <= key_s(3)(3);

	--subbytes
	sub_s(0)(0) <= sbox_c(to_integer(unsigned(rot_s(0)(0))));
	sub_s(0)(1) <= sbox_c(to_integer(unsigned(rot_s(0)(1))));
	sub_s(0)(2) <= sbox_c(to_integer(unsigned(rot_s(0)(2))));
	sub_s(0)(3) <= sbox_c(to_integer(unsigned(rot_s(0)(3))));

	--xor
	xor_s(0) <= rcon_s xor (sub_s(0) xor key_s(0));
	xor_s(1) <= key_s(1) xor xor_s(0);
	xor_s(2) <= key_s(2) xor xor_s(1);
	xor_s(3) <= key_s(3) xor xor_s(2);

end architecture key_expander_arch;