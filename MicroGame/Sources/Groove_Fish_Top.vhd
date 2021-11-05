
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Groove_Fish_Top is
Port(clk_100MHz, reset, btnU, btnD, btnL, btnR: in STD_LOGIC; 
     HSYNC,VSYNC,locked : out STD_LOGIC;
     RED,GREEN,BLUE : out STD_LOGIC_VECTOR(3 downto 0));
end Groove_Fish_Top;


architecture Behavioral of Groove_Fish_Top is
-- --------------------------------------------------------------------
component debounce 
generic(clkSpeed: integer; onTime: integer; tUnits: integer);
port(debounceClk, btnIn: in std_logic; btnOut: out std_logic );
end component;

component blk_mem_gen_0
port(clka : IN STD_LOGIC; addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0); douta : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
end component; 

component blk_mem_gen_1 
port(clka : in std_logic; addra : in std_logic_vector(12 downto 0); douta: out std_logic_vector(11 downto 0));
end component; 

component blk_mem_gen_2 
port(clka : in std_logic; addra: in std_logic_vector(12 downto 0); douta: out std_logic_vector(11 downto 0));
end component;

component blk_mem_gen_5
port(clka: in std_logic; addra: in std_logic_vector(16 downto 0); douta: out std_logic_vector(11 downto 0));
end component;

component backGroundDecoder
port(dataIn: in std_logic_vector(1 downto 0); backGroundOut: out std_logic_vector(11 downto 0));
end component;

component blk_mem_gen_4 
port(clka: in std_logic; addra: in std_logic_vector(9 downto 0); douta: out std_logic_vector(11 downto 0));
end component;

component clk_wiz_0
port(clk_in1,reset : in std_logic; clk_out1,locked : out std_logic);
end component;

component VGA_controller_640_60 is
port(rst,pixel_clk : in std_logic; HS,VS,blank : out std_logic;
     hcount,vcount : out std_logic_vector(10 downto 0));
end component;

component Draw_Priority_Control is
port(backData, fishData, linkData, herbData, boltData, lineData: in std_logic_vector(11 downto 0); 
enBackGround, enFish, enLink, enHerb, enBolt, enLine, clk : in std_logic; 
Red, Green, Blue: out std_logic_vector(3 downto 0));
end component; 

component lineCoordinateGenerator is 
port(clkIn, genNewLine, resetRand, resetState: in std_logic; lineReady: out std_logic; 
xo1, xo2, xo3, xo4, xo5, xo6, xo7, yo1, yo2, yo3, yo4, yo5, yo6, yo7: out integer range 0 to 5);
end component; 

component vertToLines is
generic(row1: integer := 398; 
rowSpacing: integer := 44; 
col1 : integer := 429; 
colSpacing: integer := 42);
Port(clk, lineReady: in std_logic; x1,x2,x3,x4,x5,x6,x7,y1,y2,y3,y4,y5,y6,y7: in integer range 0 to 5;
hcount, vcount :in std_logic_vector(10 downto 0); en: out std_logic; color: out std_logic_vector(11 downto 0);
xc1, xc2, xc3, xc4, xc5, xc6, xc7, yc1, yc2, yc3, yc4, yc5, yc6, yc7 : out integer range 0 to 640);
end component;

--component animaniacsTesteroonies is
--Port(clkIn: in std_logic; movingOffSetX, movingOffSetY: out std_logic_vector(9 downto 0));
--end component;
--spriteOffSetX: integer;
--spriteOffSetY: integer;

component boltControl is
generic(rateDefault: integer := 1000000);
port(up, down, left, right, clkIn, reset: in std_logic;
x1, x2, x3, x4, x5, x6, x7, y1, y2, y3, y4, y5, y6, y7: in integer range 0 to 640; 
 xLocation, yLocation: out std_logic_vector(9 downto 0); linked: out std_logic);
end component; 

component gameStateMachine is
port(clkIn: in std_logic; lftBtn, linkCon: in std_logic; reset, linkSplashEn: out std_logic; resetRandLogic: out std_logic);
end component; 

component Sprite_Control_Device is
generic(spriteWidth: integer;
        spriteHeight: integer;
        keyColor: std_logic_vector(11 downto 0));
Port(hcount,vcount : in STD_LOGIC_VECTOR(10 downto 0); blank, pix_clk : in STD_LOGIC;
     spriteOffSetX, spriteOffSetY: in std_logic_vector(9 downto 0);
     fromMem: in STD_LOGIC_VECTOR(11 downto 0); 
     memAddr: out STD_LOGIC_VECTOR(18 downto 0);
     imageDataOut: out std_logic_vector(11 downto 0);
     en: out std_logic);
end component;

signal resetLines, linkSplashEn, resetRandLogic, linkCon: std_logic; 
signal linkAND: std_logic;
signal lightAND: std_logic; 

