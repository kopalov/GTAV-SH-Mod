-------------------------------------------------------------------------------------
--------------------------------Version 0.8.3 build 1--------------------------------
-------------------------------------------------------------------------------------
-------------------Created by Kopalov with help from Henny Smafter-------------------
-------------------------------------------------------------------------------------
------------------------------- !!! IMPORTANT !!! -----------------------------------
------------ CHANGE to some folder on your PC (Which is not read-only). -------------
-------------------------------------------------------------------------------------

local savepath = "D:/% WinDoc/Rockstar Games/1/"
-- For example, "C:/Users/Johny/Documents/Rockstar Games/GTA V/GTA5_Housemod/"

-------------------------------------------------------------------------------------
------------------------------------ MOD OPTIONS ------------------------------------
-------------------------------------------------------------------------------------

local allowmod = true             -- Set to false to turn this mod OFF.

local enablehouse = true          -- Set to false if you don't want default safehouses.
local enablecustom = true         -- Set to false if you don't want to be able to manually add savehouses.
local enablehotels = true         -- Set to false if you don't want hotels and apartments for rent.
local enablehouseblips = true     -- If 'true', shows Safehouse blips on the map. Set to 'false' to disable.
local enablecustomblips = true    -- If 'true', shows Custom Safehouse blips on the map. Set to 'false' to disable.
local enablehotelblips = true     -- If 'true', shows Hotel blips on the map. Set to 'false' to disable.
local blipsize = 0.7              -- Blip size. Increase or decrease for your taste. Default is 0.8
local spawnhour = 6               -- Clock hour at which you will be spawned on game load.
local spawnminute = 0             -- Clock minute at which you will be spawned on game load.
local mkcustomkey = 97            -- Key to create a custom safehouse.
local mkblipsoff = 103            -- Key to disable all blips. (Depending on the above settings!)
local mkblipson = 105             -- Key to enable all blips. (Depending on the above settings!)
local customcost = 750000         -- How much does custom safehouse creation cost.
local sleeptimer = 6              -- How many hours does time advances when you save your game.
local updatehouses = true         -- If enabled, updates your safehouse savefile, adding more houses. All previous data remains in its place.
local updatehotels = true	        -- If enabled, updates your hotel savefile, adding more hotels. All previous data remains in its place.

-------------------------------------------------------------------------------------
----------------------------------- KEY REFERENCE -----------------------------------
-------------------------------------------------------------------------------------

--	Space = 32            D4 = 52       O = 79             NumPad4 = 100         F9 = 120
--  PageUp = 33           D5 = 53       P = 80             NumPad5 = 101         F10 = 121
--	Next = 34             D6 = 54       Q = 81             NumPad6 = 102         F11 = 122
--  End = 35              D7 = 55       R = 82             NumPad7 = 103         F12 = 123
--	Home = 36             D8 = 56       S = 83             NumPad8 = 104         F13 = 124
--  Left = 37             D9 = 57       T = 84             NumPad9 = 105         F14 = 125
--	Up = 38               A = 65        U = 85             Multiply = 106        F15 = 126
--  Right = 39            B = 66        V = 86             Add = 107             F16 = 127
--	Down = 40             C = 67        W = 87             Separator = 108       F17 = 128
--  Select = 41           D = 68        X = 88             Subtract = 109        F18 = 129
--  Print = 42            E = 69        Y = 89             Decimal = 110         F19 = 130
--	Execute = 43          F = 70        Z = 90             Divide = 111          F20 = 131
--  PrintScreen = 44      G = 71        LWin = 91          F1 = 112              F21 = 132
--	Insert = 45           H = 72        RWin = 92          F2 = 113              F22 = 133
--  Delete = 46           I = 73        Apps = 93          F3 = 114              F23 = 134
--	Help = 47             J = 74        Sleep = 95         F4 = 115              F24 = 135
--  D0 = 48               K = 75        NumPad0 = 96       F5 = 116
--	D1 = 49               L = 76        NumPad1 = 97       F6 = 117
--  D2 = 50               M = 77        NumPad2 = 98       F7 = 118
--	D3 = 51               N = 78        NumPad3 = 99       F8 = 119

-------------------------------------------------------------------------------------
----------------------------------- CHANGELOG ---------------------------------------
-------------------------------------------------------------------------------------
---------------------------------- 0.8.  --------------------------------------------

---------------------------------- 0.7.8 --------------------------------------------
--Added new houses there are now 93 houses with most of them having parking spaces
--Changed default keys
---------------------------------- 0.7.7 --------------------------------------------
--Added User Defined Keys for turning on/off the blips. This can potentially fix problems with missing mission blips.
---------------------------------- 0.7.6 --------------------------------------------
--Improved map blips
---------------------------------- 0.7.5 --------------------------------------------
--Added directory check.
--Improved spawn-in mechanic (now camera is faded out while you spawn).
--Added more hotels and houses.
--Added automatic hotel and house list update functionality.
--Added new blips for apartments available for rent.
--Improved buttons (GUI will be completely reworked soon).
--Added ability to turn mod on/off.
--Added greeting message to hotels and apartments, which says how many days you have left.
---------------------------------- 0.7.1 --------------------------------------------
--Disabled some debugging tools.
---------------------------------- To Do --------------------------------------------

--[ ]-- On screen text flickering (this is because function reloads text every tick, which is needed for key presses to work properly).
--[ ]-- If hotel rent time expires for more than one character at once, only one goodbye message is displayed.
--[ ]-- Spawn player inside his house, not on doorstep.
--[ ]-- Add period of time without messages after spawn.
--[ ]-- 
--[ ]-- Improve "Not enough money" messages (most of the times they are not shown).
--[ ]-- FIX: If you are quick enough, you can buy or rent property even if you have insufficient funds.

-------------------------------------------------------------------------------------
-- DO NOT EDIT ANYTHING BELOW UNLESS YOU ARE 100% SURE YOU KNOW WHAT YOU ARE DOING --
-------------------------------------------------------------------------------------

local hupdated = false
local htupdated = false

local sh = {}
local timer = 0
local buttontimer = 0
local price = 0
local textstay = false
local playercash = 0
local faraway = {-2434,389,150}
local currentmodel = 0
local decision = false
local confirm = false
local sdecision = false
local cdecision = false
local htdecisions = false
local htdecisionl = false
local rsconfirm = false
local rlconfirm = false
local showtext = false
local texttoshow = "Dummy"

local htable = {}
local httable = {}
local ctable = {}
local htosave = {}
local initialday = 0
local spawnchecker = false

local charactername = "Dummy"

local stopproxtick = false
local tickcooldown = 0
local dirok = true
local intarray = {}
local lookforsave = false
local lookforexit = false
local insidetimer = 0

