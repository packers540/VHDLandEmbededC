library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ALU is
	port (ALUA, ALUB: in std_logic_vector(15 downto 0);
	S0, S1, S2: in std_logic;
	ALUR: out std_logic_vector(15 downto 0);
	Status: out std_logic_vector(2 downto 0)
	);
end ALU;


architecture ALU of ALU is 
component addr16bit
	port(ABV, BBV: in std_logic_vector(15 downto 0);
	ACIN: in std_logic;
	CBV: out std_logic_vector(15 downto 0);
	CBO: out std_logic
	);
end component;

signal DONTCARE, SUBRes, ADDRes, MULTRes: std_logic_vector(15 downto 0);
signal ADDCO, SUBCO, MULTCO, MULTNEG, ARESZero, SRESZero, MRESZero: std_logic;   
signal selector: std_logic_vector(3 downto 0);

component bit16sub
	port(SABV, SBBV: in std_logic_vector(15 downto 0);
	SCIN: in std_logic;
	SSBV : out std_logic_vector(15 downto 0);
	SCB: out std_logic
	); 
end component;

component mult16bit
	port(MABV, MBBV: in std_logic_vector(15 downto 0);
	MPBV: inout std_logic_vector(15 downto 0);
	Overflow: out std_logic;
	Negative: out std_logic
	);
end component;

component mulplx16bit
	port(M0, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12, M13, M14, M15: in std_logic_vector(15 downto 0);
	S0: in std_logic_vector(3 downto 0);
	MOUT: out std_logic_vector(15 downto 0)
	);
end component;

begin


selector <= '0'&S0&S1&S2;
	
ADD:addr16bit port map(ALUA, ALUB, '0', ADDRes, ADDCO);	
SUB:bit16sub port map (ALUA, ALUB, '0', SUBRes, SUBCO);
MULT: mult16bit port map (ALUA, ALUB, MULTRes, MULTCO, MULTNEG);

MUXRES: mulplx16bit port map (M0 => ADDRes, M1 => MULTRes, M2 => ALUA, M3 => ALUB, M4 => SUBRes, M5 => DONTCARE, M6 => DONTCARE, M7 => DONtCARE, M8 => DONtCARE, M9 => DONtCARE, M10 => DONtCARE, M11 => DONtCARE, M12 => DONtCARE, M13 => DONtCARE, M14 => DONtCARE, M15 => DONtCARE, S0 => selector, MOUT => ALUR);

ARESZero <= (not ADDRes(0)) and (not ADDRes(1)) and (not ADDRes(2)) and (not ADDRes(3)) and (not ADDRes(4)) and (not ADDRes(5)) and (not ADDRes(6)) and (not ADDRes(7)) and (not ADDRes(8)) and (not ADDRes(9)) and (not ADDRes(10)) and (not ADDRes(11)) and (not ADDRes(12)) and (not ADDRes(13)) and (not ADDRes(14)) and (not ADDRes(15));
SRESZero <= (not SUBRes(0)) and (not SUBRes(1)) and (not SUBRes(2)) and (not SUBRes(3)) and (not SUBRes(4)) and (not SUBRes(5)) and (not SUBRes(6)) and (not SUBRes(7)) and (not SUBRes(8)) and (not SUBRes(9)) and (not SUBRes(10)) and (not SUBRes(11)) and (not SUBRes(12)) and (not SUBRes(13)) and (not SUBRes(14)) and (not SUBRes(15));
MRESZero <= (not MULTRes(0)) and (not MULTRes(1)) and (not MULTRes(2)) and (not MULTRes(3)) and (not MULTRes(4)) and (not MULTRes(5)) and (not MULTRes(6)) and (not MULTRes(7)) and (not MULTRes(8)) and (not MULTRes(9)) and (not MULTRes(10)) and (not MULTRes(11)) and (not MULTRes(12)) and (not MULTRes(13)) and (not MULTRes(14)) and (not MULTRes(15));

Status(0) <= ((not S0) and (not S1) and (S2) and MULTNEG)  or '0';
Status(1) <= ((not S0) and (not S1) and (not S2) and ARESZero) or ((not S0) and (not S1) and (S2) and MRESZero) or ((S0) and (not S1) and (not S2) and SRESZero) or '0';
Status(2) <= ((not S0) and (not S1) and (not S2) and ADDCO) or ((not S0) and (not S1) and (S2) and MULTCO) or ((S0) and (not S1) and (not S2) and SUBCO) or '0';

end ALU;
