-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file state_reg.vhd
--! @brief Synchronous register for round and key data block
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;

entity state_reg is
	port (
		data_i   : in bit128;
		resetb_i : in std_logic;
		clock_i  : in std_logic;
		we_i     : in std_logic;
		data_o   : out bit128
	);
end state_reg;

architecture state_reg_arch of state_reg is

	signal data_s : bit128;

begin
	data_o <= data_s;

	data_register : process (clock_i, resetb_i)
	begin
		if resetb_i = '0' then
			data_s <= (others => '0');
		elsif rising_edge(clock_i) then
			if we_i = '1' then
				data_s <= data_i;
			else
				data_s <= data_s;
			end if;
		end if;
	end process; -- register

end state_reg_arch; -- state_reg_arch