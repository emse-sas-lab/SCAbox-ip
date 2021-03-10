-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file key_expansion_fsm.vhd
--! @brief FSM for the key expansion
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;

entity key_expansion_fsm is
	port (
		clock_i        : in std_logic;
		resetb_i       : in std_logic;
		start_i        : in std_logic;
		invb_i         : in std_logic;
		key_changedb_i : in std_logic;
		count_i        : in bit4;
		end_o          : out std_logic;
		we_key_o       : out std_logic
	);
end entity key_expansion_fsm;

architecture key_expansion_fsm_arch of key_expansion_fsm is
	type keyexp_state_t is (reset, hold, start, compute, done);
	signal current_state, next_state : keyexp_state_t;
begin
	state_register : process (clock_i, resetb_i) is
	begin
		if resetb_i = '0' then
			current_state <= reset;
		elsif rising_edge(clock_i) then
			current_state <= next_state;
		end if;
	end process state_register;

	state_comb : process (current_state, start_i, count_i)
	begin
		case current_state is
			when reset =>
				next_state <= hold;
			when hold =>
				if start_i = '1' then
					if key_changedb_i = '1' then
						next_state <= done;
					else
						next_state <= start;
					end if;
				else
					next_state <= hold;
				end if;
			when start =>
				if key_changedb_i = '0' then
					next_state <= compute;
				else
					next_state <= done;
				end if;
			when compute =>
				if count_i = x"9" then
					next_state <= done;
				else
					next_state <= compute;
				end if;
			when done =>
				next_state <= hold;
			when others =>
				next_state <= reset;
		end case;
	end process state_comb;

	out_comb : process (current_state, count_i)
	begin
		case current_state is
			when reset | hold =>
				end_o <= key_changedb_i;
				we_key_o <= '0';
			when start =>
				end_o <= invb_i;
				we_key_o <= '1';
			when compute =>
				end_o <= '0';
				we_key_o <= '1';
			when done =>
				end_o <= '1';
				we_key_o <= '0';
			when others =>
				end_o <= '0';
				we_key_o <= '0';
		end case;
	end process out_comb;

end architecture key_expansion_fsm_arch;