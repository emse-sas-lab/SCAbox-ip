-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file tdc.vhd
--! @brief Top level wrapper
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library rtl;
use rtl.all;
use rtl.tdc_pack.all;

entity tdc is
  generic (
    length_coarse_g : positive := 1;
    length_fine_g   : positive := 1;
    depth_g         : positive := 4
  );
  port (
    clock_i        : in std_logic;
    delta_i        : in std_logic;
    coarse_delay_i : in std_logic_vector(bits_per_coarse_c - 1 downto 0);
    fine_delay_i   : in std_logic_vector(bits_per_fine_c - 1 downto 0);
    delta_o        : out std_logic;
    state_o        : out std_logic_vector(state_width(depth_g) - 1 downto 0)
  );
  attribute dont_touch : string;
  attribute dont_touch of tdc : entity is "true";
end tdc;

architecture tdc_arch of tdc is

  signal delta_fine_s : std_logic;
  signal delta_coarse_s : std_logic;

  component fine_line
    generic (
      length_g : positive
    );
    port (
      delay_i : in std_logic_vector(bits_per_fine_c - 1 downto 0);
      delta_i : in std_logic;
      delta_o : out std_logic;
      clock_o : out std_logic
    );
  end component;

  component coarse_line
    generic (
      length_g : positive
    );
    port (
      delay_i : in std_logic_vector(bits_per_coarse_c - 1 downto 0);
      delta_i : in std_logic;
      delta_o : out std_logic;
      clock_o : out std_logic
    );
  end component;

  component sampling_line
    generic (
      depth_g : positive
    );
    port (
      clock_i : in std_logic;
      delta_i : in std_logic;
      delta_o : out std_logic;
      state_o : out std_logic_vector(state_width(depth_g) - 1 downto 0)
    );
  end component;

begin

  coarse : coarse_line
  generic map(
    length_g => length_coarse_g
  )
  port map(
    delta_i => delta_i,
    clock_o => delta_coarse_s,
    delay_i => coarse_delay_i
  );

  fine : fine_line
  generic map(
    length_g => length_fine_g
  )
  port map(
    delta_i => delta_coarse_s,
    clock_o => delta_fine_s,
    delay_i => fine_delay_i
  );

  sampling : sampling_line
  generic map(
    depth_g => depth_g
  )
  port map(
    clock_i => clock_i,
    delta_i => delta_fine_s,
    delta_o => delta_o,
    state_o => state_o
  );

end tdc_arch; -- tdc_arch