----------------------------------------OLD SH LIST-------------TAKE INTERIOR NUMBERS-----------------------------------------
--local h = {{1, 0,0,0, 0,0,0,-1063.7385253906,-1159.8004150391,2.3458766937256,24.428289413452,280000,0,4}, --Vesp Channels
--	{2, 0,0,0, 0,0,0,-1090.7722167969,-926.11767578125,3.1406140327454,31.203266143799,450000,0,9}, --Vesp Channels
--	{3, 0,0,0, 0,0,0,-1085.1437988281,-1558.2083740234,4.4977512359619,39.944465637207,720000,0,6}, --Vesp Beach
--	{4, 0,0,0, 0,0,0,-904.55102539063,588.05395507813,101.19079589844,124.93965911865,1650000,0,8}, --179 h 9 vw hills c180
--	{5, 0,0,0, 0,0,0,114.04767608643,-1961.1394042969,21.334177017212,33.8977394104,180000,0,3}, --Gr Str
--	{6, 0,0,0, 0,0,0,-105.78726959229,6528.6728515625,30.166921615601,18.099699020386,320000,0,3}, --181 h 4 Paleto Bay c182
--	{7, 0,0,0, 0,0,0,2354.9150390625,2540.4321289063,47.306755065918,196.83633422852,20000,0,4}, --120 sh trailer 4 c121
--	{8, 0,0,0, 0,0,0,3688.384765625,4562.7553710938,25.183057785034,245.25634765625,60000,0,3}, --122 sh 4 wilderness c123
--	{9, 0,0,0, 0,0,0,1725.1340332031,4642.4467773438,43.875480651855,135.33944702148,50000,0,3}, --124 sh farm c125
--	{10, 0,0,0, 0,0,0,1830.8139648438,3738.349609375,33.961898803711,337.30172729492,40000,0,3}, --135 sh SSh 10 c136
--	{11, 0,0,0, 0,0,0,1406.9605712891,3655.9033203125,34.430500030518,48.561229705811,75000,0,4}, --138 sh SSh 9 c139
--	{12, 0,0,0, 0,0,0,414.74154663086,-217.48414611816,59.910438537598,290.12777709961,600000,0,7}, --77 apt 2 c78
--	{13, 0,0,0, 0,0,0,484.64700317383,212.57495117188,108.30955505371,251.37358093262,105000,0,2},--35 apt down vw c36 8
--	{14, 0,0,0, 0,0,0,903.01519775391,-615.52874755859,58.453296661377,275.31607055664,1500000,0,8},--31 - mir park, 1.5 c32
--	{15, 0,0,0, 0,0,0,-476.58337402344,647.99664306641,144.38670349121,2.0846719741821,300000,0,9},--26 vin hills (27c) 8
--	{16, 0,0,0, 0,0,0,178.92713928223,44.210914611816,87.822509765625,162.22875976563,220000,0,2},--24 downtown winewood (25c)5f	
--	{17, 0,0,0, 0,0,0,-1996.1871337891,591.07659912109,118.1019744873,245.96002197266,1650000,0,8}, --W V Hills
--	{18, 0,0,0, 0,0,0,114.04767608643,-1961.1394042969,21.334177017212,33.8977394104,180000,0,3}, --Gr Str -------------повтор
--	{19, 0,0,0, 0,0,0,332.92190551758,-1741.6259765625,29.730527877808,192.81414794922,320000,0,4}, --Near Gr Str
--	{20, 0,0,0, 0,0,0,1245.4300537109,-1626.6199951172,53.282196044922,31.311986923218,300000,0,9}, --El Burro
--	{21, 0,0,0, 0,0,0,1006.256652832,-511.13861083984,60.833992004395,153.93867492676,840000,0,6}, --Mirror Park
--	{22, 0,0,0, 0,0,0,1323.3957519531,-582.88482666016,73.246383666992,346.30725097656,1200000,0,9}, --Mirror Park new
--	{23, 0,0,0, 0,0,0,97.582374572754,-255.97975158691,47.489917755127,16.740756988525,160000,0,2}, --Alta, apt
	-----------------------------------v0.7.2----------------------------------------------------
--	{24, 0,0,0, 0,0,0,-1667.2868652344,-441.49227905273,40.355751037598,230.82095336914,1500000,0,8}, --162 sh Del Perro 1 c163
--	{25, 0,0,0, 0,0,0,-930.18493652344,19.264205932617,48.519329071045,228.8722076416,1800000,0,8}, --187 sh 1 rockford hills c188
--	{26, 0,0,0, 0,0,0,-599.04284667969,147.58724975586,61.672714233398,172.53735351563,180000,0,2}, --189 sh apt w vw c190
--	{27, 0,0,0, 0,0,0,-1135.8990478516,375.85192871094,71.299789428711,319.66394042969,1300000,0,8}, --201 sh1 vw c202
--	{28, 0,0,0, 0,0,0,-1193.2111816406,563.88299560547,100.33944702148,175.4333190918,440000,0,6}, --203 sh6 vw c204
--	{29, 0,0,0, 0,0,0,-233.09860229492,588.37030029297,190.53633117676,328.00735473633,600000,0,9}, --205 sh4 vw c206
--	{30, 0,0,0, 0,0,0,-3037.0710449219,558.74334716797,7.507682800293,268.29034423828,260000,0,6}, --207 sh6 ineseno road c208
--	{31, 0,0,0, 0,0,0,-3228.9545898438,927.30718994141,13.969757080078,284.72924804688,240000,0,3}, --209 sh6 Chumash c210
--	{32, 0,0,0, 0,0,0,-447.76654052734,6271.7504882813,33.330070495605,81.762573242188,180000,0,9}, --215 sh6 Paleto Bay c216
--	{33, 0,0,0, 0,0,0,1428.5987548828,6354.076171875,23.985015869141,190.0751953125,50,0,4}, --217 sh tent c218
--	{34, 0,0,0, 0,0,0,-105.78726959229,6528.6728515625,30.166921615601,18.099699020386,140000,0,4}, --Paleto Bay
	-----------------------------------v0.8------------------------------------------------------
--	{35, 0,0,0, 0,0,0,-2587.8732910156,1911.0374755859,167.49896240234,345.32604980469,3400000,0,8} --Devin Vesten c241
--	}

--------------------------------------Interior test list-----------------------------------
local h = {{1, 0,0,0, 0,0,0,-948.62927246094,-1107.7398681641,2.1718480587006,36.55443572998,280000,0,1}, ---- 3+ Parking Space -- Canal Island
	{2, 0,0,0, 0,0,0,-952.64404296875,-1077.7933349609,2.6728272438049,204.45997619629,295000,0,2}, ---- 3+ Parking Space -- Canal Island
	{3, 0,0,0, 0,0,0,-1055.4119873047,-913.38513183594,3.4768340587616,27.156518936157,450000,0,3}, ---- 2+ Parking Space -- Canal Island
	{4, 0,0,0, 0,0,0,-1022.5373535156,-896.94165039063,5.411808013916,8.1293268203735,505000,0,4}, ---- 4+ Parking Space -- Canal Island
	{5, 0,0,0, 0,0,0,-1063.7385253906,-1159.8004150391,2.3458766937256,24.428289413452,280000,0,5}, ---- 0+ Parking Space -- Vesp Channels
	{6, 0,0,0, 0,0,0,-1090.7722167969,-926.11767578125,3.1406140327454,31.203266143799,450000,0,6}, ---- 0+ Parking Space --Vesp Channels
	{7, 0,0,0, 0,0,0,-1037.05078125,-1605.3411865234,4.9727439880371,31.708919525146,720000,0,7}, ---- 2+ Parking Space -- Beach Properties East Los Santos
	{10, 0,0,0, 0,0,0,-1085.1437988281,-1558.2083740234,4.4977512359619,39.944465637207,720000,0,8} ---- 1+ Parking Space --Vesp Beach
	
	}

local htdescr = {{1,"Name","r type","shortstay period","longstay period"},
	{2,"Pipeline Inn","room",2,5},
	{3,"Crown Jewels Motel","room",1,3},
	{4,"Vespucci Beach Rent","apartment",7,30},
	{5,"Vespucci Hotel","room",2,5},
	{6,"Venetian Hotel","room",1,3},
	{7,"Vespucci Beach Rent","apartment",7,30},
	{8,"Vespucci Beach Rent","apartment",7,30},
	{9,"The Viceroy Hotels and Resorts","room",2,5},
	{10,"Little Seoul Sunshine Apartments","apartment",7,30},
	{11,"Crastenburg Hotels & Resorts","room",1,3},
	{12,"Opium Nights Hotel","room",2,5},
	{13,"Casa Cristina","apartment",7,30},
	{14,"Motel","room",3,7},
	{15,"Motel","room",2,5},
	{16,"Von Crastenburg Hotel","room",1,3},
	{17,"Apartment","apartment",7,30},
	{18,"Callisto Apartments","apartment",7,30},
	{19,"Vinewood Gardens Hotel","room",2,5},
	{20,"Centry Manor Hotel","room",2,5},
	{21,"Elgin House Hotel","room",2,5},
	{22,"Motel","room",3,7},
	{23,"Alesandro Hotel","room",1,3},
	{24,"Elkridge Hotel","room",2,5},
	{25,"Banner Hotel & Spa","room",2,5},
	----------------v0.7.2--------------------
	{26,"Motel Wisdahl","room",3,5},
	{27,"Templar Hotels","room",1,3},
	{28,"Hedera Apartment Rent","apartment",7,30},
	{29,"Perrera Beach Motel","room",2,5},
	{30,"Crastenburg Hotels & Resorts","room",2,5},
	{31,"Banner Hotel & Spa","room",2,5},
	{32,"Crastenburg Hotel","room",1,3},
	{33,"Rockford Dorset","room",2,5},
	{34,"The Pink Cage Motel","room",2,5},
	--{34,"Paleto Bay Rent","room",7,30},
	{35,"Apartment Rent","apartment",7,30},
	{36,"Apartment Rent","apartment",7,30},
	{37,"Apartment Rent","apartment",7,30},
	{38,"Hotel","room",2,5},
	{39,"Centry Manor Hotel","house",5,10},
	{40,"The Richman Hotel","room",2,5},
	{41,"Marlowe Vineyard","room",1,2},
	{42,"Dream View Motel","room",3,5},
	----------------v0.8--------------------
	{43,"The Motor Hotel","room",2,5},
	--{45,"Elkridge Hotel","room",2,5},
	--{46,"Elkridge Hotel","room",2,5},
	--{47,"Elkridge Hotel","room",2,5},
	--{48,"Elkridge Hotel","room",2,5},
	}

