
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity oneToFiveShiftReg is
generic(initState : std_logic_vector(7 downto 0) := "11111111");
Port(clk, reset: in std_logic; randOut: out integer range 1 to 5);
end oneToFiveShiftReg;


architecture Behavioral of oneToFiveShiftReg is

function randToZeroToFive(randIn : in std_logic_vector(7 downto 0))
return integer is variable assignment: integer range 1 to 5;
begin
if(randIn <= "00110011") then 
assignment := 1;
elsif(randIn <= "01100110") then 
assignment := 2;
elsif(randIn <= "10011001") then 
assignment := 3; 
elsif(randIn <= "11001100") then 
assignment := 4;
elsif(randIn <= "11111111") then
assignment := 5;
end if;
return assignment; 
end;

signal Q_temp : std_logic_vector(7 downto 0);

begin
process(clk, reset)
begin
if(reset = '1') then 
Q_temp <= initState;
elsif(rising_edge(clk)) then 
Q_temp <= Q_temp(6 downto 0) & '0';
Q_temp(0) <= Q_temp(1) xor Q_temp(2) xor Q_temp(3) xor Q_temp(7);
end if;
end process; 
randOut <= randToZeroToFive(Q_temp); 
end Behavioral;
