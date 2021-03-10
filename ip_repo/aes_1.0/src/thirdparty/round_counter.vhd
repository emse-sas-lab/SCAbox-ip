-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file round_counter.vhd
--! @brief AES round counter
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;

entity round_counter is
  port (
    clock_i  : in std_logic;
    resetb_i : in std_logic;
    en_i     : in std_logic;
    up_i     : in std_logic;
    count_i  : in bit4;
    count_o  : out bit4
  );
end round_counter;

architecture round_counter_arch of round_counter is

  signal count_s : integer range 0 to 10;

begin

  count_o <= std_logic_vector(to_unsigned(count_s, 4));

  count : process (clock_i, resetb_i)
  begin
    if (resetb_i = '0') then
      count_s <= 0;
    elsif rising_edge(clock_i) then
      if en_i = '0' then
        count_s <= to_integer(unsigned(count_i));
      elsif en_i = '1' then
        if up_i = '1' then
          if count_s = to_integer(unsigned(count_i)) + 10 then
            count_s <= to_integer(unsigned(count_i));
          else
            count_s <= count_s + 1;
          end if;
        else
          if count_s = 0 then
            count_s <= to_integer(unsigned(count_i));
          else
            count_s <= count_s - 1;
          end if;
        end if;
      end if;
    end if;
  end process; -- count

end round_counter_arch; -- round_counter_arch