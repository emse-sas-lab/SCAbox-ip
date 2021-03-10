-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file add_roundkey_tb.vhd
-------------------------------------------------------

library ieee;
library lib_round;
library lib_thirdparty;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use lib_thirdparty.crypt_pack.all;
use lib_round.all;

entity add_roundkey_tb is
end entity;

architecture add_roundkey_tb_arch of add_roundkey_tb is
    signal data_is : state_t;
    signal data_os : state_t;
    signal key_is : state_t;

    component add_roundkey
        port (
            data_i : in state_t;
            key_i  : in state_t;
            en_i   : in std_logic;
            data_o : out state_t);
    end component;

begin

    DUT : add_roundkey port map(
        data_i => data_is,
        key_i  => key_is,
        en_i   => '1',
        data_o => data_os
    );

    PUT : process
    begin
        for i in 0 to 3 loop
            for j in 0 to 3 loop
                data_is(i)(j) <= x"FF";
                key_is(i)(j) <= x"FF";
            end loop;
        end loop;
        wait;
    end process PUT;

end architecture add_roundkey_tb_arch;
configuration add_roundkey_tb_conf of add_roundkey_tb is
    for add_roundkey_tb_arch
        for DUT : add_roundkey
            use entity lib_round.add_roundkey(add_roundkey_arch);
        end for;
    end for;
end configuration;