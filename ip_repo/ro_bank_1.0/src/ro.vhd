library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity ro is
	generic (
		depth_g : positive := 8
	);
	port (
		clock_i : in std_logic;
		state_o : out std_logic_vector(depth_g - 1 downto 0)
	);
	attribute dont_touch : string;
	attribute dont_touch of ro : entity is "true";

	attribute allow_combinatorial_loops : string;
	attribute allow_combinatorial_loops of ro : entity is "true";

end ro;

architecture ro_arch of ro is

	signal clock_s, last_s : std_logic;
	signal state_s : std_logic_vector(depth_g - 1 downto 0);

	attribute dont_touch of clock_s, last_s : signal is "true";
	attribute dont_touch of state_s : signal is "true";
	attribute allow_combinatorial_loops of clock_s : signal is "true";

	attribute dont_touch of oscillator : label is "true";
	attribute allow_combinatorial_loops of oscillator : label is "true";
	attribute dont_touch of last_inv : label is "true";
	attribute dont_touch of count_reg0 : label is "true";

begin

	oscillator : LUT2
	generic map(
		INIT => "0111")
	port map(
		O  => clock_s,
		I0 => clock_s,
		I1 => '1'
	);

	last_inv : LUT1
	generic map(
		INIT => "01")
	port map(
		O  => last_s,
		I0 => state_s(depth_g - 1)
	);

	count_reg0 : FDCE
	generic map(
		INIT => '0')
	port map(
		Q   => state_s(0),
		C   => clock_s,
		CE  => '1',
		CLR => '0',
		D   => last_s
	);

	counter : for k in 1 to depth_g - 1 generate
		attribute dont_touch of count_reg : label is "true";
	begin
		count_reg : FDCE
		generic map(
			INIT => '0')
		port map(
			Q   => state_s(k),
			C   => clock_s,
			CE  => '1',
			CLR => '0',
			D   => state_s(k - 1)
		);
	end generate; -- counter

	sampling : for k in 0 to depth_g - 1 generate
		attribute dont_touch of sampling_reg : label is "true";
	begin
		sampling_reg : FDCE
		generic map(
			INIT => '0')
		port map(
			Q   => state_o(k),
			C   => clock_i,
			CE  => '1',
			CLR => '0',
			D   => state_s(k)
		);

	end generate; -- sampling

end ro_arch; -- ro_arch