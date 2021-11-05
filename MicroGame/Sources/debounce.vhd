--Name: Collin Barnhardt
--Project: 1
--Desc: Heavily inspired by reference code posted to digikey by Scott Larson 
-- at https://www.digikey.com/eewiki/pages/viewpage.action?pageId=4980758#DebounceLogicCircuit(withVHDLexample)-CodeDownloads
-- 'inverts' the logic of the example. The counter idea remains, that's the best part.  

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity debounce is
generic(clkSpeed : integer:= 100000000; onTime: integer := 10; tUnits: integer := 1000); --config debouncer
port(debounceClk, btnIn: in STD_LOGIC; btnOut: out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
signal ff: STD_LOGIC_VECTOR(2 downto 0);
signal trig: STD_LOGIC;

begin
process(debounceClk, ff, btnIn)
variable cnt : integer range 0 to ((clkSpeed * onTime) / tUnits);
begin
--Counter on or off 
if((ff = "000" and btnIn = '0') or (ff = "111" and btnIn = '1')) then
trig <= '1';
else
trig <= '0';
end if;

if(rising_edge(debounceClk)) then
         ff(0) <= btnIn; --move data through FF chain when rising edge clock
         ff(1) <= ff(0);
         ff(2) <= ff(1);
     if(trig = '1') then --if counter enabled count 
         if(cnt = ((clkSpeed * onTime) / tUnits)) then --unless at the desired debounce time
            btnOut <= ff(2); 
         else
            cnt := cnt + 1;
         end if;
     else 
        cnt := 0;
     end if;
end if;
end process;
end Behavioral;
