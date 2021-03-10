-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file test_pack.vhd
--! @brief NIST test values for AES algorithm
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;

package test_pack is

	type test_data_t is array(0 to 10) of state_t;
	type round_data_t is array(0 to 11) of bit128;

	constant std_input_c : bit128 := x"00112233445566778899aabbccddeeff";
	constant std_output_c : bit128 := x"69c4e0d86a7b0430d8cdb78070b4c55a";
	constant std_input_key_c : bit128 := x"000102030405060708090a0b0c0d0e0f";
	constant std_rounddata_c : round_data_t :=
	(
	x"00112233445566778899aabbccddeeff",
	x"00102030405060708090a0b0c0d0e0f0",
	x"89d810e8855ace682d1843d8cb128fe4",
	x"4915598f55e5d7a0daca94fa1f0a63f7",
	x"fa636a2825b339c940668a3157244d17",
	x"247240236966b3fa6ed2753288425b6c",
	x"c81677bc9b7ac93b25027992b0261996",
	x"c62fe109f75eedc3cc79395d84f9cf5d",
	x"d1876c0f79c4300ab45594add66ff41f",
	x"fde3bad205e5d0d73547964ef1fe37f1",
	x"bd6e7c3df2b5779e0b61216e8b10b689",
	x"69c4e0d86a7b0430d8cdb78070b4c55a"
	);
	constant std_rounddata_inv_c : round_data_t :=
	(
	x"69c4e0d86a7b0430d8cdb78070b4c55a",
	x"7ad5fda789ef4e272bca100b3d9ff59f",
	x"54d990a16ba09ab596bbf40ea111702f",
	x"3e1c22c0b6fcbf768da85067f6170495",
	x"b458124c68b68a014b99f82e5f15554c",
	x"e8dab6901477d4653ff7f5e2e747dd4f",
	x"36339d50f9b539269f2c092dc4406d23",
	x"2d6d7ef03f33e334093602dd5bfb12c7",
	x"3bd92268fc74fb735767cbe0c0590e2d",
	x"a7be1a6997ad739bd8c9ca451f618b61",
	x"6353e08c0960e104cd70b751bacad0e7",
	x"00112233445566778899aabbccddeeff"
	);
	constant std_roundkey_c : round_data_t :=
	(
	x"000102030405060708090a0b0c0d0e0f",
	x"d6aa74fdd2af72fadaa678f1d6ab76fe",
	x"b692cf0b643dbdf1be9bc5006830b3fe",
	x"b6ff744ed2c2c9bf6c590cbf0469bf41",
	x"47f7f7bc95353e03f96c32bcfd058dfd",
	x"3caaa3e8a99f9deb50f3af57adf622aa",
	x"5e390f7df7a69296a7553dc10aa31f6b",
	x"14f9701ae35fe28c440adf4d4ea9c026",
	x"47438735a41c65b9e016baf4aebf7ad2",
	x"549932d1f08557681093ed9cbe2c974e",
	x"13111d7fe3944a17f307a78b4d2b30c5",
	x"00000000000000000000000000000000"
	);
	constant std_roundkey_inv_c : round_data_t :=
	(
	x"13111d7fe3944a17f307a78b4d2b30c5",
	x"13aa29be9c8faff6f770f58000f7bf03",
	x"1362a4638f2586486bff5a76f7874a83",
	x"8d82fc749c47222be4dadc3e9c7810f5",
	x"72e3098d11c5de5f789dfe1578a2cccb",
	x"2ec410276326d7d26958204a003f32de",
	x"a8a2f5044de2c7f50a7ef79869671294",
	x"c7c6e391e54032f1479c306d6319e50c",
	x"a0db02992286d160a2dc029c2485d561",
	x"8c56dff0825dd3f9805ad3fc8659d7fd",
	x"000102030405060708090a0b0c0d0e0f",
	x"00000000000000000000000000000000"
	);
	constant std_shift_rows_data_c : test_data_t :=
	(
	(
	(x"32", x"88", x"31", x"e0"),
	(x"43", x"5a", x"31", x"37"),
	(x"f6", x"30", x"98", x"07"),
	(x"a8", x"8d", x"a2", x"34")
	),
	(
	(x"d4", x"e0", x"b8", x"1e"),
	(x"bf", x"b4", x"41", x"27"),
	(x"5d", x"52", x"11", x"98"),
	(x"30", x"ae", x"f1", x"e5")
	),
	(
	(x"49", x"45", x"7f", x"77"),
	(x"db", x"39", x"02", x"de"),
	(x"87", x"53", x"d2", x"96"),
	(x"3b", x"89", x"f1", x"1a")
	),
	(
	(x"ac", x"ef", x"13", x"45"),
	(x"c1", x"b5", x"23", x"73"),
	(x"d6", x"5a", x"cf", x"11"),
	(x"b8", x"7b", x"df", x"b5")
	),
	(
	(x"52", x"85", x"e3", x"f6"),
	(x"a4", x"11", x"cf", x"50"),
	(x"c8", x"6a", x"2f", x"5e"),
	(x"94", x"28", x"d7", x"07")
	),
	(
	(x"e1", x"e8", x"35", x"97"),
	(x"fb", x"c8", x"6c", x"4f"),
	(x"96", x"ae", x"d2", x"fb"),
	(x"7c", x"9b", x"ba", x"53")
	),
	(

	(x"a1", x"78", x"10", x"4c"),
	(x"4f", x"e8", x"d5", x"63"),
	(x"3d", x"03", x"a8", x"29"),
	(x"fe", x"fc", x"df", x"23")
	),
	(
	(x"f7", x"27", x"9b", x"54"),
	(x"83", x"43", x"b5", x"ab"),
	(x"40", x"3d", x"31", x"a9"),
	(x"3f", x"f0", x"ff", x"d3")
	),
	(
	(x"be", x"d4", x"0a", x"da"),
	(x"3b", x"e1", x"64", x"83"),
	(x"d4", x"f2", x"2c", x"86"),
	(x"fe", x"c8", x"c0", x"4d")
	),
	(
	(x"87", x"f2", x"4d", x"97"),
	(x"6e", x"4c", x"90", x"ec"),
	(x"46", x"e7", x"4a", x"c3"),
	(x"a6", x"8c", x"d8", x"95")
	),
	(
	(x"e9", x"cb", x"3d", x"af"),
	(x"31", x"32", x"2e", x"09"),
	(x"7d", x"2c", x"89", x"07"),
	(x"b5", x"72", x"5f", x"94")
	)
	);
	constant std_mix_columns_data_c : test_data_t :=
	(
	(
	(x"32", x"88", x"31", x"e0"),
	(x"43", x"5a", x"31", x"37"),
	(x"f6", x"30", x"98", x"07"),
	(x"a8", x"8d", x"a2", x"34")
	),
	(
	(x"04", x"e0", x"48", x"28"),
	(x"66", x"cb", x"f8", x"06"),
	(x"81", x"19", x"d3", x"26"),
	(x"e5", x"9a", x"7a", x"4c")
	),
	(
	(x"58", x"1b", x"db", x"1b"),
	(x"4d", x"4b", x"e7", x"6b"),
	(x"ca", x"5a", x"ca", x"b0"),
	(x"f1", x"ac", x"a8", x"e5")
	),
	(
	(x"75", x"20", x"53", x"bb"),
	(x"ec", x"0b", x"c0", x"25"),
	(x"09", x"63", x"cf", x"d0"),
	(x"93", x"33", x"7c", x"dc")
	),
	(
	(x"0f", x"60", x"6f", x"5e"),
	(x"d6", x"31", x"c0", x"b3"),
	(x"da", x"38", x"10", x"13"),
	(x"a9", x"bf", x"6b", x"01")
	),
	(
	(x"25", x"bd", x"b6", x"4c"),
	(x"d1", x"11", x"3a", x"4c"),
	(x"a9", x"d1", x"33", x"c0"),
	(x"ad", x"68", x"8e", x"b0")
	),
	(
	(x"4b", x"2c", x"33", x"37"),
	(x"86", x"4a", x"9d", x"d2"),
	(x"8d", x"89", x"f4", x"18"),
	(x"6d", x"80", x"e8", x"d8")
	),
	(
	(x"14", x"46", x"27", x"34"),
	(x"15", x"16", x"46", x"2a"),
	(x"b5", x"15", x"56", x"d8"),
	(x"bf", x"ec", x"d7", x"43")
	),
	(
	(x"00", x"b1", x"54", x"fa"),
	(x"51", x"c8", x"76", x"1b"),
	(x"2f", x"89", x"6d", x"99"),
	(x"d1", x"ff", x"cd", x"ea")
	),
	(
	(x"47", x"40", x"a3", x"4c"),
	(x"37", x"d4", x"70", x"9f"),
	(x"94", x"e4", x"3a", x"42"),
	(x"ed", x"a5", x"a6", x"bc")
	),
	(
	(x"e9", x"cb", x"3d", x"af"),
	(x"31", x"32", x"2e", x"09"),
	(x"7d", x"2c", x"89", x"07"),
	(x"b5", x"72", x"5f", x"94")
	)
	);

	constant std_sub_bytes_data_c : test_data_t :=
	(
	(
	(x"32", x"88", x"31", x"e0"),
	(x"43", x"5a", x"31", x"37"),
	(x"f6", x"30", x"98", x"07"),
	(x"a8", x"8d", x"a2", x"34")
	),
	(
	(x"d4", x"e0", x"b8", x"1e"),
	(x"27", x"bf", x"b4", x"41"),
	(x"11", x"98", x"5d", x"52"),
	(x"ae", x"f1", x"e5", x"30")
	),
	(
	(x"49", x"45", x"7f", x"77"),
	(x"de", x"db", x"39", x"02"),
	(x"d2", x"96", x"87", x"53"),
	(x"89", x"f1", x"1a", x"3b")
	),
	(
	(x"ac", x"ef", x"13", x"45"),
	(x"73", x"c1", x"b5", x"23"),
	(x"cf", x"11", x"d6", x"5a"),
	(x"7b", x"df", x"b5", x"b8")
	),
	(
	(x"52", x"85", x"e3", x"f6"),
	(x"50", x"a4", x"11", x"cf"),
	(x"2f", x"5e", x"c8", x"6a"),
	(x"28", x"d7", x"07", x"94")
	),
	(
	(x"e1", x"e8", x"35", x"97"),
	(x"4f", x"fb", x"c8", x"6c"),
	(x"d2", x"fb", x"96", x"ae"),
	(x"9b", x"ba", x"53", x"7c")
	),
	(
	(x"a1", x"78", x"10", x"4c"),
	(x"63", x"4f", x"e8", x"d5"),
	(x"a8", x"29", x"3d", x"03"),
	(x"fc", x"df", x"23", x"fe")
	),
	(
	(x"f7", x"27", x"9b", x"54"),
	(x"ab", x"83", x"43", x"b5"),
	(x"31", x"a9", x"40", x"3d"),
	(x"f0", x"ff", x"d3", x"3f")
	),
	(
	(x"be", x"d4", x"0a", x"da"),
	(x"83", x"3b", x"e1", x"64"),
	(x"2c", x"86", x"d4", x"f2"),
	(x"c8", x"c0", x"4d", x"fe")
	),
	(
	(x"87", x"f2", x"4d", x"97"),
	(x"ec", x"6e", x"4c", x"90"),
	(x"4a", x"c3", x"46", x"e7"),
	(x"8c", x"d8", x"95", x"a6")
	),
	(
	(x"e9", x"cb", x"3d", x"af"),
	(x"09", x"31", x"32", x"2e"),
	(x"89", x"07", x"7d", x"2c"),
	(x"72", x"5f", x"94", x"b5")
	)
	);

end package;