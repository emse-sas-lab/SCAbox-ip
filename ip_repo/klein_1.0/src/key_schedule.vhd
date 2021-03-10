library ieee;
use ieee.std_logic_1164.all;
use work.util.all;

entity key_schedule is
    generic(k: natural := 64);
    port(data_in:  in std_logic_vector(k-1 downto 0);
         rc:       in std_logic_vector(4 downto 0);
         data_out: out std_logic_vector(k-1 downto 0)
    );
end key_schedule;

architecture structural of key_schedule is
    signal rotated, swapped: std_logic_vector(k-1 downto 0);

    component sbox
        port(data_in:  in std_logic_vector(3 downto 0);
             data_out: out std_logic_vector(3 downto 0)
        );
    end component;
begin
    rotated <= data_in(k-9 downto k/2) & data_in(k-1 downto k-8) &
               data_in((k/2)-9 downto 0) & data_in((k/2)-1 downto (k/2)-8);

    swapped <= rotated((k/2)-1 downto 0) &
               (rotated(k-1 downto k/2) xor rotated((k/2)-1 downto 0));

    data_out(k-1 downto k-19) <= swapped(k-1 downto k-19);
    data_out(k-20 downto k-24) <= swapped(k-20 downto k-24) xor rc;
    data_out(k-25 downto (k/2)-8) <= swapped(k-25 downto (k/2)-8);
    GEN_SBOXES: for i in 0 to 3 generate
        SX: sbox port map(
            data_in => swapped((k/2)-9-(4*i) downto (k/2)-9-(4*i)-3),
            data_out => data_out((k/2)-9-(4*i) downto (k/2)-9-(4*i)-3)
        );
    end generate;
    data_out((k/2)-25 downto 0) <= swapped((k/2)-25 downto 0);
end architecture;
