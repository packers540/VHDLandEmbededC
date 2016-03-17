library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;

entity InstrMem is	
	port (Adress: in std_logic_vector(7 downto 0);
	Instruction: out std_logic_vector(15 downto 0)
	);
end InstrMem;

architecture InstrMem of InstrMem is

--Memory array 256 memory blocks that are 16 bits wide
subtype elements is std_logic_vector(15 downto 0);
type bit_array is array (0 to 255) of elements;

signal instr_array: bit_array;

begin
	
	--The program we are supposed to be able to run
	instr_array(0) <= x"500A";	 
	instr_array(1) <= x"5105";
	instr_array(2) <= x"5200";	 
	instr_array(3) <= x"5300";
	instr_array(4) <= x"5400";	 
	instr_array(5) <= x"5500";
	instr_array(6) <= x"5600";	 
	instr_array(7) <= x"5700";
	instr_array(8) <= x"0201";	 
	instr_array(9) <= x"1301";
	instr_array(10) <= x"4401";	 
	instr_array(11) <= x"630B";
	instr_array(12) <= x"640A";	 
	instr_array(13) <= x"760A";
	instr_array(14) <= x"770B";	 
	
	--When the address changes the instruction changes
	process(Adress)
	begin
		Instruction <= instr_array(to_integer(unsigned(Adress)));
	end process;

end InstrMem;
