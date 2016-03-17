LIBRARY IEEE;
use ieee.std_logic_1164.all;

ENTITY d_flip_flop IS
PORT(D, E: IN STD_LOGIC; Q: OUT STD_LOGIC);
END d_flip_flop;

ARCHITECTURE structural OF d_flip_flop IS

COMPONENT jk_flip_flop 
port(S, R, E: in std_logic; Q, QN : buffer std_logic);
END COMPONENT;

component not_gate
PORT(A : IN STD_LOGIC; B: OUT STD_LOGIC);
end component;

SIGNAL DN: std_logic;

BEGIN

not0: not_gate port map(D, DN);

jk0: jk_flip_flop port map(D, DN, E, Q, OPEN);

END structural;