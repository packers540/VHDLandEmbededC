library IEEE;
use IEEE.STD_LOGIC_1164.all;	 
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--Two 16 bit inputs, One 16 bit output, Two 1 bit outputs

entity mult16bit is	
	port(MABV, MBBV: in std_logic_vector(15 downto 0);
	MPBV: inout std_logic_vector(15 downto 0);
	Overflow: out std_logic;
	Negative: out std_logic
	);
end mult16bit;


architecture mult16bit of mult16bit is	

--Create an array of std_logic_vectors

subtype elements is std_logic_vector(15 downto 0);
type bit_array is array (0 to 16) of elements;

--Declare signals

signal copyvector, output, bringdown: bit_array;
signal copy, RIPMC: std_logic_vector(16 downto 0); 	
signal temp, temp2, temp3, temp4, temp5: std_logic_vector(15 downto 0);	 

--Define needed components

component addr16bit
	port(ABV, BBV: in std_logic_vector(15 downto 0);
	ACIN: in std_logic;
	CBV: out std_logic_vector(15 downto 0);
	CBO: out std_logic
	); 
end component;

begin
	--Check for negative numbers if neg number takes 2's comp...
	
		--NEGATIVE CHECK FOR MABV
		
	temp <= not MABV; 
	add1: addr16bit port map(temp , "0000000000000001", '0', temp3);  
	
	copyvector(0) <= (temp3 and MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)) 
			or (MABV and not(MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)&MABV(15)));
		
		--NEGATIVE CHECK FOR MBBV
			
	temp2 <= not MBBV; 
	add2: addr16bit port map(temp2 , "0000000000000001", '0', temp4);  
	
	temp5 <= (temp4 and MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)) 
			or (MBBV and not(MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)&MBBV(15)));
	
			
		--SET NEGATIVE OUTPUT
			
	Negative <= MABV(15) xor MBBV(15);
		
	--Initial Values for generate statement
		
	output(0) <= "0000000000000000"; 
	RIPMC(0) <= '0';	
	
	--Shift and add multiplication algorithm
	
	Multi16:
	for i in 0 to 15 generate	
		
		copy(i) <= '1' and temp5(i);	  
		bringdown(i) <=  copyvector(i) and (copy(i)&copy(i)&copy(i)&copy(i)&copy(i)&copy(i)&copy(i)&copy(i)&copy(i)&copy(i)&copy(i)&copy(i)&copy(i)&copy(i)&copy(i)&copy(i));
		M16x: addr16bit port map(output(i) , bringdown(i), RIPMC(i), output(i+1), RIPMC(i+1));
		
		copyvector(i + 1) <= to_stdlogicvector(to_bitvector(copyvector(i)) sll 1);
		
	end generate;

	--Set output to final values of arrays.
	
	MPBV <= output(16);
	
	--Check for overflow ?????????
	
	
		
	Overflow <= RIPMC(16) or RIPMC(15) or RIPMC(14) or RIPMC(13) or RIPMC(12) or RIPMC(11) or RIPMC(10) or RIPMC(9) or RIPMC(8) or RIPMC(7) or RIPMC(6) or RIPMC(5) or RIPMC(4) or RIPMC(3) or RIPMC(3) or RIPMC(2) or RIPMC(1);
			  --
end mult16bit;
