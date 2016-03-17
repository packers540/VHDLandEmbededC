LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY not_gate IS
PORT(A : IN STD_LOGIC; B: OUT STD_LOGIC);
END not_gate;

ARCHITECTURE dataflow OF not_gate IS
BEGIN
	B <= not A after 20 ns;
END dataflow;