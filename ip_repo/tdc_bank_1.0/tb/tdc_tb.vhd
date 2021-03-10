-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file tdc_tb.vhd
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity tdc_tb is
end tdc_tb;

architecture tdc_tb_arch of tdc_tb is

    signal clock_s : std_logic := '0';
    signal delta_s : std_logic;
    signal coarse_delay_s : std_logic_vector(bits_per_coarse_c - 1 downto 0) := "00";
    signal fine_delay_s : std_logic_vector(bits_per_fine_c - 1 downto 0) := "0000";
    signal data_s : std_logic_vector(31 downto 0);

    component tdc
      generic (
        length_coarse_g : positive;
        length_fine_g : positive;
        depth_g : positive
      );
      port (
        clock_i : in std_logic;
        delta_i  : in std_logic;
        coarse_delay_i : in std_logic_vector(bits_per_coarse_c - 1 downto 0);
        fine_delay_i : in std_logic_vector(bits_per_fine_c - 1 downto 0);
        delta_o : out std_logic;
        data_o : out std_logic_vector(4 * depth_g - 1 downto 0)
      );
    end component;

begin

    clock_s <= not clock_s after 10 ns;
    coarse_delay_s <= std_logic_vector((unsigned(coarse_delay_s) + 1)) after 200 ns;
    fine_delay_s <= std_logic_vector((unsigned(fine_delay_s) + 1)) after 800 ns;

    DUT : tdc
    generic map(
      length_coarse_g => 2,
      length_fine_g => 2,
      depth_g => 8
    )
    port map (
        clock_i => clock_s,
        delta_i => clock_s,
        coarse_delay_i => coarse_delay_s,
        fine_delay_i => fine_delay_s,
        delta_o => delta_s,
        data_o => data_s
    );

end tdc_tb_arch ; -- tdc_tb_arch