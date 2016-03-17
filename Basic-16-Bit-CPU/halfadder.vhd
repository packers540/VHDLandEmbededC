library IEEE;
use IEEE.STD_LOGIC_1164.all;

--Two 1 bit inputs, Two 1 bit Outputs

entity halfadder is	
	port (A1, B1: in std_logic;
	CO, SU: out std_logic
	);
end halfadder;

--The logice expressions for half adder

architecture halfadder of halfadder is
begin
	SU <= A1 xor B1;
	CO <= A1 and B1;
	
end halfadder;
