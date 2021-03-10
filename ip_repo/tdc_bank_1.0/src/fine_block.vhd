-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file fine_block.vhd
--! @brief Fine delay block, providing a small amount of delay
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

library rtl;
use rtl.tdc_pack.all;

entity fine_block is
    port (
        delta_i : in std_logic;
        delta_o : out std_logic;
        delay_i : in std_logic_vector(1 downto 0);
        clock_o : out std_logic
    );
    attribute dont_touch : string;
    attribute dont_touch of fine_block : entity is "true";
end fine_block;

architecture fine_block_arch of fine_block is

    signal lut_s : std_logic_vector(4 downto 0);
    attribute dont_touch of lut_s : signal is "true";
    signal mux_s : std_logic_vector(3 downto 0);
    attribute dont_touch of mux_s : signal is "true";

    attribute dont_touch of middle_mux_0 : label is "true";
    attribute dont_touch of middle_mux_1 : label is "true";
    attribute dont_touch of out_mux : label is "true";
begin

    lut_s(0) <= delta_i;
    delta_o <= lut_s(4);
    delay_path : for k in 0 to 3 generate
        attribute dont_touch of lut : label is "true";
    begin
        lut : lut1
        generic map(INIT => "10")
        port map(
            I0 => lut_s(k),
            O  => lut_s(k + 1)
        );
    end generate; -- luts

    middle_mux_0 : muxf7
    port map(
        I0 => lut_s(1),
        I1 => lut_s(2),
        S  => delay_i(0),
        O  => mux_s(0)
    );

    middle_mux_1 : muxf7
    port map(
        I0 => lut_s(3),
        I1 => lut_s(4),
        S  => delay_i(0),
        O  => mux_s(1)
    );

    out_mux : muxf8
    port map(
        I0 => mux_s(0),
        I1 => mux_s(1),
        S  => delay_i(1),
        O  => clock_o
    );

end fine_block_arch; -- fine_block_arch