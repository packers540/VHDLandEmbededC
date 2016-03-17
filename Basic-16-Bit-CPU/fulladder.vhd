library IEEE;
use IEEE.STD_LOGIC_1164.all;

--three 1 bit inputs and two 1 bit outputs

entity fulladder is
	port(a, b, cin: in std_logic;
	s, cout: out std_logic
	);
end fulladder;


architecture fulladder of fulladder is

--Declaration of signals

signal s1, c1, c2: std_logic;	

--Declaration of halfadder component

component halfadder
	port(A1, B1: in std_logic;
	CO, SU: out std_logic
	);
end component;

--Port map of entire circuit using two halfadders

begin
	  HA1:halfadder port map(A1 => a, B1 => b, CO => c1, SU => s1); 
	  HA2:halfadder port map(A1 => cin, B1 => s1, CO => c2, SU => s);	 
	  cout <= c2 or c1;
end fulladder;