local ht = {{0,0},
	{2, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -2194.308, -388.276, 13.470,16.740756988525, 125, 1}, --Pipeline Inn - c
	{3, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1308.911, -931.208, 13.359,16.740756988525, 70, 1}, --Crown Jewels Motel
	{4, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -988.833, -1575.737, 5.231,16.740756988525, 20, 2}, --4 rent vb
	{5, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1182.967, -1556.823, 5.038,16.740756988525, 60, 2},
	{6, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1342.782, -1076.393, 6.939,16.740756988525, 240, 1}, -- Venetian
	{7, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1014.465, -1514.411, 6.517,16.740756988525, 20, 2},
	{8, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -969.335, -1431.057, 7.764,16.740756988525, 20, 2},
	{9, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -822.091, -1223.600, 7.365,16.740756988525, 200, 1}, --The Viceroy Hotels and resorts
	{10, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -728.485, -880.107, 22.711,16.740756988525, 30, 2}, --lit seoul sunshine apartments
	{11, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -875.019, -2179.978, 9.809,16.740756988525, 170, 1}, --Crastenburg Hot&resorts (airop 1)
	{12, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -737.743, -2274.540, 13.437,16.740756988525, 150, 1}, --Opium nights hotel 2 
	{13, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -69.260, -1526.779, 34.235,16.740756988525, 12, 2}, --casa cristina (near frank 4) 
	{14, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 372.191, -1791.460, 29.095,16.740756988525, 70, 1}, --motel 4 (near groove) 
	{15, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 561.689, -1774.355, 33.443,16.740756988525, 85, 1}, --motel 3 
	{16, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 435.71450805664,215.06147766113,103.16605377197,337.65612792969, 220, 1}, --Von Crastenburg 39
	{17, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 106.98572540283,54.696445465088,77.769584655762,247.14981079102, 35, 2},--47 apt vw bld
	{18, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 391.36395263672,3.2578566074371,91.93132019043,63.671298980713, 50, 2},--49 apt Callisto Apartments
	{19, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 328.91983032227,-68.89729309082,73.037803649902,168.40313720703, 200, 1},--58 hot Vinewood Gardens
	{20, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 17.840244293213,318.94683837891,110.91898345947,91.281471252441, 120, 1},--65 hot Centry Manor
	{21, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -72.256217956543,142.14944458008,81.495307922363,77.494720458984, 180, 1},--61 hot Elgin House
	{22, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 66.323944091797,-255.91584777832,52.353881835938,123.30829620361, 85, 1},--73 Motel 3
	{23, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 307.70330810547,-727.93682861328,29.316793441772,241.75, 100, 1},--86 hot Alesandro Hotel 3
	{24, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 286.54522705078,-937.22918701172,29.467842102051,144.39189147949, 140, 1},--93 Elkridge Hotel 2 c94
	{25, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -273.943359375,-883.806640625,31.241750717163,214.62785339355, 150, 1},--106 Banner Hotel & Spa 2 c107
	--------------------------------------v0.7.2-----------------------------------------
	{26, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 57.467880249023,-1004.7907104492,29.357431411743,359.03179931641, 100, 1},--110 Motel Wisdahl 2 c111
	{27, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 288.04669189453,-1094.8298339844,29.419662475586,91.308853149414, 140, 1},--114 Templar Hotels 2 c115
	{28, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},--143 app rent Hedera c144
	{29, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1454.5185546875,-656.00653076172,33.381237030029,45.131774902344, 90, 1},--147 Perrera Beach Motel c148
	{30, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1545.7017822266,-530.62066650391,36.148220062256,33.43384552002, 250, 1},--151 Crastenburg Hot&Res c152
	{31, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1660.6646728516,-533.94842529297,36.023990631104,138.85432434082, 140, 1},--160 banner hotel & spa 3 c161
	{32, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1857.1146240234,-348.12091064453,49.837738037109,148.86190795898, 280, 1},--166 Crastenburg Hot 1 c167
	{33, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -570.39379882813,-395.46960449219,35.037891387939,357.26895141602, 200, 1},--185 h? Rockford Dorset c186
	{34, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 340.90374755859,-214.79853820801,58.019241333008,103.72160339355, 100, 1},--79 Motel 3 The Pink Cage c80
	--{34, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -105.78726959229,6528.6728515625,30.166921615601,18.099699020386, 30, 2},--181 h 4 Paleto Bay c182
	{35, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -904.55102539063,588.05395507813,101.19079589844,124.93965911865, 25, 2},--179 h 9 vw hills c180
	{36, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -385.11584472656,159.71208190918,73.733001708984,150.53001403809, 20, 2},--191 h rent 8 c192
	{37, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -336.16714477539,30.917057037354,47.858982086182,88.831214904785, 40, 2},--193 h rent 6 c194
	{38, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -273.9186706543,28.600929260254,54.752494812012,251.64653015137, 120, 2},--195 h vvw 3 c 196
	{39, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -34.174911499023,347.9462890625,113.99765777588,167.380859375, 180, 1},--197 h 2 Centry Manor c198
	{40, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1273.7852783203,315.96365356445,65.511772155762,149.59870910645, 220, 1},--199 h1 The Richman Hotel c200
	{41, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1886.5815429688,2050.2531738281,140.98083496094,192.25430297852, 100, 2},--211 hrent2 Marlowe Vineyard c212
	{42, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -107.40759277344,6339.9702148438,35.500743865967,231.78079223633, 80, 1},--213 h3 Dream View Motel c214
	----------------v0.8--------------------
	{43, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 1136.5635986328,2641.6394042969,38.143707275391,27.30855178833, 75, 1}--Motor hotel c237
	--{36, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},-
	--{37, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},-
	--{38, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},-
	--{39, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},-
	--{40, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},-
	--{41, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2}
	}

local interior = {{1,151.4981842041,-1008.05859375,-99.000015258789,336.45590209961, 154.34252929688,-1003.2754516602,-98.999961853027,248.35888671875},--hotel room
	{2,-107.83421325684,-8.3598766326904,70.519630432129,97.708541870117, -111.13466644287,-10.718485832214,70.519622802734,14.13726234436},--basic apartment(janitor)
	{3,266.04748535156,-1003.8999023438,-99.004898071289,354.51895141602, 262.90921020508,-1003.1085205078,-99.008575439453,243.61944580078},--small house(from online)
	{4,1274.1540527344,-1719.6486816406,54.771457672119,15.826478004456, 1276.2813720703,-1714.5952148438,55.081481933594,238.12216186523},--Lester's house
	{5,-1902.0795898438,-572.50567626953,19.097219467163,99.215171813965, -1912.2564697266,-569.91326904297,19.097219467163,161.91348266602},--Psychologist's office
	{6,-1151.0661621094,-1520.5487060547,10.632719993591,14.21820640564, -1149.865,-1512.601,10.633,14.21820640564},--Floyd's house
	{7,-782.18969726563,326.029296875,223.25765991211,192.2679901123, -759.6259765625,319.87289428711,217.05030822754,253.18368530273},--Eclypse tower(from online)
	{8,1396.6484375,1138.4544677734,114.33359527588,274.03021240234, 1396.9998779297,1130.5531005859,114.33359527588,172.71952819824},--Madrazo villa
	{9,-1151.0661621094,-1520.5487060547,10.632719993591,14.21820640564, -1151.0661621094,-1520.5487060547,10.632719993591,14.21820640564}--Floyd, заглушка для медиума
	}

function sh.unload()
	sh.clearblips()
	sh.clearinterblips()
end

function sh.init()
	
	sh.shGUI = Libs["shGUI"]
	sh.filecheck()
	if allowmod then sh.loadfiles()
	sh.whoisplayer()
	initialday = TIME.GET_CLOCK_DAY_OF_MONTH()
	spawnchecker = true 
	end
	--sh.checkspawn()
	--sh.addblips()
	sh.shGUI.hidden = true
	
end

local inside1 = false
local inside2 = false
local inside3 = false
local dialogactive = false
local exittype = 0
local exitdelay = 100
local enterdialog = false
local typetoenter = 0

function sh.tick()

	local playerdriving = PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), true)
	local playerwanted = PLAYER.GET_PLAYER_WANTED_LEVEL(PLAYER.PLAYER_ID())
	
	if (timer > 1) then timer = timer - 1 sh.drawhint() end
	if (not dirok) and (not CAM.IS_SCREEN_FADED_OUT()) then
		sh.showhint(700,"Something is wrong with your save directory.".."\n".."Make sure you edited script file.".."\n".."Safehouse Mod OFF")
		dirok = true
	end 
	
	if allowmod then 
	
	if (buttontimer > 1) then                          -- Проблема с выбором, т.к. тик конфликтует с while
		if decision then sh.buydecision() end
		if confirm then sh.buyconfirm() end
		if sdecision then sh.sellconfirm() end
		if cdecision then sh.customconfirm() end
		if htdecisions then sh.hotelchooses() end
		if htdecisionl then sh.hotelchoosel() end
		if inside1 then sh.interior(1) end
		if inside2 then sh.interior(2) end
		if inside3 then sh.interior(3) end
	else 
		decision = false
		confirm = false
		sdecision = false
		cdecision = false
		htdecision = false
		rsconfirm = false
		rlconfirm = false
		inside1 = false
		inside2 = false
		inside3 = false
		--sh.shGUI.hidden = true
		--sh.shGUI.buttonCount = 0
	end
	
	if (tickcooldown > 0) then 
		stopproxtick = true 
		tickcooldown = tickcooldown - 1
	else stopproxtick = false --print("proxtick resumed by timer")
	end
	
	if (insidetimer > 0) then --enableinsidetimer and (insidetimer > 0) then
		dialogactive = true
		insidetimer = insidetimer - 1
	--elseif enableinsidetimer and (insidetimer <= 0) then
	--	lookforsave = false
	--	lookforexit = false
	else 
		dialogactive = false 
		--sh.clearinterblips()
	end
	
	if lookforsave and (not dialogactive) then
		sh.looksave()
	end
	
	if lookforexit and (not dialogactive) then
		sh.lookexit()
	end
	
	if enterdialog and stopproxtick then
		sh.enterhouse()
	end
	
	if (not CAM.IS_SCREEN_FADED_OUT()) and spawnchecker then
		sh.checkspawn()
		spawnchecker = false
	end
	
	if (sh.whoisplayer()~=currentmodel) then currentmodel = sh.whoisplayer()
		print("Model changed to "..currentmodel)
		sh.clearblips()
		sh.addblips()
	end
	
	if (not stopproxtick) and (playerwanted==0) and (not playerdriving) then
		if enablehouse then sh.getproximityh() end
		if enablehotels then sh.getproximityht() end
		if enablecustom then sh.getproximityc() end
	end
		
	if (get_key_pressed(mkcustomkey)) then
		sh.custom()
	end
	
	if enablehotels then--------------------------------------------------------------------------------------------------------
		local currentday = TIME.GET_CLOCK_DAY_OF_MONTH()
		if (currentday > initialday) then
		sh.daypassed()
		sh.showhint(125,"Day passed by..."..currentday.." - "..initialday)
		initialday = currentday end
		--print("day passed"..currentday..initialday)
	end
	if (get_key_pressed(Keys.C)) then -------------------------- Debug tool. remove in release!
	ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),-1085.1437988281,-1550.2083740234,4.4977512359619,true,true,true,true)
	end
	
	if (get_key_pressed(Keys.X)) then -------------------------- Debug tool. remove in release!
	ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),-1149.865,-1512.601,10.633,true,true,true,true)
	end
	
	if (get_key_pressed(mkblipsoff)) then
		sh.clearblips()
	end
	
	if (get_key_pressed(mkblipson)) then
		sh.clearblips()
		sh.addblips()
	end
	
	sh.shGUI.tick()
	end
