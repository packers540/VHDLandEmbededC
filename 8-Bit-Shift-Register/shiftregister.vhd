library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity shiftregister is
port(
A: in std_logic;
CLK: in std_logic;
F: buffer std_logic_vector (7 downto 0)
);
end shiftregister;

architecture behavioral of shiftregister  is

component d_flip_flop
PORT(D, E: IN STD_LOGIC; Q: OUT STD_LOGIC);
end component;							 

begin
	
-- PUT YOUR CODE HERE


end behavioral;
