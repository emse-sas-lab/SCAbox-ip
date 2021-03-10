-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file sampling_line.vhd
--! @brief Serial assembly of sampling blocks
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library rtl;
use rtl.all;
use rtl.tdc_pack.all;

entity sampling_line is
	generic (
		depth_g : positive := 1
	);
	port (
		clock_i : in std_logic;
		delta_i : in std_logic;
		delta_o : out std_logic;
		state_o : out std_logic_vector(state_width(depth_g) - 1 downto 0)
	);
	attribute dont_touch : string;
	attribute dont_touch of sampling_line : entity is "true";
end sampling_line;

architecture sampling_line_arch of sampling_line is

	signal delta_s : std_logic_vector(depth_g downto 0);
	attribute dont_touch of delta_s : signal is "true";

	component sampling_block
		port (
			clock_i : in std_logic;
			delta_i : in std_logic;
			delta_o : out std_logic;
			state_o : out std_logic_vector(bits_per_depth_c - 1 downto 0)
		);
	end component;
begin
	delta_s(0) <= delta_i;
	delta_o <= delta_s(depth_g);
	delay_line : for k in 0 to depth_g - 1 generate
		block_n : sampling_block
		port map(
			clock_i => clock_i,
			delta_i => delta_s(k),
			delta_o => delta_s(k + 1),
			state_o => state_o(bits_per_depth_c * (k + 1) - 1 downto bits_per_depth_c * k)
		);
	end generate; -- blocks

end sampling_line_arch; -- sampling_line_arch