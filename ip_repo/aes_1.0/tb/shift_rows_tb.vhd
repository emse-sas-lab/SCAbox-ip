-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file shift_rows_tb.vhd
-------------------------------------------------------

library ieee;
library lib_round;
library lib_thirdparty;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use lib_thirdparty.crypt_pack.all;
use lib_round.all;

entity shift_rows_tb is
end entity shift_rows_tb;

architecture shift_rows_tb_arch of shift_rows_tb is
    signal data_is : state_t;
    signal data_os : state_t;

    component shift_rows
        port (
            data_i : in state_t;
            en_i   : in std_logic;
            inv_i  : in std_logic;
            data_o : out state_t
        );
    end component;

begin
    DUT : shift_rows
    port map(
        data_i => data_is,
        en_i   => '1',
        inv_i  => '0',
        data_o => data_os
    );

    PUT : process
    begin
        data_is <=
            (
            (x"00", x"01", x"00", x"00"),
            (x"01", x"00", x"00", x"00"),
            (x"00", x"00", x"01", x"00"),
            (x"00", x"00", x"00", x"01")
            );
        wait;
    end process PUT;

end architecture shift_rows_tb_arch;

configuration shift_rows_tb_conf of shift_rows_tb is
    for shift_rows_tb_arch
        for DUT : shift_rows
            use entity lib_round.shift_rows(shift_rows_arch);
        end for;
    end for;
end configuration;