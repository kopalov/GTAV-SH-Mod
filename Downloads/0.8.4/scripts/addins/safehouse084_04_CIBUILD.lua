-------------------------------------------------------------------------------------
--------------------------------Version 0.8.4 build 4--------------------------------
-------------------------------------------------------------------------------------
-------------------Created by Kopalov with help from Henny Smafter-------------------
-------------------------------------------------------------------------------------
------------------------------- !!! IMPORTANT !!! -----------------------------------
------------ CHANGE to some folder on your PC (Which is not read-only). -------------
-------------------------------------------------------------------------------------

local savepath = "D:/% WinDoc/Rockstar Games/2/"
-- For example, "C:/Users/Johny/Documents/Rockstar Games/GTA V/GTA5_Housemod/"

-------------------------------------------------------------------------------------
------------------------------------ MOD OPTIONS ------------------------------------
-------------------------------------------------------------------------------------

local allowmod = true             -- Set to false to turn this mod OFF.

local enablehouse = true          -- Set to false if you don't want default safehouses.
local enablecustom = true         -- Set to false if you don't want to be able to manually add savehouses.
local enablehotels = true         -- Set to false if you don't want hotels and apartments for rent.

local enablecustomblips = true    -- If 'true', shows Custom Safehouse blips on the map. Set to 'false' to disable.
local enablehotelblips = true     -- If 'true', shows Hotel blips on the map. Set to 'false' to disable.
local blipsize = 0.7              -- Blip size. Increase or decrease for your taste. Default is 0.8
local spawnhour = 6               -- Clock hour at which you will be spawned on game load.
local spawnminute = 0             -- Clock minute at which you will be spawned on game load.
local mkcustomkey = 97            -- Key to create a custom safehouse. (See key reference below)
local mkblipsoff = 103            -- Key to disable all blips. (See key reference below)
local mkblipson = 105             -- Key to enable all blips. (See key reference below)
local customcost = 750000         -- How much does custom safehouse creation cost.
local sleeptimer = 6              -- How many hours does time advances when you save your game.
local updatehouses = true         -- If enabled, updates your safehouse savefile, adding more houses. All previous data remains in its place.
local updatehotels = true	      -- If enabled, updates your hotel savefile, adding more hotels. All previous data remains in its place.

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
-------------------------------------------------------------------------------------
-- DO NOT EDIT ANYTHING BELOW UNLESS YOU ARE 100% SURE YOU KNOW WHAT YOU ARE DOING --
-------------------------------------------------------------------------------------

local enablehouseblips = true
local hupdated = false
local htupdated = false

local sh = {}
local timer = 0
local buttontimer = 0
local price = 0
local textstay = false
local playercash = 0
local currentmodel = 0
local showtext = false

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

------------if you have blinking text issue re-enter and exit house properly

    ------------------------------------------------------------------Hotel----------------------------------------------------------------------------------
local interior = {{1,151.4981842041,-1008.05859375,-99.000015258789,336.45590209961, 154.34252929688,-1003.2754516602,-98.999961853027,248.35888671875,50000,155.10707092285,-1007.4459228516,-98.333366394043,24.381214141846},--hotel room
	{2,-1003.2720947266,-478.08227539063,51.026782989502,102.60227966309,-1005.7172851563,-474.99221801758,50.026264190674,0.11998824775219,100000,-1010.6307983398,-478.1389465332,51.02668762207,264.74740600586},--Movie makers cabinet
	-------------------------------------------------------------------Low---------------------------------------------------------------------------------------------
	{3,-107.83421325684,-8.3598766326904,70.519630432129,97.708541870117, -111.13466644287,-10.718485832214,70.519622802734,14.13726234436,250000,-107.83421325684,-8.3598766326904,70.519630432129,97.708541870117},--basic apartment(janitor)
	{4,266.04748535156,-1003.8999023438,-99.004898071289,354.51895141602, 262.90921020508,-1003.1085205078,-99.008575439453,243.61944580078,320000,265.70941162109,-999.93121337891,-99.00862121582,70.977752685547},--small house
	{5,1274.1540527344,-1719.6486816406,54.771457672119,15.826478004456, 1276.2813720703,-1714.5952148438,55.081481933594,238.12216186523,340000,1275.1337890625,-1715.3297119141,54.771446228027,10.003523826599},--Lester's house
	-------------------------------------------------------------------Mid---------------------------------------------------------------------------------------------
	{6,346.99029541016,-1011.2156982422,-99.196182250977,359.0266418457,349.33096313477,-995.07049560547,-99.196182250977,107.60055541992,450000,345.10482788086,-994.36376953125,-99.196258544922,135.84480285645},--Mid class apartment
	{7,-1151.0661621094,-1520.5487060547,10.632719993591,14.21820640564, -1149.865,-1512.601,10.633,14.21820640564,550000,-1155.6005859375,-1517.7932128906,10.632719039917,159.17674255371},--Floyd's house
	-------------------------------------------------------------------High--------------------------------------------------------------------------------------------
	{8,-782.18969726563,326.029296875,223.25765991211,192.2679901123, -759.6259765625,319.87289428711,217.05030822754,253.18368530273,1250000,-774.22766113281,319.80389404297,223.25765991211,273.13580322266},--Eclypse tower
	{9,1391.1628417969,1131.9582519531,114.33359527588,290.05145263672, 1396.9998779297,1130.5531005859,114.33359527588,172.71952819824,2500000,1398.8028564453,1151.7904052734,114.33359527588,180.85752868652}--Madrazo villa
	-----------------------------------------------------------------Inactive------------------------------------------------------------------------------------------
	--{5,-1904.3238525391,-573.31024169922,19.097219467163,99.215171813965, -1912.2564697266,-569.91326904297,19.097219467163,161.91348266602},--Psychologist's office
	}


