library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- DataSel = 00 for ALU, 01 for MemoryOut, 10 Instruction Immediate
entity ControlUnit is 
Port(
instruction: IN std_logic_vector(15 downto 0);
AluSel: OUT std_logic_vector( 2 downto 0 );
RA, RB, RC : OUT std_logic_vector( 3 downto 0 );
RegWrite, MemWrite : OUT std_logic;	   
DataSel : OUT std_logic_vector( 1 downto 0 );
MemVal : OUT std_logic_vector(7 downto 0)
);
end entity;

--   1___3op___4c___4a___4b
--	 15__14____11___7____3_

architecture behavioral of ControlUnit is 
begin
AluSel <= instruction( 14 downto 12 );
MemVal <= instruction( 7 downto 0 );

process(instruction)
begin
	case instruction(14 downto 12) is
		when "000" => -- Signed Addition
			RA <= instruction( 7 downto 4 );
			RB <= instruction( 3 downto 0 );
			RC <= instruction( 11 downto 8 );
			Regwrite <= '1';
			DataSel <= "00"; -- ALU 
			Memwrite <= '0';
		when "001" => -- Signed Multiplication
			RA <= instruction( 7 downto 4 );
			RB <= instruction( 3 downto 0 );
			RC <= instruction( 11 downto 8 );
			Regwrite <= '1'; 
			DataSel <= "00"; -- ALU 
			Memwrite <= '0';
		when "010" => -- Passthrough A
			RA <= instruction( 7 downto 4 );
			RB <= instruction( 3 downto 0 );
			RC <= instruction( 11 downto 8 );
			Regwrite <= '1'; 
			DataSel <= "00"; -- Val1 
			Memwrite <= '0';
		when "011" => -- Passthrough B
			RA <= instruction( 7 downto 4 );
			RB <= instruction( 3 downto 0 );
			RC <= instruction( 11 downto 8 );
			Regwrite <= '1'; 
			DataSel <= "00"; -- Val2 
			Memwrite <= '0';
		when "100" => -- Signed Subtraction
			RA <= instruction( 7 downto 4 );
			RB <= instruction( 3 downto 0 );
			RC <= instruction( 11 downto 8 );
			Regwrite <= '1'; 
			DataSel <= "00"; -- ALU  
			Memwrite <= '0';
		when "101" => -- Load immediate
			RC <= instruction( 11 downto 8 );
			Regwrite <= '1';
			DataSel <= "10"; -- Immediate
			Memwrite <= '0';
		when "110" => -- Store Half Word
			--Only need register C
			RC <= instruction( 11 downto 8 );
			Regwrite <= '0'; 
			Memwrite <= '1';
		when "111" => -- Load Half Word
			--Only need register C
			RC <= instruction( 11 downto 8 );
			Regwrite <= '1'; 
			DataSel <= "01"; -- Memout
			Memwrite <= '0';
		when others =>
			Memwrite <= '0';
			Regwrite <= '0';
		end case;
	
end process;




end architecture;
