library ieee;
use ieee.std_logic_1164.all;

entity mul_poly is
    port(data_in:  in std_logic_vector(7 downto 0);
         data_out: out std_logic_vector(7 downto 0)
    );
end mul_poly;

architecture structural of mul_poly is
begin
    data_out(7) <= data_in(6);
    data_out(6) <= data_in(5);
    data_out(5) <= data_in(4);
    data_out(4) <= data_in(3) xor data_in(7);
    data_out(3) <= data_in(2) xor data_in(7);
    data_out(2) <= data_in(1);
    data_out(1) <= data_in(0) xor data_in(7);
    data_out(0) <= data_in(7);
end architecture;
