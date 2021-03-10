library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity fifo_fsm is
	port (
		clock_i   : in std_logic;
		reset_i   : in std_logic;
		read_i    : in std_logic;
		write_i   : in std_logic;
		empty_i   : in std_logic;
		full_i    : in std_logic;
		reached_i : in std_logic;
		write_o   : out std_logic;
		read_o    : out std_logic
	);
end fifo_fsm;

architecture fifo_fsm_arch of fifo_fsm is

	type fifo_state_t is (hold, pop, push, popped, reset);

	signal current_state, next_state : fifo_state_t;
begin
	state_reg : process (clock_i, reset_i)
	begin
		if reset_i = '1' then
			current_state <= reset;
		elsif rising_edge(clock_i) then
			current_state <= next_state;
		end if;
	end process state_reg;

	state_comb : process (current_state, read_i, write_i)

	begin
		case current_state is
			when reset =>
				next_state <= hold;
			when hold =>
				if read_i = '1' then
					next_state <= pop;
				elsif write_i = '1' then
					next_state <= push;
				else
					next_state <= hold;
				end if;
			when pop =>
				next_state <= popped;
			when push =>
				if write_i = '0' then
					next_state <= hold;
				else
					next_state <= push;
				end if;
			when popped =>
				if read_i = '0' then
					next_state <= hold;
				else
					next_state <= popped;
				end if;
			when others =>
				next_state <= reset;
		end case;
	end process state_comb;

	out_comb : process (current_state, empty_i, full_i, reached_i)
		variable remaining_v : std_logic;
	begin
		case current_state is
			when reset =>
				write_o <= '0';
				read_o <= '0';
			when hold =>
				write_o <= '0';
				read_o <= '0';
			when pop =>
				write_o <= '0';
				read_o <= not empty_i;
			when push =>
				write_o <= not full_i and not reached_i;
				read_o <= '0';
			when popped =>
				write_o <= '0';
				read_o <= '0';
			when others =>
				write_o <= '0';
				read_o <= '0';
		end case;
	end process out_comb;
end fifo_fsm_arch; -- fifo_fsm_arch