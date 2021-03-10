
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


package ro_pack is
    function sel_width(count : positive) return positive;
    function state_width(depth : positive) return positive;
end ro_pack;

package body ro_pack is
    function sel_width(count : positive) return positive is
    begin
        return integer(ceil(log2(real(count))));
    end function;

    function state_width(depth : positive) return positive is
    begin
        return integer(ceil(log2(real(2 * depth - 1))));
    end function;
end ro_pack;