local h = {{1, 0,0,0, 0,0,0,2219.9113769531,3303.9201660156,49.316745758057,59.738510131836,49500,0,1,2219.6274414063,3303.9289550781,48.042812347412,60.842864990234},
{2, 0,0,0, 0,0,0,-982.93597412109,-1052.3619384766,11.309672355652,240.98684692383,295000,0,4,-986.86535644531,-1053.2769775391,9.9458589553833,254.20620727539},
{3, 0,0,0, 0,0,0,1442.1264648438,3666.2436523438,40.684062957764,148.15408325195,75000,0,5,1440.875,3665.5278320313,40.244132995605,143.5451965332},
{4, 0,0,0, 0,0,0,-1013.5612182617,-927.21166992188,8.8061809539795,356.39025878906,505000,0,6,-1010.3648681641,-928.23962402344,5.7836542129517,4.5285291671753},
{5, 0,0,0, 0,0,0,2166.3291015625,3356.7763671875,48.366123199463,76.901626586914,25750,0,1,2166.2861328125,3354.8325195313,47.446857452393,64.41512298584},
{6, 0,0,0, 0,0,0,-1090.4608154297,-926.64636230469,3.1047008037567,212.1895904541,595000,0,7,-1114.2384033203,-929.25219726563,15.124973297119,253.5005645752},
{7, 0,0,0, 0,0,0,-1037.1337890625,-1605.3999023438,4.9747915267944,222.46809387207,720000,0,6,-1014.2494506836,-1616.1507568359,12.44374370575,65.548736572266},
{8, 0,0,0, 0,0,0,-1117.0482177734,-1505.7077636719,4.3962988853455,28.927146911621,645000,0,7,-1141.1461181641,-1494.2581787109,10.537920951843,249.11920166016},
{9, 0,0,0, 0,0,0,-1337.673828125,-1161.4385986328,4.5055766105652,110.89149475098,600000,0,6,-1357.2694091797,-1171.0169677734,13.028377532959,298.44976806641},
{10, 0,0,0, 0,0,0,1830.8414306641,3737.7463378906,33.961898803711,107.97627258301,125000,0,5,1820.4450683594,3716.3210449219,36.933704376221,343.22918701172}
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
	{26,"Motel Wisdahl","room",3,5},
	{27,"Templar Hotels","room",1,3},
	{28,"Hedera Apartment Rent","apartment",7,30},
	{29,"Perrera Beach Motel","room",2,5},
	{30,"Crastenburg Hotels & Resorts","room",2,5},
	{31,"Banner Hotel & Spa","room",2,5},
	{32,"Crastenburg Hotel","room",1,3},
	{33,"Rockford Dorset","room",2,5},
	{34,"The Pink Cage Motel","room",2,5},
	{35,"Apartment Rent","apartment",7,30},
	{36,"Apartment Rent","apartment",7,30},
	{37,"Apartment Rent","apartment",7,30},
	{38,"Hotel","room",2,5},
	{39,"Centry Manor Hotel","house",5,10},
	{40,"The Richman Hotel","room",2,5},
	{41,"Marlowe Vineyard","room",1,2},
	{42,"Dream View Motel","room",3,5},
	{43,"The Motor Hotel","room",2,5},
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
	{26, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 57.467880249023,-1004.7907104492,29.357431411743,359.03179931641, 100, 1},--110 Motel Wisdahl 2 c111
	{27, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 288.04669189453,-1094.8298339844,29.419662475586,91.308853149414, 140, 1},--114 Templar Hotels 2 c115
	{28, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},--143 app rent Hedera c144
	{29, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1454.5185546875,-656.00653076172,33.381237030029,45.131774902344, 90, 1},--147 Perrera Beach Motel c148
	{30, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1545.7017822266,-530.62066650391,36.148220062256,33.43384552002, 250, 1},--151 Crastenburg Hot&Res c152
	{31, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1660.6646728516,-533.94842529297,36.023990631104,138.85432434082, 140, 1},--160 banner hotel & spa 3 c161
	{32, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1857.1146240234,-348.12091064453,49.837738037109,148.86190795898, 280, 1},--166 Crastenburg Hot 1 c167
	{33, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -570.39379882813,-395.46960449219,35.037891387939,357.26895141602, 200, 1},--185 h? Rockford Dorset c186
	{34, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 340.90374755859,-214.79853820801,58.019241333008,103.72160339355, 100, 1},--79 Motel 3 The Pink Cage c80
	{35, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -904.55102539063,588.05395507813,101.19079589844,124.93965911865, 25, 2},--179 h 9 vw hills c180
	{36, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -385.11584472656,159.71208190918,73.733001708984,150.53001403809, 20, 2},--191 h rent 8 c192
	{37, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -336.16714477539,30.917057037354,47.858982086182,88.831214904785, 40, 2},--193 h rent 6 c194
	{38, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -273.9186706543,28.600929260254,54.752494812012,251.64653015137, 120, 2},--195 h vvw 3 c 196
	{39, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -34.174911499023,347.9462890625,113.99765777588,167.380859375, 180, 1},--197 h 2 Centry Manor c198
	{40, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1273.7852783203,315.96365356445,65.511772155762,149.59870910645, 220, 1},--199 h1 The Richman Hotel c200
	{41, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1886.5815429688,2050.2531738281,140.98083496094,192.25430297852, 100, 2},--211 hrent2 Marlowe Vineyard c212
	{42, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -107.40759277344,6339.9702148438,35.500743865967,231.78079223633, 80, 1},--213 h3 Dream View Motel c214
	{43, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 1136.5635986328,2641.6394042969,38.143707275391,27.30855178833, 75, 1}--Motor hotel c237
	}