signal clk_25MHz, blank, backGroundEn, fishEn, linkEn, lightEn, boltEn: STD_LOGIC;
signal hcount,vcount :     STD_LOGIC_VECTOR(10 downto 0);
signal ROMDataBackground : STD_LOGIC_VECTOR(11 downto 0);
signal ROMDataFishSprite : std_logic_vector(11 downto 0);
signal ROMDataLinkSplash : std_logic_vector(11 downto 0); 
signal ROMDataLight: std_logic_vector(11 downto 0);
signal ROMDataBolt: std_logic_vector(11 downto 0);
signal indexedDataFish: std_logic_vector(11 downto 0);
signal indexedDataBackGround: std_logic_vector(11 downto 0);
signal indexedDataLink:       std_logic_vector(11 downto 0); 
signal indexedDataBolt:       std_logic_vector(11 downto 0);
signal indexedDataLight:       std_logic_vector(11 downto 0); 
signal memAddrBackground : STD_LOGIC_VECTOR(18 downto 0);
signal memAddrFishSprite : STD_LOGIC_VECTOR(18 downto 0);
signal memAddrLinkSplash : std_logic_vector(18 downto 0);
signal memAddrBolt       : std_logic_vector(18 downto 0);
signal memAddrLight       : std_logic_vector(18 downto 0);
signal encodedBackground : std_logic_vector(1 downto 0);
signal animatedOffSetX   : std_logic_vector(9 downto 0);
signal animatedOffSetY   : std_logic_vector(9 downto 0);
--signal resetState, 
signal lineReady: std_logic; 
signal xo1, xo2, xo3, xo4, xo5, xo6, xo7, yo1, yo2, yo3, yo4, yo5, yo6, yo7: integer range 0 to 5; 
signal xc1, xc2, xc3, xc4, xc5, xc6, xc7, yc1, yc2, yc3, yc4, yc5, yc6, yc7 : integer range 0 to 640;
signal lineData : std_logic_vector(11 downto 0); 
signal lineEn : std_logic; 
signal debounceL, debounceR, debounceD, debounceU: std_logic; 
-- ---------------------------------------------------------------------
begin
m1 :  blk_mem_gen_0 port map(clka =>  clk_100MHz ,addra => memAddrBackground, douta => encodedBackground);

m2 :  blk_mem_gen_1 port map(clka => clk_100MHz, addra => memAddrFishSprite(12 downto 0), douta => ROMDataFishSprite); 

m3 :  blk_mem_gen_2 port map(clka => clk_100MHz, addra => memAddrLinkSplash(12 downto 0), douta => ROMDataLinkSplash);

m4 :  blk_mem_gen_5 port map(clka => clk_100MHz, addra => memAddrLight(16 downto 0), douta => ROMDataLight);

m5 :  blk_mem_gen_4 port map(clka => clk_100MHz, addra => memAddrBolt(9 downto 0), douta => ROMDataBolt);

dec1 :  backGroundDecoder port map(dataIn => encodedBackground, backGroundOut => ROMDataBackground); 

c1 : clk_wiz_0 PORT MAP (clk_in1 => clk_100MHz, reset => reset, clk_out1 => clk_25MHz,
                         locked => locked);
v1 : vga_controller_640_60 PORT MAP (pixel_clk => clk_25MHz, rst => reset, HS => HSYNC, 
                                     VS => VSYNC, blank => blank, hcount => hcount, 
                                     vcount => vcount);
                                     

d1: debounce 
generic map(clkSpeed => 100000000, onTime => 10, tUnits => 1000)
port map(debounceClk => clk_100MHz, btnIn => btnU, btnOut => debounceU);
d2: debounce
generic map(clkSpeed => 100000000, onTime => 10, tUnits => 1000)
port map(debounceClk => clk_100MHz, btnIn => btnD, btnOut => debounceD);
d3: debounce
generic map(clkSpeed => 100000000, onTime => 10, tUnits => 1000)
port map(debounceClk => clk_100MHz, btnIn => btnL, btnOut => debounceL);
d4: debounce
generic map(clkSpeed => 100000000, onTime => 10, tUnits => 1000)
port map(debounceClk => clk_100MHz, btnIn => btnR, btnOut => debounceR);
--a1: animaniacsTesteroonies port map(clkIn => clk_100MHz, movingOffSetX => animatedOffSetX, movingOffSetY => animatedOffSetY);

a1: boltControl 
generic map(rateDefault => 500000)
port map(up => debounceU, down => debounceD, left => debounceL, reset => resetLines, 
right => debounceR, clkIn => clk_100MHz, x1 => xc1, x2 => xc2, x3 => xc3, x4 => xc4, x5 => xc5, x6 => xc6, x7 => xc7,
 y1 => yc1, y2 => yc2, y3 => yc3, y4 => yc4, y5 => yc5, y6 => yc6, y7 => yc7,
xLocation => animatedOffSetX, yLocation => animatedOffSetY, linked => linkCon);


g1: lineCoordinateGenerator port map(clkIn => clk_100MHz, genNewLine => resetLines, resetRand => reset, resetState => reset,
lineReady => lineReady, xo1 => xo1, xo2 => xo2, xo3 => xo3, xo4 => xo4, xo5 => xo5, xo6 => xo6, 
xo7 => xo7, yo1 => yo1, yo2 => yo2, yo3 => yo3, yo4 => yo4, yo5 => yo5, yo6 => yo6, yo7 => yo7); 

