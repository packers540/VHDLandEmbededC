LIBRARY IEEE;
use ieee.std_logic_1164.all;

ENTITY jk_flip_flop IS
port(S, R, E: in std_logic; Q, QN : buffer std_logic);
END jk_flip_flop;

architecture structural of jk_flip_flop is

component or_gate
PORT(A, B: IN STD_LOGIC; C: OUT STD_LOGIC);
end component;

component not_gate
PORT(A : IN STD_LOGIC; B: OUT STD_LOGIC);
end component;

component and_gate
PORT(A, B: IN STD_LOGIC; C: OUT STD_LOGIC);
end component;

signal an0, an1, n0, n1 : std_logic;

begin

and0: and_gate port map(R, E, an0);
and1: and_gate port map(S, E, an1);

or0: or_gate port map(an0, QN, n0);
or1: or_gate port map(an1, Q, n1);

not0: not_gate port map(n0, Q);
not1: not_gate port map(n1, QN);

end structural;