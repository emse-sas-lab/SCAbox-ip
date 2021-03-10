-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file aes_fsm.vhd
--! @brief top level FSM
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;

entity aes_fsm is
	port (
		resetb_i        : in std_logic;
		clock_i         : in std_logic;
		start_i         : in std_logic;
		count_i         : in bit4;
		end_keyexp_i    : in std_logic;
		invb_i          : in std_logic;
		start_keyexp_o  : out std_logic;
		en_mixcolumns_o : out std_logic;
		en_round_o      : out std_logic;
		en_out_o        : out std_logic;
		en_count_o      : out std_logic;
		up_count_o      : out std_logic;
		we_data_o       : out std_logic;
		data_src_o      : out std_logic;
		done_o          : out std_logic
	);
end aes_fsm;

architecture aes_fsm_arch of aes_fsm is
	type aes_state_t is (reset, hold, init, start_keyexp, load_keyexp, wait_keyexp, ready_keyexp, round0, roundn, lastround, done);
	signal current_state, next_state : aes_state_t;
begin

	state_register : process (clock_i, resetb_i)
	begin
		if resetb_i = '0' then
			current_state <= reset;
		elsif rising_edge(clock_i) then
			current_state <= next_state;
		end if;
	end process state_register;

	state_comb : process (current_state, count_i, start_i, end_keyexp_i, invb_i)
	begin
		case current_state is
			when reset =>
				next_state <= hold;
			when hold =>
				if start_i = '1' then
					next_state <= init;
				else
					next_state <= hold;
				end if;
			when init =>
				if end_keyexp_i = '1' then
					next_state <= round0;
				else
					next_state <= start_keyexp;
				end if;
			when start_keyexp =>
				next_state <= load_keyexp;
			when load_keyexp =>
				if invb_i = '1' then
					next_state <= round0;
				else
					next_state <= wait_keyexp;
				end if;
			when wait_keyexp =>
				if end_keyexp_i = '1' then
					next_state <= ready_keyexp;
				else
					next_state <= wait_keyexp;
				end if;
			when ready_keyexp =>
				next_state <= round0;
			when round0 =>
				next_state <= roundn;
			when roundn =>
				if (count_i = x"9" and invb_i = '1') or (count_i = x"1" and invb_i = '0') then
					next_state <= lastround;
				else
					next_state <= roundn;
				end if;
			when lastround =>
				next_state <= done;
			when done =>
				next_state <= done;
				if start_i = '0' then
					next_state <= hold;
				else
					next_state <= done;
				end if;
			when others =>
				next_state <= reset;
		end case;
	end process state_comb;

	out_comb : process (current_state, count_i)
	begin
		case current_state is
			when reset =>
				start_keyexp_o <= '0';
				en_mixcolumns_o <= '0';
				en_round_o <= '0';
				en_out_o <= '1';
				en_count_o <= '0';
				up_count_o <= '1';
				we_data_o <= '0';
				data_src_o <= '1';
				done_o <= '0';
			when hold =>
				start_keyexp_o <= '0';
				en_mixcolumns_o <= '0';
				en_round_o <= '0';
				en_out_o <= '1';
				en_count_o <= '0';
				up_count_o <= '1';
				we_data_o <= '0';
				data_src_o <= '1';
				done_o <= '0';
			when init =>
				start_keyexp_o <= '0';
				en_mixcolumns_o <= '0';
				en_round_o <= '0';
				en_out_o <= '1';
				en_count_o <= '0';
				up_count_o <= invb_i;
				we_data_o <= '1';
				data_src_o <= '1';
				done_o <= '0';
			when start_keyexp =>
				start_keyexp_o <= '1';
				en_mixcolumns_o <= '0';
				en_round_o <= '0';
				en_out_o <= '1';
				en_count_o <= '0';
				up_count_o <= '1';
				we_data_o <= '1';
				data_src_o <= '1';
				done_o <= '0';
			when load_keyexp =>
				start_keyexp_o <= '0';
				en_mixcolumns_o <= '0';
				en_round_o <= '0';
				en_out_o <= '1';
				en_count_o <= '0';
				up_count_o <= '1';
				we_data_o <= '0';
				data_src_o <= '0';
				done_o <= '0';
			when wait_keyexp =>
				start_keyexp_o <= '0';
				en_mixcolumns_o <= '0';
				en_round_o <= '0';
				en_out_o <= '1';
				en_count_o <= '1';
				up_count_o <= '1';
				we_data_o <= '0';
				data_src_o <= '0';
				done_o <= '0';
			when ready_keyexp =>
				start_keyexp_o <= '0';
				en_mixcolumns_o <= '0';
				en_round_o <= '0';
				en_out_o <= '1';
				en_count_o <= '1';
				up_count_o <= invb_i;
				we_data_o <= '0';
				data_src_o <= '0';
				done_o <= '0';
			when round0 =>
				start_keyexp_o <= '0';
				en_mixcolumns_o <= '0';
				en_round_o <= '0';
				en_out_o <= '1';
				en_count_o <= '1';
				up_count_o <= invb_i;
				we_data_o <= '1';
				data_src_o <= '0';
				done_o <= '0';
			when roundn =>
				start_keyexp_o <= '0';
				en_mixcolumns_o <= '1';
				en_round_o <= '1';
				en_out_o <= '1';
				en_count_o <= '1';
				up_count_o <= invb_i;
				we_data_o <= '1';
				data_src_o <= '0';
				done_o <= '0';
			when lastround =>
				start_keyexp_o <= '0';
				en_mixcolumns_o <= '0';
				en_round_o <= '1';
				en_out_o <= '1';
				en_count_o <= '1';
				up_count_o <= invb_i;
				we_data_o <= '1';
				data_src_o <= '0';
				done_o <= '0';
			when done =>
				start_keyexp_o <= '0';
				en_mixcolumns_o <= '0';
				en_round_o <= '1';
				en_out_o <= '1';
				en_count_o <= '0';
				up_count_o <= '1';
				we_data_o <= '0';
				data_src_o <= '0';
				done_o <= '1';
			when others =>
				start_keyexp_o <= '0';
				en_mixcolumns_o <= '0';
				en_round_o <= '0';
				en_out_o <= '1';
				en_count_o <= '0';
				up_count_o <= '0';
				we_data_o <= '0';
				data_src_o <= '0';
				done_o <= '0';
		end case;
	end process out_comb;
end aes_fsm_arch;