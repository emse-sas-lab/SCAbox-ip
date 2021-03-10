-------------------------------------------------------
--! @author Sami Dahoux (s.dahoux@emse.fr)
--! @file tdc.vhd
--! @brief FIFO acquisition controller to synchronize acquisition with crypto-algorithm
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.math_real.all;

library work;
use work.all;

entity fifo_ctrl is
	generic (
		width_g : positive
	);
	port (
		clock_i : in std_logic;
		reset_i    : in std_logic;
		read_i     : in std_logic;
		write_i    : in std_logic;
		empty_i    : in std_logic;
		full_i     : in std_logic;
		reached_i  : in std_logic;
		write_o    : out std_logic;
		read_o     : out std_logic
	);
end fifo_ctrl;

architecture fifo_ctrl_arch of fifo_ctrl is

	component fifo_fsm is
		generic (
			width_g : positive
		);
		port (
			clock_i   : in std_logic;
			reset_i   : in std_logic;
			read_i    : in std_logic;
			write_i   : in std_logic;
			empty_i   : in std_logic;
			full_i    : in std_logic;
			reached_i : in std_logic;
			write_o   : out std_logic;
			read_o    : out std_logic
		);
	end component;

begin
	fsm : fifo_fsm
	generic map(
		width_g => width_g
	)
	port map(
		clock_i   => clock_i,
		reset_i   => reset_i,
		read_i    => read_i,
		write_i   => write_i,
		empty_i   => empty_i,
		full_i    => full_i,
		reached_i => reached_i,
		write_o   => write_o,
		read_o    => read_o
	);

end fifo_ctrl_arch; -- fifo_ctrl_arch

configuration fifo_ctrl_conf of fifo_ctrl is
	for fifo_ctrl_arch
		for all : fifo_fsm
			use entity work.fifo_fsm(fifo_fsm_arch);
		end for;
	end for;
end configuration;