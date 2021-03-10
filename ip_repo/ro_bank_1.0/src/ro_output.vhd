library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library rtl;
use rtl.ro_pack.all;

entity ro_output is
    generic (
        count_g : positive := 16;
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
end ro_output;

architecture ro_output_arch of ro_output is
    constant state_width_c : positive := state_width(depth_g);

    type state_array_t is array (0 to count_g - 1) of std_logic_vector(state_width_c - 1 downto 0);

    signal last_state_s, curr_state_s : state_array_t;
    signal next_steps_s, curr_steps_s : state_array_t;
    signal next_step_s, curr_step_s : std_logic_vector(width_g - 1 downto 0);
    signal steps_s : std_logic_vector(count_g * state_width_c - 1 downto 0);
    signal states_s : state_array_t;
    component state_diff is
        generic (
            depth_g : positive := 8
        );
        port (
            clock_i : in std_logic;
            last_i  : in std_logic_vector(state_width_c - 1 downto 0);
            curr_i  : in std_logic_vector(state_width_c - 1 downto 0);
            step_o  : out std_logic_vector(state_width_c - 1 downto 0)
        );
    end component;

    component ro_exp_sum is
        generic (
            count_g : positive := 2;
            depth_g : positive := 8;
            width_g : positive := 32
        );
        port (
            clock_i : in std_logic;
            steps_i : in std_logic_vector(count_g * state_width(depth_g) - 1 downto 0);
            step_o  : out std_logic_vector(width_g - 1 downto 0)
        );
    end component;
begin
    state_o <= states_s(to_integer(unsigned(sel_i)));
    steps_o <= steps_s;

    concat_state : for i in 0 to count_g - 1 generate
        states_s(i) <= state_i(state_width_c * (i + 1) - 1 downto state_width_c * i);
    end generate; -- concat_state

    concat_steps : for i in 0 to count_g - 1 generate
        steps_s(state_width_c * (i + 1) - 1 downto state_width_c * i) <= curr_steps_s(i);
    end generate; -- concat_steps


    last_state_reg : process (clock_i)
    begin
        if rising_edge(clock_i) then
            last_state_s <= curr_state_s;
        else
            last_state_s <= last_state_s;
        end if;
    end process; -- state_reg

    state_reg : process (clock_i)
    begin
        if rising_edge(clock_i) then
            curr_state_s <= states_s;
        else
            curr_state_s <= curr_state_s;
        end if;
    end process; -- state_reg

    steps_reg : process (clock_i)
    begin
        if rising_edge(clock_i) then
            curr_steps_s <= next_steps_s;
        else
            curr_steps_s <= curr_steps_s;
        end if;
    end process; -- steps_reg

    step_reg : process (clock_i)
    begin
        if rising_edge(clock_i) then
            curr_step_s <= next_step_s;
        else
            curr_step_s <= curr_step_s;
        end if;
    end process; -- step_reg

    concat_diff : for i in 0 to count_g - 1 generate
        steps : state_diff
        generic map(
            depth_g => depth_g
        )
        port map(
            clock_i => clock_i,
            last_i  => last_state_s(i),
            curr_i  => curr_state_s(i),
            step_o  => next_steps_s(i)
        );
    end generate; -- concat_diff

    sum_diff : ro_exp_sum
    generic map(
        count_g => count_g,
        depth_g => depth_g,
        width_g => width_g
    )
    port map (
        clock_i => clock_i,
        steps_i => steps_s,
        step_o => step_o
    );
end ro_output_arch; -- ro_output_arch