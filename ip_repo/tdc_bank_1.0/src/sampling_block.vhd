-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file sampling_block.vhd
--! @brief Delay line block with intermediate 4-bit output
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

library rtl;
use rtl.tdc_pack.all;

entity sampling_block is
	port (
		clock_i : in std_logic;
		delta_i : in std_logic;
		delta_o : out std_logic;
		state_o  : out std_logic_vector(bits_per_depth_c - 1 downto 0)
	);
	attribute dont_touch : string;
	attribute dont_touch of sampling_block : entity is "true";
end sampling_block;

architecture sampling_block_arch of sampling_block is

	signal carry_s : std_logic_vector(3 downto 0);
	attribute dont_touch of carry_s : signal is "true";

	attribute dont_touch of delay_path : label is "true";

begin
	delta_o <= carry_s(3);

	delay_path : carry4
	port map(
		CO     => carry_s,
		CI     => delta_i,
		CYINIT => '0',
		DI     => "0000",
		S      => "1111"
	);

	sampling_path : for k in 0 to 3 generate
		attribute dont_touch of reg : label is "true";
	begin
		reg : fdce
		generic map(INIT => '0')
		port map(
			Q   => state_o(k),
			C   => clock_i,
			CE  => '1',
			CLR => '0',
			D   => carry_s(k)
		);
	end generate; -- delay_reg

end sampling_block_arch; -- sampling_block_arch