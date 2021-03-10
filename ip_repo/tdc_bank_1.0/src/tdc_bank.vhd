-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file tdc_bank.vhd
--! @brief Assembly of multiple TDC
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library rtl;
use rtl.all;
use rtl.tdc_pack.all;

entity tdc_bank is
    generic (
        length_coarse_g : positive := 1;
        length_fine_g   : positive := 1;
        depth_g         : positive := 4;
        count_g         : positive := 2;
        width_g         : positive := 32
    );
    port (
        clock_i        : in std_logic;
        delta_i        : in std_logic;
        sel_i          : in std_logic_vector(sel_width(count_g) - 1 downto 0);
        coarse_delay_i : in std_logic_vector(coarse_width(count_g) - 1 downto 0);
        fine_delay_i   : in std_logic_vector(fine_width(count_g) - 1 downto 0);
        delta_o        : out std_logic_vector(count_g - 1 downto 0);
        weights_o      : out std_logic_vector(weight_width(depth_g) * count_g - 1 downto 0);
        state_o        : out std_logic_vector(state_width(depth_g) - 1 downto 0);
        weight_o       : out std_logic_vector(width_g - 1 downto 0)
    );
end tdc_bank;

architecture tdc_bank_arch of tdc_bank is
    constant sel_width_c : positive := sel_width(count_g);
    constant coarse_width_c : positive := coarse_width(count_g);
    constant fine_width_c : positive := fine_width(count_g);
    constant state_width_c : positive := state_width(depth_g);
    constant weights_width_c : positive := weight_width(depth_g) * count_g;

    signal state_s : std_logic_vector(state_width_c * count_g - 1 downto 0);
    component tdc
        generic (
            length_coarse_g : positive;
            length_fine_g   : positive;
            depth_g         : positive
        );
        port (
            clock_i        : in std_logic;
            delta_i        : in std_logic;
            coarse_delay_i : in std_logic_vector(bits_per_coarse_c - 1 downto 0);
            fine_delay_i   : in std_logic_vector(bits_per_fine_c - 1 downto 0);
            delta_o        : out std_logic;
            state_o        : out std_logic_vector(state_width_c - 1 downto 0)
        );
    end component;

    component tdc_output is
        generic (
            depth_g : positive := 4;
            count_g : positive := 2;
            width_g : positive := 32
        );
        port (
            clock_i   : in std_logic;
            sel_i     : in std_logic_vector(sel_width_c - 1 downto 0);
            state_i   : in std_logic_vector(state_width_c * count_g - 1 downto 0);
            weight_o  : out std_logic_vector(width_g - 1 downto 0);
            weights_o : out std_logic_vector(weights_width_c - 1 downto 0);
            state_o   : out std_logic_vector(state_width_c - 1 downto 0)
        );
    end component;

begin
    bank : for i in 0 to count_g - 1 generate

        sensors : tdc
        generic map(
            length_coarse_g => length_coarse_g,
            length_fine_g   => length_fine_g,
            depth_g         => depth_g
        )
        port map(
            clock_i        => clock_i,
            delta_i        => delta_i,
            delta_o        => delta_o(i),
            coarse_delay_i => coarse_delay_i(bits_per_coarse_c * (i + 1) - 1 downto bits_per_coarse_c * i),
            fine_delay_i   => fine_delay_i(bits_per_fine_c * (i + 1) - 1 downto bits_per_fine_c * i),
            state_o        => state_s(state_width_c * (i + 1) - 1 downto state_width_c * i)
        );
    end generate; -- sensors

    outputs : tdc_output
    generic map(
        count_g => count_g,
        depth_g => depth_g,
        width_g => width_g
    )
    port map(
        clock_i   => clock_i,
        state_i   => state_s,
        sel_i     => sel_i,
        weight_o  => weight_o,
        weights_o => weights_o,
        state_o   => state_o
    );

end tdc_bank_arch; -- tdc_bank_arch