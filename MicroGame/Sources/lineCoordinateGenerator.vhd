
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity lineCoordinateGenerator is
port(clkIn, genNewLine, resetRand, resetState: in std_logic; lineReady: out std_logic;
xo1, xo2, xo3, xo4, xo5, xo6, xo7, yo1, yo2, yo3, yo4, yo5, yo6, yo7: out integer range 0 to 5);
end lineCoordinateGenerator;

architecture Behavioral of lineCoordinateGenerator is

type grid is array(5 downto 1) of std_logic_vector(5 downto 1);
type state_type is (reset, pickA, pickB, pickC, pickD, pickE, pickF, pickG, assignCoords,  idle);
--fillArray,
component oneToFiveShiftReg is
generic(initState : std_logic_vector(7 downto 0));
port(clk, reset : in std_logic; randOut: out integer range 1 to 5);
end component;


signal x1, x2, x3, x4, x5, x6, x7, y1, y2, y3, y4, y5, y6, y7: integer range 0 to 5; 
signal resetOne: std_logic; 
signal randOne, randTwo, randThree, randFour, randFive, randSix, randSeven: integer range 1 to 5;
signal a,b,c,d,e,f,g: integer range 0 to 5;

 
signal currentState, nextState: state_type; 

function wipeGrid(gridIn: in grid)
return grid is variable output: grid; 
variable temp: grid; 
begin
temp := gridIn;
for I in 1 to 5 loop
    for J in 1 to 5 loop
    temp(I)(J) := '0'; 
    end loop;
end loop;
output := temp; 
return output; 
end wipeGrid; 


begin

R1: oneToFiveShiftReg 
generic map(initState => "11000001")
port map(clk => clkIn, reset => resetRand, randOut => randOne);
R2: oneToFiveShiftReg 
generic map(initState => "00100001")
port map(clk => clkIn, reset => resetRand, randOut => randTwo);
R3: oneToFiveShiftReg 
generic map(initState => "10000011")
port map(clk => clkIn, reset => resetRand, randOut => randThree);
R4: oneToFiveShiftReg 
generic map(initState => "11111000")
port map(clk => clkIn, reset => resetRand, randOut => randFour);
R5: oneToFiveShiftReg 
generic map(initState => "10101011")
port map(clk => clkIn, reset => resetRand, randOut => randFive);
R6: oneToFiveShiftReg 
generic map(initState => "10111100")
port map(clk => clkIn, reset => resetRand, randOut => randSix);
R7: oneToFiveShiftReg 
generic map(initState => "00001000")
port map(clk => clkIn, reset => resetRand, randOut => randSeven);

--   xo1 <= x1;
--   xo2 <= x2;
--   xo3 <= x3;
--   xo4 <= x4;
--   xo5 <= x5;
--   xo6 <= x6;
--   xo7 <= x7;
--   yo1 <= y1;
--   yo2 <= y2;
--   yo3 <= y3;
--   yo4 <= y4;
--   yo5 <= y5;
--   yo6 <= y6;
--   yo7 <= y7;

    xo1 <= a; 
    yo1 <= 1;
    xo2 <= a;
    yo2 <= b;
    xo3 <= c;
    yo3 <= b;
    xo4 <= c;
    yo4 <= d;
    xo5 <= e;
    yo5 <= d;
    xo6 <= e;
    yo6 <= f;
    xo7 <= g;
    yo7 <= f; 

sreg: process(clkIn)
begin
if(resetState = '1') then
currentState <= reset;
elsif(rising_edge(clkIn)) then
currentState <= nextState;
end if; 
end process;

randReg: process(clkIn, randOne, randTwo, randThree, randFour, randFive, randSix, randSeven)
begin 
if(rising_edge(clkIn)) then
if(currentState = reset) then
    a <= 0;
    b <= 0;
    c <= 0;
    d <= 0;
    e <= 0;
    f <= 0;
    g <= 0;
elsif(currentState = pickA) then
    a <= randOne; 
elsif(currentState = pickB) then
    b <= randTwo;
elsif(currentState = pickC) then
    c <= randThree;
elsif(currentState = pickD) then
    d <= randFour; 
elsif(currentState = pickE) then
    e <= randFive; 
elsif(currentState = pickF) then
    f <= randSix; 
elsif(currentState = pickG) then
    g <= randSeven; 
end if;
end if;
end process;

M1: process(currentState, genNewLine, randOne, randTwo, randThree, randFour, randFive, randSix, randSeven) 
begin
case currentState is
when reset =>
    --path <= wipeGrid(path); 
    if(genNewLine = '1') then
    nextState <= pickA; 
    else 
    nextState <= reset;
    end if;
    
    when pickA =>
    if(not(randOne = 0)) then 
    nextState <= pickB; 
    else
    nextState <= pickA;
    end if;
    
    when pickB =>
    if(randTwo = 1) then
    nextState <= pickB;
    else 
    nextState <= pickC;
    end if;
    
    when pickC => 
    if(randThree = a) then 
    nextState <= pickC;
    else
    nextState <= pickD;
    end if;
    
    when pickD =>  
    if(randFour = 1 or randFour = b) then
    nextState <= pickD;
    else
    nextState <= pickE;
    end if;
    
    when pickE =>
    if(randFive = a or randFive = c) then 
    nextState <= pickE;
    else 
    nextState <= pickF;
    end if;
    
    when pickF =>
    if(randSix = d or randSix = b or randSix = 1) then
    nextState <= pickF;
    else
    nextState <= pickG;
    end if;
    
    when pickG => 
    if(randSeven = e or randSeven = c or randSeven = a) then
    nextState <= pickG;
    else
    nextState <= idle;
    end if;    

    when idle =>
    if(genNewLine = '0') then 
    nextState <= idle; 
    else
    nextState <= reset; 
    end if;
    when others => 
    nextState <= reset; 
end case;
end process; 


--type state_type is (reset, pickA, pickB, pickC, pickD, pickE, pickF, pickG, assignCoords, fillArray, idle);
M2: process(currentState)
begin
if(currentState = reset) then
    lineReady <= '0';
elsif(currentState = idle) then
    lineReady <= '1';
else     
    lineReady <= '0';
end if; 
end process;

end Behavioral;
