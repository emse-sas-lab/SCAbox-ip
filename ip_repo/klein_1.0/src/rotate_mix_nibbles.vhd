library ieee;
use ieee.std_logic_1164.all;

entity rotate_mix_nibbles is
    port(data_in:  in std_logic_vector(63 downto 0);
         data_out: out std_logic_vector(63 downto 0)
    );
end entity;

architecture structual of rotate_mix_nibbles is
    signal rotated: std_logic_vector(63 downto 0);
    signal mix_mul_in,
           mix_mul_out: std_logic_vector(63 downto 0);

    component mul_poly
        port(data_in:  in std_logic_vector(7 downto 0);
             data_out: out std_logic_vector(7 downto 0)
        );
    end component;
begin
    rotated <= data_in(47 downto 0) & data_in(63 downto 48);

    -- MixNibbles algorithm inspired from
    -- https://link.springer.com/chapter/10.1007/978-3-642-25578-6_11
    mix_mul_in(63 downto 56) <= rotated(63 downto 56) xor rotated(55 downto 48);
    mix_mul_in(55 downto 48) <= rotated(55 downto 48) xor rotated(47 downto 40);
    mix_mul_in(47 downto 40) <= rotated(47 downto 40) xor rotated(39 downto 32);
    mix_mul_in(39 downto 32) <= rotated(39 downto 32) xor rotated(63 downto 56);

    mix_mul_in(31 downto 24) <= rotated(31 downto 24) xor rotated(23 downto 16);
    mix_mul_in(23 downto 16) <= rotated(23 downto 16) xor rotated(15 downto 8);
    mix_mul_in(15 downto 8)  <= rotated(15 downto 8)  xor rotated(7 downto 0);
    mix_mul_in(7 downto 0)   <= rotated(7 downto 0)   xor rotated(31 downto 24);

    MUL: for i in 0 to 7 generate
        MX: mul_poly port map(
            data_in => mix_mul_in(63-(8*i) downto 63-(8*i)-7),
            data_out => mix_mul_out(63-(8*i) downto 63-(8*i)-7)
        );
    end generate;

    data_out(63 downto 56) <= mix_mul_out(63 downto 56) xor
                              mix_mul_in(55 downto 48) xor
                              rotated(39 downto 32);
    data_out(55 downto 48) <= mix_mul_out(55 downto 48) xor
                              mix_mul_in(47 downto 40) xor
                              rotated(63 downto 56);
    data_out(47 downto 40) <= mix_mul_out(47 downto 40) xor
                              mix_mul_in(63 downto 56) xor
                              rotated(39 downto 32);
    data_out(39 downto 32) <= mix_mul_out(39 downto 32) xor
                              mix_mul_in(63 downto 56) xor
                              rotated(47 downto 40);

    data_out(31 downto 24) <= mix_mul_out(31 downto 24) xor
                              mix_mul_in(23 downto 16) xor
                              rotated(7 downto 0);
    data_out(23 downto 16) <= mix_mul_out(23 downto 16) xor
                              mix_mul_in(15 downto 8) xor
                              rotated(31 downto 24);
    data_out(15 downto 8)  <= mix_mul_out(15 downto 8) xor
                              mix_mul_in(31 downto 24) xor
                              rotated(7 downto 0);
    data_out(7 downto 0)   <= mix_mul_out(7 downto 0) xor
                              mix_mul_in(31 downto 24) xor
                              rotated(15 downto 8);
end architecture;
