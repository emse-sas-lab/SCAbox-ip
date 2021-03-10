-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file coarse_line.vhd
--! @brief Serial assembly of blocks containing 4 coarse block and a clock selector
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library rtl;
use rtl.all;
use rtl.tdc_pack.all;

entity coarse_line is
	generic (
		length_g : positive := 1
	);
	port (
		delay_i : in std_logic_vector(bits_per_coarse_c - 1 downto 0);
		delta_i : in std_logic;
		delta_o : out std_logic;
		clock_o : out std_logic
	);
	attribute dont_touch : string;
	attribute dont_touch of coarse_line : entity is "true";
end coarse_line;

architecture coarse_line_arch of coarse_line is

	type delta_array_t is array (0 to length_g) of std_logic_vector(4 downto 0);
	signal delta_s : delta_array_t;

	component coarse_block
		port (
			delta_i : in std_logic;
			delta_o : out std_logic
		);
	end component;

	component clock_mux
		port (
			clocks_i : in std_logic_vector(3 downto 0);
			delay_i  : in std_logic_vector(1 downto 0);
			clock_o  : out std_logic
		);
	end component;
begin

	delta_s(0)(0) <= delta_i;
	delta_o <= delta_s(length_g - 1)(4);
	clock_o <= delta_s(length_g)(0);

	delay_line : for k in 0 to length_g - 1 generate
		block_0 : coarse_block
		port map(
			delta_i => delta_s(k)(0),
			delta_o => delta_s(k)(1)
		);
		block_1 : coarse_block
		port map(
			delta_i => delta_s(k)(1),
			delta_o => delta_s(k)(2)
		);
		block_2 : coarse_block
		port map(
			delta_i => delta_s(k)(2),
			delta_o => delta_s(k)(3)
		);
		block_3 : coarse_block
		port map(
			delta_i => delta_s(k)(3),
			delta_o => delta_s(k)(4)
		);
		mux : clock_mux
		port map(
			clocks_i => delta_s(k)(4 downto 1),
			delay_i  => delay_i,
			clock_o  => delta_s(k + 1)(0)
		);
	end generate; -- coarse_line
end coarse_line_arch; -- coarse_line_arch