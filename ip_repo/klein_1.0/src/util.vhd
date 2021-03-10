library ieee;
use ieee.std_logic_1164.all;

package util is

    type rc_lookup is array(natural range <>) of std_logic_vector(4 downto 0);    
    constant final_rc: rc_lookup(0 to 100) := (
        64 => "01101",
        80 => "10001",
        96 => "10101",
        others => "00000"
    );
    
    type round_lookup is array(natural range <>) of natural;
    constant rounds: round_lookup(0 to 100) := (
        64 => 12,
        80 => 16,
        96 => 20,
        others => 0
    );
end package;
