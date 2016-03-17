LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY Milestone3 IS

PORT ( SW0, SW1 : IN STD_LOGIC ;  			-- Switches SW0 and SW1
		PB0, PB1 : IN STD_LOGIC ;				-- Push Buttons KEY0 and KEY1
		LEDR0: OUT STD_LOGIC ;					-- Task1 LED output (Red LEDR0)
		LEDG0, LEDG1, LEDG2, LEDG3, LEDG4, LEDG5, LEDG6, LEDG7 : out std_logic ;			--Task2 LED output (Green LEDG0-7)
		HEX4 : out std_logic_vector(0 to 6);				--Pin values for 7 segment HEX4
		HEX5 : out std_logic_vector(0 to 6) );			--Pin values for 7 segment HEX5
END Milestone3 ;

Architecture Task1 of Milestone3 is 


begin
	LEDR0 <= SW0 AND SW1;
	
process (PB0, PB1)
	variable Count : std_logic_vector (7 downto 0):= "00000000";
	variable Count1 : std_logic_vector (3 downto 0):= "0000";
	variable Count2 : std_logic_vector (3 downto 0):= "0000";
	
	
begin
	if (PB0'Event and PB0 = '1') then
		Count := Count + '1';
	end if;

LEDG0 <= Count(0);
LEDG1 <= Count(1);
LEDG2 <= Count(2);
LEDG3 <= Count(3);
LEDG4 <= Count(4);
LEDG5 <= Count(5);
LEDG6 <= Count(6);
LEDG7 <= Count(7);

	if (PB1'Event and PB1 = '1') then
		Count1 := Count1 + '1';
			if Count1 = "1010" then
				Count1 := "0000";
				Count2 := Count2 + '1';
				if Count2 = "1010" then
					Count2 := "0000";
				end if;
			end if;		
	end if;

	case Count1 is
		when "0000" => HEX4 <= "0000001";     --0
		when "0001" => HEX4 <= "1001111";     --1
		when "0010" => HEX4 <= "0010010";     --2
		when "0011" => HEX4 <= "0000110";     --3
		when "0100" => HEX4 <= "1001100";     --4
		when "0101" => HEX4 <= "0100100";     --5
		when "0110" => HEX4 <= "0100000";     --6
		when "0111" => HEX4 <= "0001101";     --7
		when "1000" => HEX4 <= "0000000";     --8
		when others => HEX4 <= "0000100";     --9


	end case;
	
	case Count2 is
		when "0000" => HEX5 <= "0000001";     --0
		when "0001" => HEX5 <= "1001111";     --1
		when "0010" => HEX5 <= "0010010";     --2
		when "0011" => HEX5 <= "0000110";     --3
		when "0100" => HEX5 <= "1001100";     --4
		when "0101" => HEX5 <= "0100100";     --5
		when "0110" => HEX5 <= "0100000";     --6
		when "0111" => HEX5 <= "0001101";     --7
		when "1000" => HEX5 <= "0000000";     --8
		when others => HEX5 <= "0000100";     --9

	end case;
	
	
end process;

	
end task1; 
