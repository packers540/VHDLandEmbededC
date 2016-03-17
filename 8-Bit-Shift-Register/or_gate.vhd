LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY or_gate IS
PORT(A, B: IN STD_LOGIC; C: OUT STD_LOGIC);
END or_gate;

ARCHITECTURE dataflow OF or_gate IS
BEGIN
	C <= A or B after 20 ns;
END dataflow;