end

function sh.enterhouse()

	print("enterhouse")
	if (typetoenter==1) then
		sh.shGUI.hidden = false
		sh.shGUI.buttonCount = 0
		sh.shGUI.addButton("Go inside",sh.interior,nil,0,0.2,0.06,0.06)
		sh.shGUI.addButton("Sell Property",sh.sellhouse,nil,0,0.2,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.2,0.06,0.06)
	end
	enterdialog = false
	print("end enterhouse")
	
end

function sh.exithouse()
	
	sh.shGUI.buttonCount = 0
	sh.shGUI.hidden = true
	
	if (typetoenter == 1) then
			CAM.DO_SCREEN_FADE_OUT(250)
			wait(500)
			ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(htosave[8]), tonumber(htosave[9]), tonumber(htosave[10]),true,true,true,true)
			ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(htosave[10]))
			lookforexit = false
			wait(250)
			CAM.DO_SCREEN_FADE_IN(250)
		elseif (typetoenter == 2) then
			CAM.DO_SCREEN_FADE_OUT(250)
			wait(500)
			ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(httosave[14]), tonumber(httosave[15]), tonumber(httosave[16]),true,true,true,true)
			ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(httosave[17]))
			lookforexit = false
			wait(250)
			CAM.DO_SCREEN_FADE_IN(250)
		elseif (typetoenter == 3) then
			CAM.DO_SCREEN_FADE_OUT(250)
			wait(500)
			ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(ctosave[8]), tonumber(ctosave[9]), tonumber(ctosave[10]),true,true,true,true)
			ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(ctosave[10]))
			lookforexit = false
			wait(250)
			CAM.DO_SCREEN_FADE_IN(250)
	end
	
	sh.clearinterblips()
	
end

function sh.looksave()
	
	print("lookforsave")
	
	local plcoord = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
	--if (GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(plcoord.x, plcoord.y, plcoord.z, -1149.865,-1512.601,10.633, true) < 0.5) then
	if (GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(plcoord.x, plcoord.y, plcoord.z, intarray[6], intarray[7], intarray[8], true) < 0.5) then
		insidetimer = 200
		sh.shGUI.buttonCount = 0
		sh.shGUI.hidden = false
		sh.shGUI.addButton("Save Game",sh.savegame,typetoenter,0,0.2,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.2,0.06,0.06)
		
	end
	
	print("lookforsave end")
	
end

function sh.lookexit()

	print("lookexit")
		
	local plcoord = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)

	wait(200)
		
	if (GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(plcoord.x, plcoord.y, plcoord.z, intarray[2], intarray[3], intarray[4], true) < 1) then
			insidetimer = 200
		sh.shGUI.buttonCount = 0
		sh.shGUI.updateSelection()
		sh.shGUI.hidden = false
		sh.shGUI.addButton("Exit",sh.exithouse,nil,0,0.2,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.2,0.06,0.06)
		--sh.showhint(10,"You are near exit")
		--exitdelay = exitdelay - 1
	--else exitdelay = 100 print("delay 100")
	end

	print("lookexit end")

end

--blip 408 - realtor
--blip 366 - wardrobe
local interblip = {}
local interbliptable = {}
function sh.addinterblips(array)
	
	print ("adding inter blips")
	sh.clearinterblips()
	interblip = {}
	interbliptable = {}
	--local a = 1
	--while (a <= #interior) do
	--	local tbl = interior[a]
	--	if (tonumber(tbl[13])==currentmodel) then
	--		table.insert(interblip, {tonumber(tbl[6]), tonumber(tbl[7]), tonumber(tbl[8])})
	--	elseif (tonumber(tbl[13])==0) then
	--		table.insert(phblip, {tonumber(tbl[8]), tonumber(tbl[9]), tonumber(tbl[10])})
	--	elseif (tonumber(tbl[13])~=0) and (tonumber(tbl[13])~=currentmodel) then
	--		table.insert(ohblip, {tonumber(tbl[8]), tonumber(tbl[9]), tonumber(tbl[10])})
	--	a = a + 1	
	--end
	local intblip = {}
	--for i, coord in ipairs(intarray) do
			intblip = UI.ADD_BLIP_FOR_COORD(intarray[6],intarray[7],intarray[8])
			UI.SET_BLIP_SPRITE(intblip, 441) -------------------------------------change blip icon
			UI.SET_BLIP_SCALE(intblip, blipsize)
			UI.SET_BLIP_AS_SHORT_RANGE(intblip, true)
			table.insert(interbliptable, (#interbliptable+1), intblip)
	--end
	
	print ("inter blips added: "..#interbliptable)
	
end

function sh.clearinterblips()
	
	print("clearing inter blips")
	local i = 1
	while (i <= #interbliptable) do
		UI.REMOVE_BLIP(interbliptable[i])
		print("remove blip "..interbliptable[i])
		i=i+1
	end
	wait(500)
	print("inter blips cleared")
	
end

local cnt = 0
function sh.getproximityh()
	
	--print("getprox-h") -- Убрать для теста подфункций
	local plcoord = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
	
	if(cnt >= #htable) then cnt = 0 end
	cnt = cnt + 1
	local coord = htable[cnt]

	if (GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(plcoord.x, plcoord.y, plcoord.z, coord[8], coord[9], coord[10], true) < 2) then
		stopproxtick = true print("tick stopped")
		tickcooldown = 500 print("tick cooldown")
		htosave = htable[cnt] print("table set for htable "..cnt)
		sh.safehouse() print("safehouse initiated")
	end
	
end

local cntht = 1
function sh.getproximityht()

	--print("getprox-ht")
	local plcoord = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)

	if(cntht >= #httable) then cntht = 1 end
	cntht = cntht + 1
	
	local coord = httable[cntht]

	if (GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(plcoord.x, plcoord.y, plcoord.z, coord[14], coord[15], coord[16], true) < 2) then
		stopproxtick = true print("tick stopped")
		tickcooldown = 500 print("tick cooldown")
		httosave = httable[cntht] print("table set for httable "..cntht)
		sh.hotel() print("hotel initiated")
	end
	
end

local cntc = 0
function sh.getproximityc()

	local plcoord = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)

	if(cntc >= #ctable) then cntc = 0 end
	cntc = cntc + 1
	
	local coord = ctable[cntc]
	
	if (GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(plcoord.x, plcoord.y, plcoord.z, coord[8], coord[9], coord[10], true) < 2)
		and (tonumber(coord[13])==1) then
		stopproxtick = true print("tick stopped")
		tickcooldown = 500 print("tick cooldown")
		ctosave = ctable[cntc] print("table set for ctable "..cntc)
		sh.customsh() print("customsh initiated")
	end
	
end

function sh.interior()
	print("interior")
	local array = {}
	sh.shGUI.buttonCount = 0
	sh.shGUI.hidden = true
	
	print("typetoenter: "..typetoenter)
	if (typetoenter==1) then savetype = 1 exittype = 1 array = interior[tonumber(htosave[14])] 	intarray = array
	elseif (typetoenter==2) then savetype = 2 exittype = 2 array = interior[tonumber(httosave[14])] intarray = array
	elseif (typetoenter==3) then savetype = 3 exittype = 3 array = interior[tonumber(ctosave[14])] intarray = array end
	
	CAM.DO_SCREEN_FADE_OUT(250)
	wait(500)
	ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(array[2]), tonumber(array[3]), tonumber(array[4]),true,true,true,true)
	ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(array[5]))
	wait(250)
	CAM.DO_SCREEN_FADE_IN(250)
	
	sh.showhint(150,"Welcome Home, "..charactername)

	insidetimer = 100
	lookforsave = true
	
	lookforexit = true
	dialogactive = false
	
	sh.addinterblips(array)
	
	print("interior end")
end

function sh.safehouse()
	
	print("safehouse")

	local counter = (currentmodel + 1)
	local owned = false
	local notowned = false
	local ownedbyother = false
	
	if (tonumber(htosave[13])==currentmodel) then--[counter])==1) then
	owned = true print("sh set to owned")
	typetoenter = 1
	--sh.showhint(150,"Welcome Home, "..charactername)
	wait(200)
	enterdialog = true
	elseif (tonumber(htosave[13])==0) then--counter])==0) then
	notowned = true print("sh set to not owned")
	elseif (tonumber(htosave[13])~=0 and tonumber(htosave[13])~=currentmodel) then--counter~=2) or (tonumber(htosave[3])==1 and counter~=3) or (tonumber(htosave[4])==1 and counter~=4)
	ownedbyother = true
	end
	
	if ownedbyother then
	sh.showhint(150,"This house is owned by another character")
	wait(500)
	
	--elseif owned then
	--		print("owned")
	--		sh.showhint(150,"Welcome Home, "..charactername)
	--		wait(750)
	--		sh.interior(1)
			--sh.camerawork(1, htosave[1])
			--sh.shGUI.hidden = false
			--sh.shGUI.buttonCount = 0
			--sh.shGUI.addButton("Save Game",sh.savegame,1,0,0.2,0.06,0.06)
			--sh.shGUI.addButton("Sell this house",sh.sellhouse,nil,0,0.2,0.06,0.06)
			--sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.2,0.06,0.06)

	elseif notowned then
		local hprice = tonumber(htosave[12])
		sh.showhint(150,"Press E" .."\n".."to buy this house for $"..hprice.." or N to cancel.")
		decision = true
		buttontimer = 200
	end
	
	print("end safehouse")
end
		