--signal xc1, xc2, xc3, xc4, xc5, xc6, xc7, yc1, yc2, yc3, yc4, yc5, yc6, yc7 : integer range 0 to 640;
game: gameStateMachine port map(clkIn => clk_100MHz, lftBtn => debounceL, linkCon => linkCon, linkSplashEn => linkSplashEn, reset => resetLines, resetRandLogic => resetRandLogic); 

L1: vertToLines 
generic map(row1 => 438, rowSpacing => 44, col1 => 471, colSpacing => 42)
port map(clk => clk_100MHz, lineReady => lineReady, 
x1 => xo1, x2 => xo2, x3 => xo3, x4 => xo4, x5 => xo5, x6 => xo6, 
x7 => xo7, y1 => yo1, y2 => yo2, y3 => yo3, y4 => yo4, y5 => yo5, 
y6 => yo6, y7 => yo7, xc1 => xc1, xc2 => xc2, 
xc3 => xc3, xc4 => xc4, xc5 => xc5, xc6 => xc6, xc7 => xc7, yc1 => yc1,
yc2 => yc2, yc3 => yc3, yc4 => yc4, yc5 => yc5, yc6 => yc6, yc7 => yc7, 
hcount => hcount, vcount => vcount, en => lineEn, color => lineData);


lightAND <= (lightEN and linkSplashEn); 
linkAND <= (linkEn and linkSplashEn); --LOOK HERE FOR AND LINKAFNEFNOEAGFNSEAGO:ENg
P1: Draw_Priority_Control 
port map
(backData => indexedDataBackGround, 
fishData => indexedDataFish, 
linkData => indexedDataLink,
herbData => indexedDataLight,
boltData => indexedDataBolt,
lineData => lineData,
enBolt => boltEn,
enHerb => lightAND,
enLink => linkAND,
enLine => lineEn,
enBackGround => backGroundEn, 
enFish => fishEn, 
clk => clk_100MHz,
Red => RED, 
Green => GREEN, 
Blue => BLUE);

I1 : Sprite_Control_Device 
generic map(
spriteWidth => 640,
spriteHeight => 480,
--spriteOffSetX => 0,
--spriteOffSetY => 0,
keyColor => "111100001111"
) 
PORT MAP (hcount => hcount, 
vcount => vcount, 
spriteOffSetX => "0000000000",
spriteOffSetY => "0000000000",
pix_clk => clk_100MHz, 
blank => blank, 
fromMem => ROMDataBackground,
memAddr=> memAddrBackground,
imageDataOut => indexedDataBackground, 
en => backGroundEn
);

I2: Sprite_Control_Device 
generic map(
spriteWidth => 100,
spriteHeight => 61,
--spriteOffSetX => 450,
--spriteOffSetY => 335,
keyColor => "111100001111"
)
PORT MAP (hcount => hcount, 
vcount => vcount,
spriteOffSetX => "0111000010", 
spriteOffSetY => "0101001111", 
pix_clk => clk_100MHz, 
blank => blank, 
fromMem => ROMDataFishSprite,
memAddr => memAddrFishSprite,
imageDataOut => indexedDataFish,
en => fishEn
);

I3: Sprite_Control_Device 
generic map(
spriteWidth => 124,
spriteHeight => 49,
--spriteOffSetX => 258,
--spriteOffSetY => 160,
keyColor => "111100001111"
)
port map(
hcount => hcount,
vcount => vcount,
spriteOffSetX => "0100000010", 
spriteOffSetY => "0010100000",
pix_clk => clk_100MHz,
blank => blank, 
fromMem => ROMDataLinkSplash,
memAddr => memAddrLinkSplash,
imageDataOut => indexedDataLink,
en => linkEn
);

I4: Sprite_Control_Device
generic map(
spriteWidth => 515,
spriteHeight => 135,
--spriteOffSetX => 450,
--spriteOffSetY => 450,
keyColor => "111100001111"
)
port map(
hcount => hcount,
vcount => vcount,
spriteOffSetX => "0000111110", 
spriteOffSetY => "0000101110", 
pix_clk => clk_100MHz,
blank => blank, 
fromMem => ROMDataLight,
memAddr => memAddrLight,
imageDataOut => indexedDataLight,
en => lightEn
);

I5: Sprite_Control_Device
generic map(
spriteWidth => 21,
spriteHeight => 31,
--spriteOffSetX => 240,
--spriteOffSetY => 340,
keyColor => "111100001111")
port map(
hcount => hcount,
vcount => vcount,
spriteOffSetX => animatedOffSetX, 
spriteOffSetY => animatedOffSetY,
pix_clk => clk_100MHz,
blank => blank,
fromMem => ROMDataBolt,
memAddr => memAddrBolt,
imageDataOut => indexedDataBolt,
en => boltEn
);
end Behavioral;