local realtors = {{-943.048,-278.801,39.5951}, --Highend Class Dorset Drive
	{-468.909,-670.083,-32.417}, --Medium Class 7302 San Andreas Avenue
	{418.751,-693.695,29.3736}, --Low Class 377-773 Swiss Street
	{905.94171142578,3586.1865234375,33.54550552368}, --Countryside L,T,TR Grand Senora Street
	{-41.9243,6472.59,31.5017} --Countryside L,M,H Paleto Blvd.
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


local dialogactive = false
local exittype = 0
local exitdelay = 100
local enterdialog = false
local typetoenter = 0
local insidetick = 0

local isinside = false
local isatrealtor = false
function sh.tick()

	local playerdriving = PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), true)
	local playerwanted = PLAYER.GET_PLAYER_WANTED_LEVEL(PLAYER.PLAYER_ID())
	local player = PLAYER.PLAYER_PED_ID()
	local playerped = PLAYER.GET_PLAYER_PED(player)

	if (timer > 1) then timer = timer - 1 sh.drawhint() end
	if (not dirok) and (not CAM.IS_SCREEN_FADED_OUT()) then
		sh.showhint(700,"Something is wrong with your save directory.".."\n".."Make sure you edited script file.".."\n".."Safehouse Mod OFF")
		dirok = true
	end

	if allowmod then

	if (get_key_pressed(Keys.Backspace)) then --and (not sh.shGUI.hidden) then
		print("backspace pressed")
		sh.cancel()
	end

	if (tickcooldown > 0) then
		stopproxtick = true
		tickcooldown = tickcooldown - 1
	else stopproxtick = false --print("proxtick resumed by timer")
	end

	if (not isatrealtor) then
		sh.checkifinside() end

	if isinside and (not dialogactive) and (not isatrealtor) then
		sh.looksave()
	end

	if (insidetick>0) then insidetick=insidetick-1 end

	if isinside and (not dialogactive) and (not isatrealtor) then
		sh.lookexit()
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
		sh.getproximityh()
		sh.getproximityht()
		sh.getproximityc()
		sh.getproximityr()
	end

	if (get_key_pressed(mkcustomkey)) then
		sh.custom()
	end

	if enablehotels then------------------------------------Remove on-screen notification in release--------------------------------------------------------------
		local currentday = TIME.GET_CLOCK_DAY_OF_MONTH()
		if (currentday > initialday) then
		sh.daypassed()
		sh.showhint(125,"Day passed by..."..currentday.." - "..initialday)----------------------Debug tool. remove in release!
		initialday = currentday end
		--print("day passed"..currentday..initialday)
	end

	if (get_key_pressed(Keys.C)) then -------------------------- Debug tool. remove in release!
		ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),-852.21246337891,160.97874450684,65.848379516602,true,true,true,true)

	end

	if (get_key_pressed(Keys.Back)) then -------------------------- Debug tool. remove in release!
		--sh.cancel()
		--CAM.SET_FOLLOW_PED_CAM_VIEW_MODE(4)
		sh.timelapse()
		--ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),346.99029541016,-1011.2156982422,-95.196182250977,true,true,true,true)
		--sh.rexit()
		--sh.showhint(200, "Backspace")
		--ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),-1005.7172851563,-474.99221801758,50.026264190674,true,true,true,true)
	end

	if (get_key_pressed(Keys.X)) then -------------------------- Debug tool. remove in release!
	ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),-943.048,-278.801,39.5951,true,true,true,true)
	ENTITY.SET_ENTITY_HAS_GRAVITY(PLAYER.PLAYER_PED_ID(),true)
	ENTITY.SET_ENTITY_VISIBLE(PLAYER.PLAYER_PED_ID(),true)
	ENTITY.SET_ENTITY_MAX_SPEED(PLAYER.PLAYER_PED_ID(),15000)

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

