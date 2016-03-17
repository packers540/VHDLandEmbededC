library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;

entity DataMem is	
	port (Adress: in std_logic_vector(7 downto 0);
	Write: in std_logic;
	Value: in std_logic_vector(15 downto 0);
	Out_Data: out std_logic_vector(15 downto 0)
	);
end DataMem;

architecture DataMem of DataMem is

--Data Memory array 256 entries each 16 bits wide
subtype elements is std_logic_vector(15 downto 0);
type bit_array is array (0 to 255) of elements;

signal mem_array: bit_array;

begin
	
	process(Adress, Write, Value)
	begin
		--If write 1 insert value at provided address
		if (Write = '1') then
			mem_array(to_integer(unsigned(Adress))) <= Value;
		else   
			--If write 0 then output value at given address
		  	Out_Data <= mem_array(to_integer(unsigned(Adress)));
		end if;
	end process;
end DataMem;
