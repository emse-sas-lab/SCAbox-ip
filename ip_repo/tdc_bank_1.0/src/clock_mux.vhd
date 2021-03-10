-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file clock_mux.vhd
--! @brief Multiplixer 4 to 1 to select delayed clock
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity clock_mux is
    port (
        clocks_i : in std_logic_vector(3 downto 0);
        delay_i  : in std_logic_vector(1 downto 0);
        clock_o  : out std_logic
    );
    attribute dont_touch : string;
    attribute dont_touch of clock_mux : entity is "true";
end clock_mux;

architecture clock_mux_arch of clock_mux is

    signal lut_s : std_logic_vector(3 downto 0);
    attribute dont_touch of lut_s : signal is "true";

    signal mux_s : std_logic_vector(1 downto 0);
    attribute dont_touch of mux_s : signal is "true";

    attribute dont_touch of middle_mux_0 : label is "true";
    attribute dont_touch of middle_mux_1 : label is "true";
    attribute dont_touch of out_mux : label is "true";
begin

    delay_path : for i in 0 to 3 generate
        attribute dont_touch of lut : label is "true";
    begin
        lut : lut1
        generic map(INIT => "10")
        port map(
            I0 => clocks_i(i),
            O  => lut_s(i)
        );
    end generate; -- delay_path

    middle_mux_0 : muxf7
    port map(
        I0 => lut_s(0),
        I1 => lut_s(1),
        S  => delay_i(0),
        O  => mux_s(0)
    );

    middle_mux_1 : muxf7
    port map(
        I0 => lut_s(2),
        I1 => lut_s(3),
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

end clock_mux_arch; -- clock_mux_arch