library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library rtl;
use rtl.all;
use rtl.ro_pack.all;

entity ro_bank is
    generic (
        count_g : positive := 16;
        depth_g : positive := 8;
        width_g : positive := 32
    );
    port (
        clock_i : in std_logic;
        sel_i   : in std_logic_vector(sel_width(count_g) - 1 downto 0);
        step_o  : out std_logic_vector(width_g - 1 downto 0);
        steps_o : out std_logic_vector(count_g * state_width(depth_g) - 1 downto 0);
        state_o : out std_logic_vector(state_width(depth_g) - 1 downto 0)
    );
end ro_bank;

architecture ro_bank_arch of ro_bank is

    component ro is
        generic (
            depth_g : positive := 8
        );
        port (
            clock_i : in std_logic;
            state_o : out std_logic_vector(depth_g - 1 downto 0)
        );
    end component;

    component ro_coder is
        generic (
            depth_g : positive := 8
        );
        port (
            state_i : in std_logic_vector(depth_g - 1 downto 0);
            state_o : out std_logic_vector(state_width(depth_g) - 1 downto 0)
        );
    end component;

    component ro_output is
        generic (
            count_g : positive := 8;
            depth_g : positive := 8;
            width_g : positive := 32
        );
        port (
            clock_i : in std_logic;
            state_i : in std_logic_vector(count_g * state_width(depth_g) - 1 downto 0);
            sel_i   : in std_logic_vector(sel_width(count_g) - 1 downto 0);
            step_o  : out std_logic_vector(width_g - 1 downto 0);
            steps_o : out std_logic_vector(count_g * state_width(depth_g) - 1 downto 0);
            state_o : out std_logic_vector(state_width(depth_g) - 1 downto 0)
        );
    end component;

    signal raw_state_s : std_logic_vector(count_g * depth_g - 1 downto 0);
    signal coded_state_s : std_logic_vector(count_g * state_width(depth_g) - 1 downto 0);
begin

    bank : for i in 0 to count_g - 1 generate
        sensors : ro
        generic map(
            depth_g => depth_g
        )
        port map(
            clock_i => clock_i,
            state_o => raw_state_s((i + 1) * depth_g - 1 downto i * depth_g)
        );

        encoders : ro_coder
        generic map(
            depth_g => depth_g
        )
        port map(
            state_i => raw_state_s((i + 1) * depth_g - 1 downto i * depth_g),
            state_o => coded_state_s((i + 1) * state_width(depth_g) - 1 downto i * state_width(depth_g))
        );
    end generate; -- bank

    outputs : ro_output
    generic map(
        count_g => count_g,
        depth_g => depth_g,
        width_g => width_g
    )
    port map(
        clock_i => clock_i,
        state_i => coded_state_s,
        sel_i   => sel_i,
        step_o  => step_o,
        steps_o => steps_o,
        state_o => state_o
    );

end ro_bank_arch; -- ro_bank_arch