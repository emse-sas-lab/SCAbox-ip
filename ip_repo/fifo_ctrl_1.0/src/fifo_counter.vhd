library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity fifo_counter is
    generic (
        width_g : positive
    );
    port (
        clock_i : in std_logic;
        reset_i : in std_logic;
        up_i    : in std_logic;
        en_i    : in std_logic;
        count_o : out std_logic_vector(width_g - 1 downto 0)
    );
end fifo_counter;

architecture fifo_counter_arch of fifo_counter is
    signal count_s : unsigned(width_g - 1 downto 0);
begin

    count_o <= std_logic_vector(count_s);

    counter : process (clock_i, reset_i)
    begin
        if reset_i = '1' then
            count_s <= (others => '0');
        elsif rising_edge(clock_i) then
            if en_i = '1' then
                if up_i = '1' then
                    count_s <= count_s + 1;
                else
                    count_s <= count_s - 1;
                end if;
            else
                count_s <= count_s;
            end if;
        else
            count_s <= count_s;
        end if;
    end process counter;

end fifo_counter_arch; -- fifo_counter_arch