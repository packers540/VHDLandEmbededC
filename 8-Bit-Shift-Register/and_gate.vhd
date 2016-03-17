LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY and_gate IS
PORT(A, B: IN STD_LOGIC; C: OUT STD_LOGIC);
END and_gate;

ARCHITECTURE dataflow OF And_Gate IS
BEGIN
	C <= A and B after 20 ns;
END dataflow;