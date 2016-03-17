library IEEE;
use IEEE.STD_LOGIC_1164.all;

--Two 16 big inputs, One 1 bit input, One 16 bit output, One 1 bit output

entity addr16bit is
	port(ABV, BBV: in std_logic_vector(15 downto 0);
	ACIN: in std_logic;
	CBV: out std_logic_vector(15 downto 0);
	CBO: out std_logic
	);
end addr16bit;


architecture addr16bit of addr16bit is	

--Declare needed signals

signal RIPC: std_logic_vector(16 downto 0);	 

--Declare needed components

component fulladder
	port (a, b, cin: in std_logic;
	s, cout: out  std_logic
	);
end component;

begin

	--Set initial ripple carry to the the carry in of the circuit
	
	RIPC(0) <= ACIN;
	
	--Ripple carry algorithm
	
	Adder16:
	for i in 0 to 15 generate
		FAx: fulladder port map(ABV(i), BBV(i), RIPC(i), CBV(i), RIPC(i + 1));
	end generate;

	--Set output carry to final ripple carry
	
	CBO <= RIPC(16);

end addr16bit;
