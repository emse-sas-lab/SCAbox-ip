-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file aes_round_tb.vhd
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_UNSIGNED.all;

library lib_thirdparty;
use lib_thirdparty.crypt_pack.all;
use lib_thirdparty.test_pack.all;

library lib_rtl;
use lib_rtl.all;
entity aes_round_tb is
end aes_round_tb;

architecture aes_round_tb_arch of aes_round_tb is

    component aes_round
        port (
            data_i          : in bit128;
            key_i           : in bit128;
            en_mixcolumns_i : in std_logic;
            en_round_i      : in std_logic;
            inv_i           : in std_logic;
            data_o          : out bit128
        );
    end component;

    signal data_is, data_os, data_es, key_s : bit128;
    signal en_round_s, en_mixcolumns_s : std_logic;
    signal cond_s : boolean;
    signal inv_s : std_logic := '0';
begin

    DUT : aes_round
    port map(
        data_i          => data_is,
        key_i           => key_s,
        en_mixcolumns_i => en_mixcolumns_s,
        en_round_i      => en_round_s,
        inv_i           => inv_s,
        data_o          => data_os
    );
    PUT : process
        variable k_inv_v : integer range 0 to 10;
        variable data_iv, data_ev, data_inv_iv, data_inv_ev : bit128;
    begin
        round : for k in 0 to 10 loop
            k_inv_v := 10 - k;

            if k = 0 then
                en_round_s <= '0';
                en_mixcolumns_s <= '0';
            elsif k = 10 then
                en_mixcolumns_s <= '0';
            else
                en_round_s <= '1';
                en_mixcolumns_s <= '1';
            end if;

            if inv_s = '0' then
                data_is <= std_rounddata_c(k);
                key_s <= std_roundkey_c(k);
                data_es <= std_rounddata_c(k + 1);
            else
                data_is <= std_rounddata_inv_c(k);
                key_s <= std_roundkey_inv_c(k);
                data_es <= std_rounddata_inv_c(k + 1);
            end if;
            assert cond_s report "output differs from expected output" severity error;
            wait for 100 ns;
        end loop; -- round

        wait for 300 ns;
        inv_s <= not inv_s;
    end process PUT;

    cond_s <= data_es = data_os;

end aes_round_tb_arch; -- aes_round_tb_arch

configuration aes_round_tb_conf of aes_round_tb is
    for aes_round_tb_arch
        for DUT : aes_round
            use configuration lib_rtl.aes_round_conf;
        end for;
    end for;
end configuration aes_round_tb_conf;