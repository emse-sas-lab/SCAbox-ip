library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.util.all;

entity klein_top is
    generic(k: natural := 64);
    port(plaintext:  in std_logic_vector(63 downto 0);
         key:        in std_logic_vector(k-1 downto 0);
         clk:        in std_logic;
         reset:      in std_logic;
         ciphertext: out std_logic_vector(63 downto 0)
    );
end klein_top;

architecture behavioral of klein_top is
    signal data_state,
           data_key_added,
           data_nibbles_subbed,
           data_nibbles_mixed: std_logic_vector(63 downto 0);
    signal key_state,
           key_updated: std_logic_vector(k-1 downto 0);
    signal round_counter: std_logic_vector(4 downto 0);
    signal k_i: natural;

    component sub_nibbles
        port(data_in:  in std_logic_vector(63 downto 0);
             data_out: out std_logic_vector(63 downto 0)
        );
    end component;

    component rotate_mix_nibbles
        port(data_in:  in std_logic_vector(63 downto 0);
             data_out: out std_logic_vector(63 downto 0)
        );
    end component;

    component key_schedule
        generic(k: natural := 64);
        port(data_in:  in std_logic_vector(k-1 downto 0);
             rc:       in std_logic_vector(4 downto 0);
             data_out: out std_logic_vector(k-1 downto 0)
        );
    end component;
begin
      
    SN: sub_nibbles port map(
        data_in => data_key_added,
        data_out => data_nibbles_subbed
    );

    RMN: rotate_mix_nibbles port map(
        data_in => data_nibbles_subbed,
        data_out => data_nibbles_mixed
    );

    KS: key_schedule generic map(
        k => k
    ) port map(
        data_in => key_state,
        rc => round_counter,
        data_out => key_updated
    );

    data_key_added <= data_state xor key_state(k-1 downto k-64);

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                data_state <= plaintext;
                key_state <= key;
                round_counter <= "00001";
                ciphertext <= (others => '0');
            else
                data_state <= data_nibbles_mixed;
                key_state <= key_updated;
                round_counter <= std_logic_vector(unsigned(round_counter) + 1);

                case round_counter is
                    
                    when final_rc(k) => ciphertext <= data_key_added;
                    when others => ciphertext <= (others => '0');
                end case;
            end if;
        end if;
    end process;
end architecture;
