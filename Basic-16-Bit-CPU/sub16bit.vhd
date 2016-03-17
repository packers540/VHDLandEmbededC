--CBV = SABV - SBBV
--SCB = Carry bit

library IEEE;
use IEEE.STD_LOGIC_1164.all;

--Two 16 bit inputs, One 1 bit input, One 16 bit output, One 1 bit output

entity bit16sub is 
	port(SABV, SBBV: in std_logic_vector(15 downto 0);
	SCIN: in std_logic;
	SSBV : out std_logic_vector(15 downto 0);
	SCB: out std_logic
	);
end bit16sub;


architecture bit16sub of bit16sub is	

--Declare signals

signal test: std_logic_vector(15 downto 0);	  
signal twos: std_logic_vector(15 downto 0);
signal useless: std_logic;

--Declared needed compnoents

component addr16bit
	port(ABV, BBV: in std_logic_vector(15 downto 0);
	ACIN: in std_logic;
	CBV: out std_logic_vector(15 downto 0);
	CBO: out std_logic
	);
end component;

begin
	
	--Take the two's compliment of the second input so you can add the vaules
	
	twos <= not SBBV;
	
	twocomp: addr16bit port map (twos, "0000000000000001", SCIN, test, useless);	
	
	--Add the values
	
	sub: addr16bit port map (test, SABV, SCIN, SSBV, SCB);
	
	

end bit16sub;
