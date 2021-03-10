entity fifo_ctrl_tb is
end fifo_ctrl_tb;

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

architecture fifo_ctrl_tb_arch of fifo_ctrl_tb is

    constant width_c : positive := 4;

    signal read_is : std_logic := '0';
    signal write_is : std_logic := '0';
    signal reset_is : std_logic := '1';

    signal read_os : std_logic;
    signal write_os : std_logic;
    signal reset_os : std_logic;

    signal clock_rd_s : std_logic := '0';
    signal clock_wr_s : std_logic := '0';
    signal full_s : std_logic := '0';
    signal empty_s : std_logic := '1';
    signal count_is : std_logic_vector(width_c - 1 downto 0) := "0010";
    signal count_os : std_logic_vector(width_c - 1 downto 0);

begin
    clock_rd_s <= not clock_rd_s after 10 ns;
    clock_wr_s <= not clock_wr_s after 2.5 ns;

    DUT : entity work.fifo_ctrl(fifo_ctrl_arch)
        generic map(
            width_g => width_c
        )
        port map(
            clock_rd_i => clock_rd_s,
            clock_wr_i => clock_wr_s,
            reset_i    => reset_is,
            read_i     => read_is,
            write_i    => write_is,
            empty_i    => empty_s,
            full_i     => full_s,
            count_i    => count_is,
            write_o    => write_os,
            read_o     => read_os,
            reset_o    => reset_os,
            count_o    => count_os
        );

    PUT : process
    begin
        count_is <= "0100";
        reset_is <= '1';
        wait for 390 ns;
        reset_is <= '0';

        wait for 300 ns;
        write_is <= '1';
        wait for 200 ns;
        write_is <= '0';
        wait for 400 ns;
        


        wait for 300 ns;
        write_is <= '1';
        wait for 400 ns;
        write_is <= '0';
        wait for 400 ns;
        
        full_s <= '1';
        empty_s <= '0';

        wait for 200 ns;
        count_is <= "0000";

        wait for 200 ns;
        read_is <= '1';
        wait for 800 ns;
        read_is <= '0';

        full_s <= '0';

        wait for 800 ns;
        read_is <= '1';
        wait for 800 ns;
        read_is <= '0';

        wait for 800 ns;
        read_is <= '1';
        wait for 800 ns;
        read_is <= '0';

        wait for 800 ns;
        read_is <= '1';
        wait for 800 ns;
        read_is <= '0';

        empty_s <= '1';

        wait for 800 ns;
        read_is <= '1';
        wait for 800 ns;
        read_is <= '0';

        wait for 800 ns;

    end process; -- PUT

end fifo_ctrl_tb_arch; -- fifo_ctrl_tb_arch