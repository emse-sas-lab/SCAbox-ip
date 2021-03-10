-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file coarse_line.vhd
--! @brief Coarse delay block, providing a large amount of delay
-------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity coarse_block is
    port (
        delta_i : in std_logic;
        delta_o : out std_logic
    );
    attribute dont_touch : string;
    attribute dont_touch of coarse_block : entity is "true";
end coarse_block;

architecture coarse_block_arch of coarse_block is

    signal lut_s : std_logic_vector(4 downto 0);
    attribute dont_touch of lut_s : signal is "true";

    signal latch_s : std_logic_vector(3 downto 0);
    attribute dont_touch of latch_s : signal is "true";

begin
    lut_s(0) <= delta_i;
    delta_o <= lut_s(4);
    delay_path : for k in 0 to 3 generate
        attribute dont_touch of lut : label is "true";
        attribute dont_touch of latch : label is "true";
    begin
        lut : lut1
        generic map(INIT => "10")
        port map(
            I0 => lut_s(k),
            O  => latch_s(k)
        );

        latch : ldce
        generic map(INIT => '0')
        port map(
            Q   => lut_s(k + 1),
            CLR => '0',
            D   => latch_s(k),
            G   => '1',
            GE  => '1'
        );
    end generate; -- delay_path
end coarse_block_arch; -- coarse_block_arch