function sh.buyconfirm()
	sh.showhint(150,"Are you sure?".."\n".."Press Y to confirm, N to cancel")
	if (get_key_pressed(Keys.Y)) then sh.housebought() confirm = false
	elseif (get_key_pressed(Keys.N)) then sh.showhint(150,"Purchase cancelled") confirm = false end
	buttontimer = buttontimer - 1
end

function sh.buydecision()
	local hprice = tonumber(htosave[12])
	if (not sh.domoneycheck(htosave[12])) then sh.showhint(150,"Not enough money") confirm = false decision = false stopproxtick = false end
	wait(50)
	if (get_key_pressed(Keys.E)) then confirm = true decision = false buttontimer = 200 end
	buttontimer = buttontimer - 1
end

function sh.savegame(tp)

	local count = (currentmodel + 4)
	--sh.camerawork(1, tonumber(htosave[1]))
	if enablehouse then
	local i = 1
	while (i <= #htable) do
		local val = htable[i]
		table.remove(val, count)
		table.insert(val, count, "0")
		--table.remove(val, 6)
		--table.insert(val, 6, "0")
		--table.remove(val, 7)
		--table.insert(val, 7, "0")
		table.remove(htable, i)
		table.insert(htable, i, val)
		i = i + 1
		print("SG active. Changing htable field "..i)
	end
	end
	
	if enablehotels then
	local o = 2
	while (o <= #httable) do
		local val = httable[o]
		table.remove(val, count)
		table.insert(val, count, "0")
		table.remove(httable, o)
		table.insert(httable, o, val)
		o = o + 1
		print("SG active. Changing httable field "..o)
	end
	end
	
	if enablecustom then
	local p = 1
	while (p <= #ctable) do
		local val = ctable[p]
		table.remove(val, count)
		table.insert(val, count, "0")
		table.remove(ctable, p)
		table.insert(ctable, p, val)
		p = p + 1
		print("SG active. Changing ctable field "..p)
	end
	end

	if (tp == 1) then
		local num = tonumber(htosave[1])
		local savearray = htable[num]
		table.remove(htosave, count)
		table.insert(htosave, count, "1")
		table.remove(htable, num)
		table.insert(htable, num, htosave)
	elseif (tp == 2) then
		local num = tonumber(httosave[1])
		local savearray = httable[num]
		table.remove(httosave, count)
		table.insert(httosave, count, "1")
		table.remove(httable, num)
		table.insert(httable, num, httosave)
	elseif (tp == 3) then
		local num = tonumber(ctosave[1])
		local savearray = ctable[num]
		table.remove(ctosave, count)
		table.insert(ctosave, count, "1")
		table.remove(ctable, num)
		table.insert(ctable, num, ctosave)
	end
	
	sh.writetofile()
	print("This type "..tp.." place is set as spawn location")
	local hour = TIME.GET_CLOCK_HOURS()
	local minute = TIME.GET_CLOCK_MINUTES()
	CAM.DO_SCREEN_FADE_OUT(250)
	TIME.SET_CLOCK_TIME((hour + sleeptimer), minute, 0)
	GAMEPLAY.SET_SAVE_MENU_ACTIVE(true)
	wait(1000)
	CAM.DO_SCREEN_FADE_IN(250)
	sh.showhint(120,"This place was set as your spawning spot")
	wait(1500)
	stopproxtick = false
	
end

function sh.housebought()

	print("buying house")
	
	local price = tonumber(htosave[12])
	local mod = (sh.whoisplayer() - 1)
	local statname = "SP"..mod.."_TOTAL_CASH"
	local hash = GAMEPLAY.GET_HASH_KEY(statname)
	local bool, cash = STATS.STAT_GET_INT(hash, 0, -1)
	STATS.STAT_SET_INT(hash, (cash - price), true)
	print("Purchased for "..price)
	
	local counter = (sh.whoisplayer() + 1)
	local num = tonumber(htosave[1])
	table.remove(htosave, counter)
	table.insert(htosave, counter, "1")
	table.remove(htosave, 13)
	table.insert(htosave, 13, currentmodel)
	table.remove(htable, num)
	table.insert(htable, num, htosave)
	sh.writetofile()
	sh.showhint(150,"Property bought for $"..price)
		sh.clearblips()
		sh.addblips()
	wait(500)
	stopproxtick = false

	print("house bought")
	
end

function sh.sellhouse()
	sdecision = true
	buttontimer = 200
end

function sh.sellconfirm()
	sh.showhint(150, "Sell this house for $"..htosave[12].."?".."\n".."Press Y to confirm, N to cancel")
	if (get_key_pressed(Keys.Y)) then sh.housesold() sdecision = false buttontimer = 0
	elseif (get_key_pressed(Keys.N)) then 
		sh.showhint(150,"House not sold") sdecision = false buttontimer = 0 wait(750) stopproxtick = false 
	end
	buttontimer = buttontimer - 1
end

function sh.housesold()

	print("selling house")
	
	local price = tonumber(htosave[12])
	local mod = (sh.whoisplayer() - 1)
	local statname = "SP"..mod.."_TOTAL_CASH"
	local hash = GAMEPLAY.GET_HASH_KEY(statname)
	local bool, cash = STATS.STAT_GET_INT(hash, 0, -1)
	STATS.STAT_SET_INT(hash, (cash + price), true)
	print("Sold for "..price)
	local counter = (sh.whoisplayer() + 1)
	table.remove(htosave, counter)
	table.insert(htosave, counter, "0")
	table.remove(htosave, 13)
	table.insert(htosave, 13, "0")
	table.remove(htable, htosave[1])
	table.insert(htable, htosave[1], htosave)
	sh.writetofile()
	sh.showhint(150,"Property sold for $"..price)
		sh.clearblips()
		sh.addblips()
	wait(500)
	stopproxtick = false

	print("house sold")
	
end

local ahtdescr = {}
function sh.hotel()
	
	print("hotel")
	
	stopproxtick = true print("tick stopped")
	--wait(250)
	local counter = (currentmodel + 1)
	local owned = false
	local notowned = false
	local num = tonumber(httosave[1])
	ahtdescr = htdescr[num]
	sh.showhint(150,"Welcome to "..ahtdescr[2])
			
	if (tonumber(httosave[counter])==1) then
	owned = true print("set to owned")
	elseif (tonumber(httosave[counter])==0) then
	notowned = true print("set to not owned")
	end
	
	if owned then
			print("owned")
			local daysleft = 0
			if (currentmodel==1) then daysleft = tonumber(httosave[8])
			elseif (currentmodel==2) then daysleft = tonumber(httosave[10])
			elseif (currentmodel==3) then daysleft = tonumber(httosave[12]) end
			sh.showhint(150,"Welcome to your "..ahtdescr[3]..", "..charactername.."\n".."You have "..daysleft.." days left")
			wait(500)
			--sh.camerawork(2, tonumber(httosave[1]))
			sh.shGUI.hidden = false
			sh.shGUI.buttonCount = 0
			sh.shGUI.addButton("Save Game",sh.savegame,2,0,0.2,0.06,0.06)
			sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.2,0.06,0.06)
	end
	
	if notowned then
		sh.shGUI.hidden = false
		sh.shGUI.buttonCount = 0
		sh.shGUI.addButton("Rent "..ahtdescr[3].." for "..ahtdescr[4].." days",sh.rentshort,nil,0,0.2,0.06,0.06)
		sh.shGUI.addButton("Rent "..ahtdescr[3].." for "..ahtdescr[5].." days",sh.rentlong,nil,0,0.2,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.2,0.06,0.06)	
	end
	
	print("end hotel")
	
end

local renttype = 0
function sh.rentshort()
	sh.shGUI.buttonCount = 0
	sh.shGUI.hidden = true
	htdecisions = true
	renttype = 1
	buttontimer = 200
end

function sh.rentlong()
	sh.shGUI.buttonCount = 0
	sh.shGUI.hidden = true
	htdecisionl = true
	renttype = 2
	buttontimer = 200
end

local durofstay = 0
function sh.hotelchooses()
	
	durofstay = tonumber(ahtdescr[4])
	local rentprice = (durofstay*tonumber(httosave[18]))
	if (not sh.domoneycheck(rentprice)) then sh.showhint(150,"Not enough money") htdecisions = false sh.cancel() end
	wait(50)
	--sh.drawtext
	sh.showhint(150,"Rent this "..ahtdescr[3].."for "..ahtdescr[4].."days?".."\n".."This will cost you $"..rentprice.."\n".."Press Y to confirm, N to cancel")
	if (get_key_pressed(Keys.Y)) then rsconfirm = true htdecisions = false sh.hotelrent()
	elseif (get_key_pressed(Keys.N)) then htdecisions = false sh.cancel()
	end
	buttontimer = buttontimer - 1
end

function sh.hotelchoosel()
	
	durofstay = tonumber(ahtdescr[5])
	local rentprice = (durofstay*tonumber(httosave[18]))
	if (not sh.domoneycheck(rentprice)) then sh.showhint(150,"Not enough money") htdecisionl = false sh.cancel() end
	wait(50)
	sh.showhint(150,"Rent this "..ahtdescr[3].."for "..ahtdescr[5].."days?".."\n".."This will cost you $"..rentprice.."\n".."Press Y to confirm, N to cancel")
	if (get_key_pressed(Keys.Y)) then rlconfirm = false htdecisionl = false sh.hotelrent()
	elseif (get_key_pressed(Keys.N)) then htdecisionl = false sh.cancel() end
	
	buttontimer = buttontimer - 1
end

function sh.hotelrent()

	print("renting room")
	local rcount = 0
	if (currentmodel == 1) then rcount = 8
	elseif (currentmodel == 2) then rcount = 10
	elseif (currentmodel == 3) then rcount = 12 end
	
	table.remove(httosave, rcount)
	table.insert(httosave, rcount, durofstay)
	--table.remove(httosave, (rcount+1))
	--table.insert(httosave, (rcount+1), "0")
	rsconfirm = false
	rlconfirm = false

	local price = (durofstay*tonumber(httosave[18]))
	local mod = (sh.whoisplayer() - 1)
	local statname = "SP"..mod.."_TOTAL_CASH"
	local hash = GAMEPLAY.GET_HASH_KEY(statname)
	local bool, cash = STATS.STAT_GET_INT(hash, 0, -1)
	STATS.STAT_SET_INT(hash, (cash - price), true)
	print("rented for "..price)
	
	local num = tonumber(httosave[1])
	local counter = (currentmodel + 1)
	table.remove(httosave, counter)
	table.insert(httosave, counter, "1")
	table.remove(httable, num)
	table.insert(httable, num, httosave)
	sh.writetofile()
	sh.showhint(150,"Rented for $"..price)
		sh.clearblips()
		sh.addblips()
	wait(500)
	stopproxtick = false

	print("room rented")
	
end

function sh.daypassed()
	print("daypassed")
	local i=2
	while (i <= #httable) do
		local val = httable[i]
		local hot = htdescr[i]
		--local counter = (currentmodel + 1)
		local day1 = tonumber(val[8])-1
		if (tonumber(val[2]) == 1) and (day1 > 0) then
			table.remove(val, 8)
			table.insert(val, 8, day1)
		elseif (tonumber(val[2]) == 1) and (day1 <= 0) then
			sh.showhint(300, "Rent time for Michael at "..hot[2].." has ended".."\n".."We hope you enjoyed your stay. Best wishes!")
			table.remove(val, 8)
			table.insert(val, 8, "0")
			table.remove(val, 2)
			table.insert(val, 2, "0")
		end
		
		local day2 = tonumber(val[10])-1
		if (tonumber(val[3]) == 1) and (day2 > 0) then
			table.remove(val, 10)
			table.insert(val, 10, day2)
		elseif (tonumber(val[3]) == 1) and (day2 <= 0) then
			sh.showhint(300, "Rent time for Franklin at "..hot[2].." has ended".."\n".."We hope you enjoyed your stay. Best wishes!")
			table.remove(val, 10)
			table.insert(val, 10, "0")
			table.remove(val, 3)
			table.insert(val, 3, "0")
		end
		
		local day3 = tonumber(val[12])-1
		if (tonumber(val[4]) == 1) and (day3 > 0) then
			table.remove(val, 12)
			table.insert(val, 12, day3)
		elseif (tonumber(val[4]) == 1) and (day3 <= 0) then
			sh.showhint(300, "Rent time for Trevor at "..hot[2].." has ended".."\n".."We hope you enjoyed your stay. Best wishes!")
			table.remove(val, 12)
			table.insert(val, 12, "0")
			table.remove(val, 4)
			table.insert(val, 4, "0")
		end
		table.remove(httable, i)
		table.insert(httable, i, val)
		sh.writetofile()
		i = i + 1
	end
		sh.clearblips()
		sh.addblips()
	print("daypassed end")
end

function sh.custom()
	cdecision = true
	buttontimer = 200
end

function sh.customconfirm()

	if (not sh.domoneycheck(customcost)) then sh.showhint(150,"Not enough money") cdecision = false stopproxtick = false end
	wait(50)
	sh.showhint(150,"Create a custom safehouse here?".."\n".."This will cost $"..customcost.."\n".."Press Y to confirm or N to cancel")
	if (get_key_pressed(Keys.Y)) then cdecision = false sh.customcreated()
	elseif (get_key_pressed(Keys.N)) then sh.showhint(150,"Creation cancelled") cdecision = false stopproxtick = false end
	buttontimer = buttontimer - 1
end

function sh.customcreated() --сделать обновление спавна

	print("creating custom house")
	
	local chtocreate = {}
	local coord = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
	local heading = ENTITY.GET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID())
	local num = #ctable + 1
	local owner = (currentmodel + 1)
	
	table.insert(chtocreate, 1, num)
	table.insert(chtocreate, 2, "0")
	table.insert(chtocreate, 3, "0")
	table.insert(chtocreate, 4, "0")
	table.insert(chtocreate, 5, "0")
	table.insert(chtocreate, 6, "0")
	table.insert(chtocreate, 7, "0")
	table.insert(chtocreate, 8, coord.x)
	table.insert(chtocreate, 9, coord.y)
	table.insert(chtocreate, 10, coord.z)
	table.insert(chtocreate, 11, heading)
	table.insert(chtocreate, 12, currentmodel)
	table.insert(chtocreate, 13, "1")
	table.remove(chtocreate, owner)
	table.insert(chtocreate, owner, "1")
	print("chtocreate table created")
	
	table.insert(ctable, num, chtocreate)
	sh.writetofile()
	
	local mod = (currentmodel - 1)
	local statname = "SP"..mod.."_TOTAL_CASH"
	local hash = GAMEPLAY.GET_HASH_KEY(statname)
	local bool, cash = STATS.STAT_GET_INT(hash, 0, -1)
	STATS.STAT_SET_INT(hash, (cash - 750000), true)
	
	sh.showhint(150,"Custom safehouse created")
		sh.clearblips()
		sh.addblips()
	wait(500)
	stopproxtick = false

	print("house created")
	
end

function sh.customsh()
	
	print("custom safehouse")

	stopproxtick = true 
	print("tick stopped")
	local counter = (currentmodel + 1)
	print(counter)
	local owned = false
	local notowned = false
	
	if (tonumber(ctosave[counter])==1) then
	owned = true print("set to owned")
	elseif (tonumber(ctosave[counter])==0) then
	notowned = true print("set to not owned")
	end
	
	if owned then
			print("owned")
			sh.showhint(150,"Welcome Home, "..charactername)
			wait(500)
			--sh.camerawork(1, tonumber(ctosave[1]))
			sh.shGUI.hidden = false
			sh.shGUI.buttonCount = 0
			sh.shGUI.addButton("Save Game",sh.savegame,3,0,0.2,0.06,0.06)
			sh.shGUI.addButton("Remove this house",sh.cremove,nil,0,0.2,0.06,0.06)
			sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.2,0.06,0.06)
	end
	
	if notowned then
		sh.showhint(150,"This custom savehouse is not owned by "..charactername)
	end
	
	print("end custom safehouse")
end

function sh.cremove()
	
	print("remove csh")
	local num = tonumber(ctosave[1])
	
	table.remove(ctosave, 13)
	table.insert(ctosave, 13, "0")
	table.remove(ctable, num)
	table.insert(ctable, num, ctosave)
	sh.writetofile()
		sh.clearblips()
		sh.addblips()
	print("csh removed")
	sh.cancel()
	
end
	
function sh.writetofile()                              -- не забудь убрать _written
	print("writetofile")
	
	if enablehouse then
	local file = io.open(savepath .. "savehouses", "w")
	io.output(file)
	for a, v in ipairs(htable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
		print("Writing to file savehouses line "..a)
		
	end
	io.close(file)
	end
	
	if enablehotels then
		local sfile = io.open(savepath .. "hotels", "w")
		io.output(sfile)
		for a, v in ipairs(httable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
		print("Writing to file hotels line "..a)
		
	end
	io.close(sfile)
	end
	
	if enablecustom then
		local nfile = io.open(savepath .. "custom", "w")
		io.output(nfile)
		for a, v in ipairs(ctable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
		print("Writing to file custom line "..a)
		
	end
	io.close(nfile)
	end
	
	sh.loadfiles()
	print("writetofile done")
end

function sh.domoneycheck(sum)

		local summa = tonumber(sum)
		local mod = (sh.whoisplayer() - 1)
		local statname = "SP"..mod.."_TOTAL_CASH"
		local hash = GAMEPLAY.GET_HASH_KEY(statname)
		local bool, cash = STATS.STAT_GET_INT(hash, 0, -1)
		print("Player Money: "..cash..", sum needed: "..summa)
		if (cash >= summa) then return true else return false end
		print("Money check finished, returning")
end

function sh.filecheck()
	
	if sh.checkdir() then print("checkdir is not nil")
		local f1 = io.open(savepath .. "savehouses", "r")
		if f1==nil then if enablehouse then sh.filemakehouse() end else io.close(f1) end
		local f2 = io.open(savepath .. "hotels", "r")
		if f2==nil then if enablehotels then sh.filemakehotel() end else io.close(f2) end
		local f3 = io.open(savepath .. "custom", "r")
		if f3==nil then if enablecustom then sh.filemakecustom() end else io.close(f3) end
	else
		allowmod = false
		dirok = false
	end
end

function sh.checkdir()
print("checkdir")
	local file = io.open(savepath .. "dircheck", "w")
	if file==nil then io.close(file) return false
	else io.close(file) return true end
	--io.output(file)
	--io.write(vdata .. "\n")
	
print("checkdir end")
end

function sh.camerawork(tp,num) --Not active for now
	local ch = {{1,-1071.3858642578,-1152.3472900391,2.1586000919342,231.56045532227},
	{2,-1121.0716552734,-929.57745361328,2.6956255435944,262.25646972656},
	{3,-1098.9903564453,-1558.0343017578,4.401261806488,257.66412353516},
	{4,-1969.1273193359,604.82696533203,120.10601043701,100.11582946777},
	{5,103.19570159912,-1950.3481445313,20.688735961914,218.44581604004},
	{6,337.00057983398,-1758.0522460938,28.956785202026,27.689207077026},
	{7,1236.7208251953,-1610.1746826172,52.248043060303,195.8524017334},
	{8,1005.369934082,-526.427734375,60.40735244751,349.55795288086},
	{9,1335.1306152344,-575.22283935547,73.943130493164,127.19316864014},
	{10,69.248184204102,-295.72772216797,47.04935836792,311.19760131836},
	{11,154.6618347168,82.718048095703,84.240371704102,216.75062561035},
	{12,-467.53112792969,672.4658203125,147.48956298828,149.25149536133}
	}
	local cht = {
	}
	
	--local camera = {}
	local cam = {}
	if (tp==1) then cam = ch[num] end
	if (tp==2) then cam = cht[num] end
	if (tp==3) then cam = cch[num] end
	CONTROLS.DISABLE_ALL_CONTROL_ACTIONS(2)
	--CAM.DO_SCREEN_FADE_OUT(250)
	ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),faraway[1], faraway[2], faraway[3],true,true,true,true)
	--CAM.CREATE_CAM(cam1, true)
	local cam1 = CAM.SET_CAM_COORD(1,cam[2],cam[3],cam[4])
	CAM.SET_GAMEPLAY_CAM_RELATIVE_HEADING(cam1,cam[5])
	--CAM.DO_SCREEN_FADE_IN(250)
	wait(5000)
	sh.spawnplayer(tp,array)
	CONTROLS.ENABLE_CONTROL_ACTION(2,0,true)
	
	
end

function sh.filemakehouse() ---------------------------------убрать спавн!
	print("making house")
	--local h = {{1, 0,0,0, 0,1,0,-1063.7385253906,-1159.8004150391,2.3458766937256,24.428289413452,280000,0}, --Vesp Channels
	--{2, 0,0,0, 1,0,0,-1090.7722167969,-926.11767578125,3.1406140327454,31.203266143799,450000,0}, --Vesp Channels
	--{3, 0,0,0, 0,0,0,-1085.1437988281,-1558.2083740234,4.4977512359619,39.944465637207,720000,0}, --Vesp Beach
	--{4, 0,0,0, 0,1,0,-1996.1871337891,591.07659912109,118.1019744873,245.96002197266,1650000,0}, --W V Hills
	--{5, 0,0,0, 0,0,0,114.04767608643,-1961.1394042969,21.334177017212,33.8977394104,180000,0}, --Gr Str
	--{6, 0,0,0, 0,0,0,332.92190551758,-1741.6259765625,29.730527877808,192.81414794922,320000,0}, --Near Gr Str
	--{7, 0,0,0, 0,1,0,1245.4300537109,-1626.6199951172,53.282196044922,31.311986923218,300000,0}, --El Burro
	--{8, 0,0,0, 0,0,0,1006.256652832,-511.13861083984,60.833992004395,153.93867492676,840000,0}, --Mirror Park
	--{9, 0,0,0, 0,1,0,1323.3957519531,-582.88482666016,73.246383666992,346.30725097656,1200000,0}, --Mirror Park new
	--{10, 0,0,0, 0,0,0,97.582374572754,-255.97975158691,47.489917755127,16.740756988525,160000,0}, --Alta, apt
	--{11, 0,0,0, 0,1,0,178.92713928223,44.210914611816,87.822509765625,162.22875976563,220000,0}, --Down V
	--{12, 0,0,0, 0,0,0,-476.58337402344,647.99664306641,144.38670349121,2.0846719741821,1400000,0} --V Hills --Redo
	--}

	local mkhtable = {}
	local i = 1
	while (i <= #h) do
		table.insert(mkhtable, h[i])
		i = i + 1
	end
	print("mkhtable"..#mkhtable)
	local file = io.open(savepath .. "savehouses", "w")
	io.output(file)
	for a, v in ipairs(mkhtable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
	end
	print("file created - h")
	io.close(file)

end

function sh.updateh()
	print("updating house")
	local updtable = {}
	if (#h > #htable) then
			print(#h.." > "..#htable)
			local counter = (#htable + 1)
			while (counter <= #h) do
				table.insert(updtable, h[counter])
				print("doing while, counter="..counter)
				counter = counter + 1
			end
		local file = io.open(savepath .. "savehouses", "a")
		io.output(file)
		for a, v in ipairs(updtable) do
			local vdata = sh.tostring(v)
			io.write(vdata .. "\n")
		end
		io.close(file)
		sh.loadfiles()
		else print("house up to date")
	end
	
	if (tonumber(htable[1][14])==nil) then
		print("updating interiors")
		local i = 1
		while (i <= #htable) do
			local houserow = h[i]
			local hrow = htable[i]
			if (hrow[14] == nil) then
				table.insert(hrow, 14, tonumber(houserow[14]))
				table.remove(htable, i)
				table.insert(htable, i, hrow)
			end
			i = i + 1
		end
		sh.writetofile()
	end
	hupdated = true
	print("updating house done")
	
end

function sh.updateht()
	print("updating hotel")
	local updtable = {}
	if (#ht > #httable) then
		print(#ht.." > "..#httable)
		local counter = (#httable + 1)
		while (counter <= #ht) do
			table.insert(updtable, ht[counter])
			print("doing while, counter="..counter)
			counter = counter + 1
		end
	local file = io.open(savepath .. "hotels", "a")
	io.output(file)
	for a, v in ipairs(updtable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
	end
	io.close(file)
	else print("hotel up to date")
	end
	htupdated = true
	print("updating hotel done")
	sh.loadfiles()
end
	
function sh.filemakehotel()

	local mkhottable = {}
	local i = 1
	while (i <= #ht) do
		table.insert(mkhottable, ht[i])
		i = i + 1
	end
	print("mkhottable"..#mkhottable)
	local file = io.open(savepath .. "hotels", "w")
	io.output(file)
	for a, v in ipairs(mkhottable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
	end
	print("file created - hot")
	io.close(file)

end

function sh.filemakecustom()

	local c = {{1, 1,0,0, 0,0,0,-1066.7385253906,-1152.8004150391,2.3458766937256,24.428289413452,1,0},
	}
	local mkctable = {}
	local i = 1
	while (i <= #c) do
		table.insert(mkctable, c[i])
		i = i + 1
	end
	print("mkctable"..#mkctable)
	local file = io.open(savepath .. "custom", "w")
	io.output(file)
	for a, v in ipairs(mkctable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
	end
	print("file created - cus")
	io.close(file)

end

function sh.loadfiles()
	print("loadfiles")
	htable = {}
	httable = {}
	ctable = {}
	
	if enablehouse then
		for line in io.open(savepath .. "savehouses", "r"):lines() do
		sh.getarrayh(line)
		end
	end
	
	if enablehotels then
		for line in io.open(savepath .. "hotels", "r"):lines() do
		sh.getarrayht(line)
		end
	end
	
	if enablecustom then
		for line in io.open(savepath .. "custom", "r"):lines() do
		sh.getarrayc(line)
		end
	end
	
	if updatehouses and (not hupdated) then sh.updateh() end
	if updatehotels and (not htupdated) then sh.updateht() end
	
	print("files loaded")
	
end

function sh.getarrayh(str)
	local vals = {}
	for val in string.gmatch(str, '[^,]+') do
		table.insert(vals, val)
	end
	table.insert(htable, vals)
	print("entries in htable:"..#htable)
end

function sh.getarrayht(str)
	local vals = {}
	for val in string.gmatch(str, '[^,]+') do
		table.insert(vals, val)
	end
	table.insert(httable, vals)
	print("entries in httable:"..#httable)
end

function sh.getarrayc(str)
	local vals = {}
	for val in string.gmatch(str, '[^,]+') do
		table.insert(vals, val)
	end
	table.insert(ctable, vals)
	print("entries in ctable:"..#ctable)
end

function sh.val_to_str (v)
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '' .. string.gsub(v,'"', '\\"' ) .. ''
  else
    return "table" == type( v ) and sh.tostring( v ) or
      tostring( v )
  end
end

function sh.key_to_str (k)
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. sh.val_to_str( k ) .. "]"
  end
end

function sh.tostring (tbl)
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, sh.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        sh.key_to_str( k ) .. "=" .. sh.val_to_str( v ) )
    end
  end
  return table.concat( result, "," )
end

function sh.whoisplayer()

	local model = 0
	if (PED.IS_PED_MODEL(PLAYER.PLAYER_PED_ID(), GAMEPLAY.GET_HASH_KEY("player_zero"))) then model = 1 charactername = "Michael"
	elseif (PED.IS_PED_MODEL(PLAYER.PLAYER_PED_ID(), GAMEPLAY.GET_HASH_KEY("player_one"))) then model = 2 charactername = "Franklin"
	elseif (PED.IS_PED_MODEL(PLAYER.PLAYER_PED_ID(), GAMEPLAY.GET_HASH_KEY("player_two"))) then model = 3 charactername = "Trevor"
	end
	return model
	
end

function sh.checkspawn()

	print("checking spawn")
	local counter = (currentmodel + 4)
	local stopper = false
	
	if enablehouse then
		local i = 1
		while (i <= #htable) do
			local vdata = htable[i]
			if (tonumber(vdata[counter])==1) then 
				stopper = true
				sh.spawnplayer(1, htable[i])
				break
			elseif tonumber(vdata[counter])==0 then 
				i = i + 1 
			end
		end
	end
	
	if enablehotels then
		local i = 2
		while (i <= #httable) do
			local vdata = httable[i]
			if (tonumber(vdata[counter])==1) then 
				stopper = true
				sh.spawnplayer(2, httable[i])
				break
			elseif tonumber(vdata[counter])==0 then 
				i = i + 1 
			end
		end
	end

	
	if enablecustom then
		local i = 1
		while (i <= #ctable) do
			local vdata = ctable[i]
			if (tonumber(vdata[counter])==1) then 
				sh.spawnplayer(1, ctable[i])
				break
			elseif tonumber(vdata[counter])==0 then 
				i = i + 1 
			end
		end
	end
	
	print("checkspawn finished")
	
end
	
function sh.spawnplayer(sptype, array)
	
	--CAM.DO_SCREEN_FADE_OUT(250)
	print("spawnplayer")
	CAM.DO_SCREEN_FADE_OUT(250)
	wait(500)
	if (sptype == 1) then print("1")
		ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(array[8]), tonumber(array[9]), tonumber(array[10]),true,true,true,true)
		ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(array[11]))
		TIME.SET_CLOCK_TIME(spawnhour, spawnminute, 0)
	elseif (sptype == 2) then print("2")
		ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(array[14]), tonumber(array[15]), tonumber(array[16]),true,true,true,true)
		ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(array[17]))
		TIME.SET_CLOCK_TIME(spawnhour, spawnminute, 0)
	end
	tickcooldown = 200
	wait(500)
	CAM.DO_SCREEN_FADE_IN(250)
	print("spawnplayer end")
end

local hinttoshow = "SAFEHOUSE MOD LOADED"

function sh.showhint(tmr, text)
	timer = tmr
	hinttoshow = text
end

function sh.drawhint()
	UI.SET_TEXT_FONT(0)
	UI.SET_TEXT_SCALE(0.2, 0.6)
	UI.SET_TEXT_COLOUR(255, 255, 255, 255)
	UI.SET_TEXT_WRAP(0, 1)
	UI.SET_TEXT_CENTRE(true)
	UI.SET_TEXT_DROPSHADOW(15, 15, 0, 0, 0)
	UI.SET_TEXT_EDGE(5, 0, 0, 0, 255)
	UI._SET_TEXT_ENTRY("STRING")
	UI._ADD_TEXT_COMPONENT_STRING(hinttoshow)
	UI._DRAW_TEXT(0.5, 0.3)
	timer = timer-1
end

local bliptable = {}

local blip = {}
local shblip = {}
local phblip = {}
local ohblip = {}
local ahtblip = {}
local ohtblip = {}
local cblip = {}
local forrent = {}
local rented = {}

function sh.addblips()
	print("adding blips")
	
	bliptable = {}
	--blip = {}
	shblip = {}
	phblip = {}
	ohblip = {}
	ahtblip = {}
	ohtblip = {}
	cblip = {}
	forrent = {}
	rented = {}
	
	if enablehouseblips and enablehouse then
		local a = 1
		while (a <= #htable) do
			local tbl = htable[a]
			if (tonumber(tbl[13])==currentmodel) then
				table.insert(shblip, {tonumber(tbl[8]), tonumber(tbl[9]), tonumber(tbl[10])})
			elseif (tonumber(tbl[13])==0) then
				table.insert(phblip, {tonumber(tbl[8]), tonumber(tbl[9]), tonumber(tbl[10])})
			elseif (tonumber(tbl[13])~=0) and (tonumber(tbl[13])~=currentmodel) then
				table.insert(ohblip, {tonumber(tbl[8]), tonumber(tbl[9]), tonumber(tbl[10])})
				
			end
			a = a + 1
		end

		for i, coord in ipairs(shblip) do
			blip[i] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
			UI.SET_BLIP_SPRITE(blip[i], 40)
			UI.SET_BLIP_SCALE(blip[i], blipsize)
			UI.SET_BLIP_AS_SHORT_RANGE(blip[i], true)
			table.insert(bliptable, (#bliptable+1), blip[i])
		end
		
		for i, coord in ipairs(phblip) do
			blip[i] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
			UI.SET_BLIP_SPRITE(blip[i], 350)
			UI.SET_BLIP_SCALE(blip[i], blipsize)
			UI.SET_BLIP_AS_SHORT_RANGE(blip[i], true)
			table.insert(bliptable, (#bliptable+1), blip[i])
		end
		
		for i, coord in ipairs(ohblip) do
			local j = i + 1
			blip[i] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
			UI.SET_BLIP_SPRITE(blip[i], 350)
			UI.SET_BLIP_SCALE(blip[i], blipsize)
			UI.SET_BLIP_AS_SHORT_RANGE(blip[i], true)
			blip[j] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
			UI.SET_BLIP_SPRITE(blip[j], 163)
			UI.SET_BLIP_SCALE(blip[j], (blipsize-0.1))
			UI.SET_BLIP_AS_SHORT_RANGE(blip[j], true)
			table.insert(bliptable, (#bliptable+1), blip[i])
			table.insert(bliptable, (#bliptable+1), blip[j])
		end
	end
	
	if enablehotelblips and enablehotels then
		local b = 2
		while (b <= #httable) do
			local tbl = httable[b]
			local counter = (currentmodel + 1)
			if (tonumber(tbl[counter])==1) and (tonumber(tbl[19])==1) then
				table.insert(ahtblip, {tonumber(tbl[14]), tonumber(tbl[15]), tonumber(tbl[16])})
			elseif (tonumber(tbl[counter])==0) and (tonumber(tbl[19])==1) then
				table.insert(ohtblip, {tonumber(tbl[14]), tonumber(tbl[15]), tonumber(tbl[16])})
			end
			b = b + 1
		end
		
		for i, coord in ipairs(ahtblip) do
			local j = i + 1
			blip[i] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
			UI.SET_BLIP_SPRITE(blip[i], 417)
			UI.SET_BLIP_SCALE(blip[i], blipsize)
			UI.SET_BLIP_AS_SHORT_RANGE(blip[i], true)
			blip[j] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
			UI.SET_BLIP_SPRITE(blip[j], 431)
			UI.SET_BLIP_SCALE(blip[j], (blipsize - 0.1))
			UI.SET_BLIP_AS_SHORT_RANGE(blip[j], true)
			table.insert(bliptable, (#bliptable+1), blip[i])
			table.insert(bliptable, (#bliptable+1), blip[j])
		end
		
		for i, coord in ipairs(ohtblip) do
			blip[i] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
			UI.SET_BLIP_SPRITE(blip[i], 417)
			UI.SET_BLIP_SCALE(blip[i], blipsize)
			UI.SET_BLIP_AS_SHORT_RANGE(blip[i], true)
			table.insert(bliptable, (#bliptable+1), blip[i])
		end
		
	end
	
	if enablehotelblips and enablehotels then
		local d = 2
		while (d <= #httable) do
			local tbl = httable[d]
			local counter = (currentmodel + 1)
			if (tonumber(tbl[counter])==1) and (tonumber(tbl[19])==2) then
				table.insert(rented, {tonumber(tbl[14]), tonumber(tbl[15]), tonumber(tbl[16])})
			elseif (tonumber(tbl[counter])==0) and (tonumber(tbl[19])==2) then
				table.insert(forrent, {tonumber(tbl[14]), tonumber(tbl[15]), tonumber(tbl[16])})
			end
			d = d + 1
		end
		
		for i, coord in ipairs(rented) do
			local j = i + 1
			blip[i] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
			UI.SET_BLIP_SPRITE(blip[i], 411)
			UI.SET_BLIP_SCALE(blip[i], blipsize)
			UI.SET_BLIP_AS_SHORT_RANGE(blip[i], true)
			blip[j] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
			UI.SET_BLIP_SPRITE(blip[j], 431)
			UI.SET_BLIP_SCALE(blip[j], (blipsize - 0.1))
			UI.SET_BLIP_AS_SHORT_RANGE(blip[j], true)
			table.insert(bliptable, (#bliptable+1), blip[i])
			table.insert(bliptable, (#bliptable+1), blip[j])
		end
		
		for i, coord in ipairs(forrent) do
			blip[i] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
			UI.SET_BLIP_SPRITE(blip[i], 411)
			UI.SET_BLIP_SCALE(blip[i], blipsize)
			UI.SET_BLIP_AS_SHORT_RANGE(blip[i], true)
			table.insert(bliptable, (#bliptable+1), blip[i])
		end
	end
	
	if enablecustomblips and enablecustom then
		local c = 1
		while (c <= #ctable) do
			local tbl = ctable[c]
			if (tonumber(tbl[12])==currentmodel) and (tonumber(tbl[13])==1) then
				table.insert(cblip, {tonumber(tbl[8]), tonumber(tbl[9]), tonumber(tbl[10])})
			end
			c = c + 1
		end
		
		for i, coord in ipairs(cblip) do
			blip[i] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
			UI.SET_BLIP_SPRITE(blip[i], 40)
			UI.SET_BLIP_SCALE(blip[i], blipsize)
			UI.SET_BLIP_AS_SHORT_RANGE(blip[i], true)
			table.insert(bliptable, (#bliptable+1), blip[i])
		end
	end
	
	print("shblip"..#shblip)
	print("phblip"..#phblip)
	print("ohblip"..#ohblip)
	print("ahtblip"..#ahtblip)
	print("ohtblip"..#ohtblip)
	print("forrent"..#forrent)
	print("rented"..#rented)
	print("cblip"..#cblip)
	print("bliptable "..#bliptable)
	
end

function sh.clearblips()

	print("clearing blips")
	local i = 1
	while (i <= #bliptable) do
		UI.REMOVE_BLIP(bliptable[i])
		print("remove blip "..bliptable[i])
		i=i+1
	end
	wait(500)
	print("blips cleared")
	
end

function sh.cancel()
	sh.shGUI.buttonCount = 0
	sh.shGUI.hidden = true
	wait(1000)
	stopproxtick = false
end
	
return sh