function sh.enterr()

	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	sh.shGUI.addButton("Welcome to realtor",sh.dummy,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Go inside",sh.realtors,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)

end

function sh.timelapse()

	local lhour = TIME.GET_CLOCK_HOURS()
	local lminute = TIME.GET_CLOCK_MINUTES()
	local lsec = 0
	local dur = (sleeptimer*60)

	local timetick = 1
	while (timetick<dur) do
		if (lhour>=24) then lhour=1 end
		if (lminute>=60) then lhour=lhour+1 lminute=1 end
		--elseif (lsec>=60) then lminute=lminute+1
		lminute = lminute+1
		timetick = timetick+1
		TIME.SET_CLOCK_TIME(lhour, lminute, lsec)
		wait(10)
	end


end

local gametime = 0
function sh.realtors()

	isatrealtor = true
	rcurrenthouse = {}
	rcurrenttable = {}

	CAM.DO_SCREEN_FADE_OUT(250)
	wait(500)
	TIME.SET_CLOCK_TIME(12,0,0) -- maybe redo. this is here so game time is not lost when you go back in menus
	gametime = TIME.GET_CLOCK_HOURS()
	ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),-1904.3238525391,-573.31024169922,18.507219467163,true,true,true,true)
	ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),99.215171813965)
	CAM.SET_GAMEPLAY_CAM_RELATIVE_HEADING(99.215171813965)---90)
	ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),true)
	CAM.SET_FOLLOW_PED_CAM_VIEW_MODE(4)
	--CAM.SET_GAMEPLAY_CAM_RELATIVE_PITCH(0, 10)
	--CONTROLS.DISABLE_ALL_CONTROL_ACTIONS(2)
	--ENTITY.SET_ENTITY_HAS_GRAVITY(PLAYER.PLAYER_PED_ID(),false)
	--ENTITY.SET_ENTITY_VELOCITY(PLAYER.PLAYER_PED_ID(),0,0,0)
	ENTITY.SET_ENTITY_VISIBLE(PLAYER.PLAYER_PED_ID(),false)
	wait(550)
	CAM.DO_SCREEN_FADE_IN(250)

	wait(200)
	--sh.showhint(150,"Welcome to realtor")

	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	sh.shGUI.addButton("Choose category",sh.dummy,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Sell my house",sh.rclass,4,0,0.33,0.06,0.06)
	sh.shGUI.addButton("High End",sh.rclass,1,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Middle Class",sh.rclass,2,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Low End",sh.rclass,3,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Exit",sh.rexit,nil,0,0.33,0.06,0.06)
	chosentype = 0

end

local chosentype = 0
local hendtable = {}
local mendtable = {}
local lendtable = {}
local ownedtable = {}
local othertable = {}
local rcurrenthouse = 0
local rcurrenttable = {}
local rcamerawork = false
local roperationtype = 1

function sh.rclass(tp)

	hendtable = {}
	mendtable = {}
	lendtable = {}
	ownedtable = {}
	othertable = {}
	rcurrenthouse = {}
	rcurrenttable = {}
	chosentype = tp
	local a = 1
	while (a <= #h) do
		local tbl = htable[a]
		if (tonumber(tbl[12])>=750000) and (tonumber(tbl[13])==0) then
			table.insert(hendtable, tbl)
		elseif (tonumber(tbl[12])>=250000) and (tonumber(tbl[12])<750000) and (tonumber(tbl[13])==0) then
			table.insert(mendtable, tbl)
		elseif (tonumber(tbl[12])<250000) and (tonumber(tbl[13])==0) then
			table.insert(lendtable, tbl)
		elseif (tonumber(tbl[13])~=0) and (tonumber(tbl[13])==currentmodel) then
			table.insert(ownedtable, tbl)
		elseif (tonumber(tbl[13])~=0) and (tonumber(tbl[13])~=currentmodel) then
			table.insert(othertable, tbl)
		end
		a = a + 1
	end

	print("he: "..#hendtable.." me: "..#mendtable.." le: "..#lendtable.." ow: "..#ownedtable)

	if (tp==1) then
		if (#hendtable>=1) then
		rcurrenttable = hendtable rcurrenthouse = hendtable[1]
		else sh.showhint(150, "No houses to purchase") end
	elseif (tp==2) then
		if (#mendtable>=1) then
		rcurrenttable = mendtable rcurrenthouse = mendtable[1]
		else sh.showhint(150, "No houses to purchase") end
	elseif (tp==3) then
		if (#lendtable>=1) then
		rcurrenttable = lendtable rcurrenthouse = lendtable[1]
		else sh.showhint(150, "No houses to purchase") end
	elseif (tp==4) then
		if (#ownedtable>=1) then
		rcurrenttable = ownedtable rcurrenthouse = ownedtable[1] print("table set to owned, "..#ownedtable)
		else sh.showhint(150, "You have no houses to sell") end
	end

	roperationtype = tp
	num = 1
	sh.rcamerawork()

end

local num = 1
function sh.rselectionmove(cmd)

	if (cmd==1) and (num>1) then num = num-1
	elseif (cmd==1) and (num<=1) then sh.showhint(100,"First house in list reached") num=1
	elseif (cmd==2) and (num<#rcurrenttable) then num = num+1
	elseif (cmd==2) and (num>=#rcurrenttable) then sh.showhint(100,"Last house in list reached") num=#rcurrenttable
	end
	rcurrenthouse = rcurrenttable[num]
	sh.rcamerawork()

end


function sh.rcamerawork()

	--CAM.DO_SCREEN_FADE_OUT(250) -- For Debug. Turn on in release
	--wait(500)
	ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(rcurrenthouse[15]),tonumber(rcurrenthouse[16]),tonumber(rcurrenthouse[17]),true,true,true,true)
	ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(rcurrenthouse[18]))
	CAM.SET_GAMEPLAY_CAM_RELATIVE_HEADING(tonumber(rcurrenthouse[18])+90)
	--CAM.SET_GAMEPLAY_CAM_RELATIVE_PITCH(0, 10)
	CAM.SET_FOLLOW_PED_CAM_VIEW_MODE(4)
	--CONTROLS.DISABLE_ALL_CONTROL_ACTIONS(2)
	ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),true)
	ENTITY.SET_ENTITY_HAS_GRAVITY(PLAYER.PLAYER_PED_ID(),false)
	ENTITY.SET_ENTITY_VISIBLE(PLAYER.PLAYER_PED_ID(),false)
	ENTITY.SET_ENTITY_MAX_SPEED(PLAYER.PLAYER_PED_ID(),0)
	TIME.SET_CLOCK_TIME(15, 0, 0)
	GAMEPLAY.SET_WEATHER_TYPE_NOW_PERSIST("CLEAR")
	sh.rupdatenavmenu()
	--wait(250)
	--CAM.DO_SCREEN_FADE_IN(250)

end

function sh.rupdatenavmenu()

	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	sh.shGUI.addButton("House "..num.." of "..#rcurrenttable.." USD "..tonumber(rcurrenthouse[12]).."",sh.dummy,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Next House",sh.rselectionmove,2,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Choose this house",sh.rgoinside,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Previous House",sh.rselectionmove,1,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Go back",sh.realtors,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Exit",sh.rexit,nil,0,0.33,0.06,0.06)

end

function sh.rgoinside()

	rcurrenthouse = rcurrenttable[num]
	local tp = tonumber(rcurrenthouse[14])
	local int = interior[tp]

	--CAM.DO_SCREEN_FADE_OUT(250) -- For Debug. Turn on in release
	--wait(500)
	ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(int[11]),tonumber(int[12]),tonumber(int[13]),true,true,true,true)
	ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(int[14]))
	CAM.SET_GAMEPLAY_CAM_RELATIVE_HEADING(tonumber(int[14])+90)
	CAM.SET_FOLLOW_PED_CAM_VIEW_MODE(4)
	ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),true)
	ENTITY.SET_ENTITY_HAS_GRAVITY(PLAYER.PLAYER_PED_ID(),false)
	ENTITY.SET_ENTITY_VISIBLE(PLAYER.PLAYER_PED_ID(),false)
	ENTITY.SET_ENTITY_MAX_SPEED(PLAYER.PLAYER_PED_ID(),0)
	--wait(250)
	--CAM.DO_SCREEN_FADE_IN(250)
	if (roperationtype<4) then
	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	sh.shGUI.addButton("USD "..rcurrenthouse[12].."",sh.dummy,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Purchase",sh.rbuyconfirm,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Go back",sh.rcamerawork,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Exit",sh.rexit,nil,0,0.33,0.06,0.06)
	elseif (roperationtype==4) then
	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	sh.shGUI.addButton("USD "..rcurrenthouse[12].."",sh.dummy,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Sell",sh.sellconfirm,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Go back",sh.rcamerawork,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Exit",sh.rexit,nil,0,0.33,0.06,0.06)
	end

end

function sh.sellconfirm()

	htosave = rcurrenthouse

	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.updateSelection()
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	sh.shGUI.addButton("USD "..htosave[12].."",sh.dummy,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Are you sure",sh.dummy,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Yes",sh.housesold,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
	--end
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

	sh.realtors()

	print("house sold")

end

function sh.rbuyconfirm()

	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	if (not sh.domoneycheck(tonumber(rcurrenthouse[12]))) then
		sh.shGUI.addButton("Price is USD "..rcurrenthouse[12].."",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Not enough money",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Go back",sh.realtors,nil,0,0.33,0.06,0.06)
	elseif (sh.domoneycheck(tonumber(rcurrenthouse[12]))) then
		sh.shGUI.addButton("Buy for USD "..rcurrenthouse[12].."",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Yes",sh.housebought,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Go back",sh.rgoinside,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Exit",sh.rexit,nil,0,0.33,0.06,0.06)
	end

end

function sh.housebought()
	print("buying house")
	local price = tonumber(rcurrenthouse[12])
	local mod = (sh.whoisplayer() - 1)
	local statname = "SP"..mod.."_TOTAL_CASH"
	local hash = GAMEPLAY.GET_HASH_KEY(statname)
	local bool, cash = STATS.STAT_GET_INT(hash, 0, -1)
	STATS.STAT_SET_INT(hash, (cash - price), true)
	print("Purchased for "..price)
	local counter = (sh.whoisplayer() + 1)
	local num = tonumber(rcurrenthouse[1])
	table.remove(rcurrenthouse, counter)
	table.insert(rcurrenthouse, counter, "1")
	table.remove(rcurrenthouse, 13)
	table.insert(rcurrenthouse, 13, currentmodel)
	table.remove(htable, num)
	table.insert(htable, num, rcurrenthouse)
	sh.writetofile()
	sh.showhint(150,"Property bought for $"..price)
	sh.clearblips()
	sh.addblips()
	wait(150)
	--wait(500)
	--TIME.SET_CLOCK_TIME(gametime,0,0)
	--ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(roffice[1]),tonumber(roffice[2]),tonumber(roffice[3]),true,true,true,true)
	--ENTITY.SET_ENTITY_HAS_GRAVITY(PLAYER.PLAYER_PED_ID(),true)
	--CONTROLS.DISABLE_ALL_CONTROL_ACTIONS(2)
	--CONTROLS.ENABLE_CONTROL_ACTION(2,0,1)
	--ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),false)
	--ENTITY.SET_ENTITY_VISIBLE(PLAYER.PLAYER_PED_ID(),true)
	--ENTITY.SET_ENTITY_MAX_SPEED(PLAYER.PLAYER_PED_ID(),15000)
	--wait(250)
	--CAM.DO_SCREEN_FADE_IN(250)
	rcurrenthouse = {}
	rcurrenttable = {}
	sh.realtors()
	print("house bought")
end

local roffice = {}
function sh.rexit()

	chosentype = 0
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = true
	--CAM.DO_SCREEN_FADE_OUT(250) -- Enable in release.
	--wait(500)
	--ENTITY.SET_RANDOM_WEATHER_TYPE() -- More testing needed
	TIME.SET_CLOCK_TIME(gametime,0,0)
	ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(roffice[1]),tonumber(roffice[2]),tonumber(roffice[3]),true,true,true,true)
	ENTITY.SET_ENTITY_HAS_GRAVITY(PLAYER.PLAYER_PED_ID(),true)
	--CONTROLS.DISABLE_ALL_CONTROL_ACTIONS(2)
	--CONTROLS.ENABLE_CONTROL_ACTION(2,0,1)
	ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),false)
	ENTITY.SET_ENTITY_VISIBLE(PLAYER.PLAYER_PED_ID(),true)
	CAM.SET_FOLLOW_PED_CAM_VIEW_MODE(1)
	ENTITY.SET_ENTITY_MAX_SPEED(PLAYER.PLAYER_PED_ID(),15000)
	--wait(250)
	--CAM.DO_SCREEN_FADE_IN(250)

	rcurrenthouse = {}
	rcurrenttable = {}
	isatrealtor = false
	tickcooldown = 400

end

function sh.exithouse()

	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
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
	dialogactive = false
	tickcooldown = 200

end

function sh.looksave()

	print("lookforsave")

	local plcoord = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
	if (GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(plcoord.x, plcoord.y, plcoord.z, intarray[6], intarray[7], intarray[8], true) < 0.5) and (not dialogactive) then
		dialogactive = true
		sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
		sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
		sh.shGUI.addButton("Save Game",sh.savegame,typetoenter,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Exit House",sh.exithouse,nil,0,0.33,0.06,0.06)
	end

	print("lookforsave end")

end

function sh.lookexit()

	print("lookexit")

	local plcoord = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)

	wait(200)

	if (GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(plcoord.x, plcoord.y, plcoord.z, intarray[2], intarray[3], intarray[4], true) < 0.3) and (not dialogactive) then
		if (insidetick<=0) then sh.exithouse() end
		--dialogactive = true
		--sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
		--sh.shGUI.updateSelection()
		--sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
		--sh.shGUI.addButton("Exit",sh.exithouse,nil,0,0.33,0.06,0.06)
		--sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)

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
		tickcooldown = 200 print("tick cooldown")
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
		tickcooldown = 200 print("tick cooldown")
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
		tickcooldown = 200 print("tick cooldown")
		ctosave = ctable[cntc] print("table set for ctable "..cntc)
		sh.customsh() print("customsh initiated")
	end

end

local cntr = 0
function sh.getproximityr()

	local plcoord = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)

	if(cntr >= #realtors) then cntr = 0 end
	cntr = cntr + 1

	local coord = realtors[cntr]

	if (GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(plcoord.x, plcoord.y, plcoord.z, coord[1], coord[2], coord[3], true) < 2) then
		stopproxtick = true print("tick stopped")
		tickcooldown = 200 print("tick cooldown")
		roffice = realtors[cntr]
		sh.enterr() print("realtors initiated")
	end

end

local cntint = 0
function sh.checkifinside()

	local plcoord = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)

	if(cntint >= #interior) then cntint = 0 end
	cntint = cntint + 1

	local coord = interior[cntint]

	if (GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(plcoord.x, plcoord.y, plcoord.z, coord[6], coord[7], coord[8], true) < 20) then
		isinside = true
	else isinside = false end

end


function sh.interior()
	print("interior")
	local array = {}
	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.hidden = true

	print("typetoenter: "..typetoenter)
	if (typetoenter==1) then array = interior[tonumber(htosave[14])] 	intarray = array
	elseif (typetoenter==2) then array = interior[tonumber(httosave[19])] intarray = array
	elseif (typetoenter==3) then array = interior[tonumber(ctosave[14])] intarray = array
	end

	CAM.DO_SCREEN_FADE_OUT(250)
	wait(500)
	ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(array[2]), tonumber(array[3]), tonumber(array[4]),true,true,true,true)
	ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(array[5]))
	ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),true)
	wait(250)
	CAM.DO_SCREEN_FADE_IN(250)
	wait(1200)
	ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),false)
	insidetick = 500
	sh.showhint(150,"Welcome, "..charactername)
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

	if (tonumber(htosave[13])==currentmodel) then
		owned = true print("sh set to owned")
		typetoenter = 1
		sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
		sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
		sh.shGUI.addButton("Go inside",sh.interior,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
	elseif (tonumber(htosave[13])==0) then
		notowned = true print("sh set to not owned")
	elseif (tonumber(htosave[13])~=0 and tonumber(htosave[13])~=currentmodel) then
		ownedbyother = true
	end
	print("end safehouse")
end

function sh.buyconfirm()
	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.updateSelection()
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	sh.shGUI.addButton("Are you sure",sh.dummy,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Yes",sh.housebought,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
end

function sh.savegame(tp)

	local count = (currentmodel + 4)
	if enablehouse then
	local i = 1
	while (i <= #htable) do
		local val = htable[i]
		table.remove(val, count)
		table.insert(val, count, "0")
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
	--CAM.DO_SCREEN_FADE_OUT(250)
	TIME.SET_CLOCK_TIME((hour + sleeptimer), minute, 0)
	GAMEPLAY.SET_SAVE_MENU_ACTIVE(true)
	wait(1000)
	--CAM.DO_SCREEN_FADE_IN(250)
	sh.camerawork()
	wait(150)
	sh.showhint(150,"This place was set as your spawning spot")
	dialogactive = false
	wait(1500)

end

local ahtdescr = {}
function sh.hotel()

	print("hotel")

	stopproxtick = true print("tick stopped")
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
			typetoenter = 2
			sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
			sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
			sh.shGUI.addButton(""..daysleft.." days left",sh.dummy,nil,0,0.33,0.06,0.06)
			sh.shGUI.addButton("Go inside",sh.interior,nil,0,0.33,0.06,0.06)
			sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
	end

	if notowned then
		sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
		sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
		sh.shGUI.addButton("USD "..httosave[18].." for one night",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Rent "..ahtdescr[3].." for "..ahtdescr[4].." days",sh.rentshort,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Rent "..ahtdescr[3].." for "..ahtdescr[5].." days",sh.rentlong,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
	end

	print("end hotel")

end

function sh.rentshort()
	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	if (not sh.domoneycheck(tonumber(ahtdescr[4])*tonumber(httosave[18]))) then
		sh.shGUI.addButton("Not enough money",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
	elseif (sh.domoneycheck(tonumber(ahtdescr[4])*tonumber(httosave[18]))) then
		sh.shGUI.addButton("Are you sure",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Yes",sh.hotelrent,1,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
	end
end

function sh.rentlong()
	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	if (not sh.domoneycheck(tonumber(ahtdescr[5])*tonumber(httosave[18]))) then
		sh.shGUI.addButton("Not enough money",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
	elseif (sh.domoneycheck(tonumber(ahtdescr[5])*tonumber(httosave[18]))) then
		sh.shGUI.addButton("Are you sure",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Yes",sh.hotelrent,2,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
	end
end

function sh.hotelrent(tp)

	print("renting room")

	local durofstay = 0
	if (tp==1) then durofstay = tonumber(ahtdescr[4])
	elseif (tp==2) then durofstay = tonumber(ahtdescr[5]) end

	local rcount = 0
	if (currentmodel == 1) then rcount = 8
	elseif (currentmodel == 2) then rcount = 10
	elseif (currentmodel == 3) then rcount = 12 end

	table.remove(httosave, rcount)
	table.insert(httosave, rcount, durofstay)

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
	sh.showhint(150,"Rented for USD "..price)
		sh.clearblips()
		sh.addblips()
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

	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.updateSelection()
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	sh.shGUI.addButton("Create custom house here",sh.dummy,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Yes",sh.customchoosetype,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)

	abc=true
	aa=true
	ba=true
	ca=true
	cba=true

end

local abc = true
function sh.customchoosetype()

	abc = true
	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.updateSelection()
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	if abc then
		sh.shGUI.addButton("Choose House Class",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("High End",sh.custominterior,1,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Middle Class",sh.custominterior,2,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Low End",sh.custominterior,3,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
		abc = false
	end

end

local aa = true
local ba = true
local ca = true
local cba = true
function sh.custominterior(tp)

	aa = true
	ba = true
	ca = true
	cba = true

	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.updateSelection()
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false

	if cba then
	if (tp==1) and aa then
	sh.shGUI.addButton("Choose House Interior",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Floyds House 550K",sh.customconfirm,7,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Luxurious Apartment 1250K",sh.customconfirm,8,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Madrazo Villa 2500K",sh.customconfirm,9,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Go back",sh.customchoosetype,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
		aa = false
	elseif (tp==2) and ba then
		sh.shGUI.addButton("Choose House Interior",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Small House 320K",sh.customconfirm,4,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Lesters house 340K",sh.customconfirm,5,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Mid Class Apartment 450K",sh.customconfirm,6,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Go back",sh.customchoosetype,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
		ba = false
	elseif (tp==3) and ca then
		sh.shGUI.addButton("Choose House Interior",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Hotel room USD 50K",sh.customconfirm,1,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Movie makers office 100K",sh.customconfirm,2,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Basic Apartment 250K",sh.customconfirm,3,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Go back",sh.customchoosetype,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
		ca = false
	end
	cba = false
	end
end

local aaa = true
local hprice = 0
function sh.customconfirm(tp)

	aaa = true
	local choosenint = {}
	hprice = 0

	for i,itp in ipairs(interior) do
		local b = 1
		while (b<=#interior) do
			local tbl = interior[b]
			if (tp==tonumber(tbl[1])) then choosenint = tbl end
			b = b+1
		end
	end

	local cprice = tonumber(choosenint[10])
	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.updateSelection()
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false

	if aaa then
		if (not sh.domoneycheck(cprice)) then
		sh.shGUI.addButton("Price is USD "..cprice.."",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Not enough money",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
		aaa=false
		elseif (sh.domoneycheck(cprice)) then
		hprice = cprice
		sh.shGUI.addButton("Price is USD "..cprice.."",sh.dummy,nil,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Confirm",sh.customcreated,tp,0,0.33,0.06,0.06)
		sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
		aaa=false
		end
	end
end

function sh.customcreated(tp)

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
	table.insert(chtocreate, 14, tp)
	table.remove(chtocreate, owner)
	table.insert(chtocreate, owner, "1")
	print("chtocreate table created")

	table.insert(ctable, num, chtocreate)
	sh.writetofile()

	local mod = (currentmodel - 1)
	local statname = "SP"..mod.."_TOTAL_CASH"
	local hash = GAMEPLAY.GET_HASH_KEY(statname)
	local bool, cash = STATS.STAT_GET_INT(hash, 0, -1)
	STATS.STAT_SET_INT(hash, (cash - hprice), true)

	sh.showhint(150,"Custom safehouse created")
		sh.clearblips()
		sh.addblips()

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
		typetoenter = 3

			sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
			sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
			sh.shGUI.addButton("Go Inside",sh.interior,nil,0,0.33,0.06,0.06)
			sh.shGUI.addButton("Remove this house",sh.cremoveconf,nil,0,0.33,0.06,0.06)
			sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)
	end

	if notowned then
		sh.showhint(150,"This custom savehouse is not owned by "..charactername)
	end

	print("end custom safehouse")
end

function sh.cremoveconf()

	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.buttonCount = 0 sh.shGUI.hidden = false
	sh.shGUI.addButton("Are you sure",sh.dummy,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Yes",sh.cremove,nil,0,0.33,0.06,0.06)
	sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.33,0.06,0.06)

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

function sh.writetofile()
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

function sh.camerawork()

	local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), nil)
	local vals = {coords.x, coords.y, coords.z, head}

	--CAM.DO_SCREEN_FADE_OUT(250) -- For Debug. Turn on in release
	--wait(500)
	if (typetoenter==1) then
		ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(htosave[15]),tonumber(htosave[16]),tonumber(htosave[17]),true,true,true,true)
		ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(htosave[18]))
		CAM.SET_GAMEPLAY_CAM_RELATIVE_HEADING(tonumber(htosave[18])-90)
	end
	--elseif (typetoenter==3) then --------------------------------------------------Need cams for hotels and custom sh
	--	ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(ctosave[15]),tonumber(htosave[16]),tonumber(htosave[17]),true,true,true,true)
	--	ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(ctosave[18]))

	--CAM.SET_GAMEPLAY_CAM_RELATIVE_PITCH(0, 10)
	CAM.SET_FOLLOW_PED_CAM_VIEW_MODE(4)
	ENTITY.SET_ENTITY_HAS_GRAVITY(PLAYER.PLAYER_PED_ID(),false)
	ENTITY.SET_ENTITY_VISIBLE(PLAYER.PLAYER_PED_ID(),false)
	ENTITY.SET_ENTITY_MAX_SPEED(PLAYER.PLAYER_PED_ID(),0)
	wait(250)
	--CAM.DO_SCREEN_FADE_IN(250)
	--sh.timelapse()

	--CAM.DO_SCREEN_FADE_OUT(250) -- For Debug. Turn on in release
	--wait(500)
	ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(vals[1]),tonumber(vals[2]),tonumber(vals[3]),true,true,true,true)
	ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(vals[4]))
	ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(),false)
	ENTITY.SET_ENTITY_VISIBLE(PLAYER.PLAYER_PED_ID(),true)
	CAM.SET_FOLLOW_PED_CAM_VIEW_MODE(1)
	ENTITY.SET_ENTITY_MAX_SPEED(PLAYER.PLAYER_PED_ID(),15000)
	--wait(250)
	--CAM.DO_SCREEN_FADE_IN(250)

end

function sh.filemakehouse()

	print("making house")

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

-- Added for GUI
function UI.renderBox(xMin,xMax,yMin,yMax,color1,color2,color3,color4)
	GRAPHICS.DRAW_RECT(xMin, yMin,xMax, yMax, color1, color2, color3, color4);
end

-- Changed for GUI
function sh.drawhint()
		UI.SET_TEXT_FONT(4)
		UI.SET_TEXT_SCALE(0.0, 0.6)
		UI.SET_TEXT_COLOUR(255, 255, 255, 255)
		UI.SET_TEXT_WRAP(0 , 2)
		UI.SET_TEXT_CENTRE(false)
		UI.SET_TEXT_DROPSHADOW(255, 255, 255, 255, 100)
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
	shblip = {}
	phblip = {}
	ohblip = {}
	ahtblip = {}
	ohtblip = {}
	cblip = {}
	forrent = {}
	rented = {}

	for i, coord in ipairs(realtors) do
			blip[i] = UI.ADD_BLIP_FOR_COORD(tonumber(coord[1]),tonumber(coord[2]),tonumber(coord[3]))
			UI.SET_BLIP_SPRITE(blip[i], 408)
			UI.SET_BLIP_SCALE(blip[i], blipsize)
			UI.SET_BLIP_AS_SHORT_RANGE(blip[i], true)
			table.insert(bliptable, (#bliptable+1), blip[i])
	end

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

		--for i, coord in ipairs(phblip) do
		--	blip[i] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
		--	UI.SET_BLIP_SPRITE(blip[i], 350)
		--	UI.SET_BLIP_SCALE(blip[i], blipsize)
		--	UI.SET_BLIP_AS_SHORT_RANGE(blip[i], true)
		--	table.insert(bliptable, (#bliptable+1), blip[i])
		--end

		--for i, coord in ipairs(ohblip) do
		--	local j = i + 1
		--	blip[i] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
		--	UI.SET_BLIP_SPRITE(blip[i], 350)
		--	UI.SET_BLIP_SCALE(blip[i], blipsize)
		--	UI.SET_BLIP_AS_SHORT_RANGE(blip[i], true)
		--	blip[j] = UI.ADD_BLIP_FOR_COORD(coord[1],coord[2],coord[3])
		--	UI.SET_BLIP_SPRITE(blip[j], 163)
		--	UI.SET_BLIP_SCALE(blip[j], (blipsize-0.1))
		--	UI.SET_BLIP_AS_SHORT_RANGE(blip[j], true)
		--	table.insert(bliptable, (#bliptable+1), blip[i])
		--	table.insert(bliptable, (#bliptable+1), blip[j])
		--end
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

local realtorbliptable = {}
function sh.clearblips()

	print("clearing blips")
	local i = 1
	while (i <= #bliptable) do
		UI.REMOVE_BLIP(bliptable[i])
		print("remove blip "..bliptable[i])
		i=i+1
	end
	while (i <= #realtorbliptable) do
		UI.REMOVE_BLIP(realtorbliptable[i])
		print("remove blip "..realtorbliptable[i])
		i=i+1
	end
	wait(500)
	print("blips cleared")

end

function sh.cancel()
	sh.shGUI.buttonCount = 0 sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0) sh.shGUI.addButton("",sh.dummy,nil,0,0.0,0.0,0.0)
	sh.shGUI.hidden = true
	if isatrealtor then sh.rexit() end
	tickcooldown = 200
	dialogactive = false
end

function sh.dummy()
	sh.shGUI.hidden = false
end

return sh
