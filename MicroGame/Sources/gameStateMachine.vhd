
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gameStateMachine is
Port(clkIn: in std_logic; lftBtn, linkCon: in std_logic; reset, linkSplashEn: out std_logic; resetRandLogic: out std_logic);
end gameStateMachine;

architecture Behavioral of gameStateMachine is
type state_type is (resetStateMachine, hold, active, link, loss);
signal nextState, currentState : state_type;
signal count : integer range 0 to 500000000 := 0;
signal countEn, countReset: std_logic; 

begin
sreg: process(clkIn)
begin
if(rising_edge(clkIn)) then
if(currentState = nextState) then
currentState <= nextState;
countReset <= '0';
else
countReset <= '1';
currentState <= nextState;
end if;
end if; 
end process;

counter: process(countReset, clkIn) 
begin
if(countReset = '1') then
count <= 0;
elsif(rising_edge(clkIn)) then
count <= count + 1;
end if;

end process;

M1: process(currentState, lftBtn, count) 
begin
case currentState is
when resetStateMachine =>
    if(count >= 50000) then
    nextState <= hold;
    else 
    nextState <= resetStateMachine;
    end if;
when hold => 
    if(lftBtn = '1') then
    nextState <= active; 
    else
    nextState <= hold;
    end if;
when active => 
    if(count = 500000000) then
    nextState <= loss; 
    elsif(linkCon = '1') then
    nextState <= link;
    else 
    nextState <= active;
    end if;
when link =>
    if(count >= 200000000) then
    nextState <= resetStateMachine;
    else 
    nextState <= link;
    end if;
when loss =>
    if(count >= 50000000) then
    nextState <= resetStateMachine; 
    else
    nextState <= loss;
    end if;
when others =>
nextState <= resetStateMachine;

end case;
end process; 


--type state_type is (reset, pickA, pickB, pickC, pickD, pickE, pickF, pickG, assignCoords, fillArray, idle);
M2: process(currentState)
begin
if(currentState = resetStateMachine) then
reset <= '1';
resetRandLogic <= '1';
linkSplashEn <= '0';
elsif(currentState = link) then
linkSplashEn <= '1'; 
reset <= '1';
resetRandLogic <= '0';
else 
resetRandLogic <= '0';
reset <= '0';
linkSplashEn <= '0'; 
end if;
end process;
end Behavioral;
