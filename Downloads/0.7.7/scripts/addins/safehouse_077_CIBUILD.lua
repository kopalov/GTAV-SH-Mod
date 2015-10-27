-------------------------------------------------------------------------------------
------------------------------------Version 0.7.7------------------------------------
-------------------------------------------------------------------------------------
-------------------Created by Kopalov with help from Henny Smafter-------------------
-------------------------------------------------------------------------------------
------------------------------- !!! IMPORTANT !!! -----------------------------------
------------ CHANGE to some folder on your PC (Which is not read-only). -------------
-------------------------------------------------------------------------------------

local savepath = "C:/.../Rockstar Games/.../"
-- For example, "C:/Users/Derpy/Rockstar Games/GTA5_Housemod/"

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
local mkcustomkey = 96            -- Key to create a custom safehouse.
local mkblipsoff = 67             -- Key to disable all blips. (Depending on the above settings!)
local mkblipson = 86              -- Key to enable all blips. (Depending on the above settings!)
local customcost = 750000         -- How much does custom safehouse creation cost.
local sleeptimer = 6              -- How many hours does time advances when you save your game.
local updatehouses = true         -- If enabled, updates your safehouse savefile, adding more houses. All previous data remains in its place.
local updatehotels = true	        -- If enabled, updates your hotel savefile, adding more hotels. All previous data remains in its place.

-------------------------------------------------------------------------------------
----------------------------------- CHANGELOG ---------------------------------------
-------------------------------------------------------------------------------------
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

--[x]-- Add directory check and warning message.
--[ ]-- On screen text flickering (this is because function reloads text every tick, which is needed for key presses to work properly).
--[ ]-- If hotel rent time expires for more than one character at once, only one goodbye message is displayed.
--[x]-- Ability to turn mod on/off.
--[x]-- Check if hotel db is updated.
--[ ]-- Add period of time without messages after spawn.
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
	{42,"Dream View Motel","room",3,5}

	--{44,"Elkridge Hotel","room",2,5},
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
	{42, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -107.40759277344,6339.9702148438,35.500743865967,231.78079223633, 80, 1}--213 h3 Dream View Motel c214

	--{44, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},-
	--{36, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},-
	--{37, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},-
	--{38, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},-
	--{39, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},-
	--{40, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2},-
	--{41, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, -1356.611328125,-791.16937255859,20.242179870605,310.51248168945, 40, 2}
	}

function sh.unload()
	sh.clearblips()
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
	else
		decision = false
		confirm = false
		sdecision = false
		cdecision = false
		htdecision = false
		rsconfirm = false
		rlconfirm = false
		--sh.shGUI.hidden = true
		--sh.shGUI.buttonCount = 0
	end

	if (tickcooldown > 0) then tickcooldown = tickcooldown - 1
	else stopproxtick = false ----print("proxtick resumed by timer")
	end

	if (not CAM.IS_SCREEN_FADED_OUT()) and spawnchecker then
		sh.checkspawn()
		spawnchecker = false
	end

	if (sh.whoisplayer()~=currentmodel) then currentmodel = sh.whoisplayer()
		--print("Model changed to "..currentmodel)
		--if spawnchecker then
		--	sh.checkspawn()
		--	spawnchecker = false
		--end
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

	if enablehotels then
		local currentday = TIME.GET_CLOCK_DAY_OF_MONTH()
		if (currentday > initialday) then --or (tonumber(currentday)==1) then
		sh.daypassed()
		--sh.showhint(125,"Day passed by..."..currentday.." - "..initialday)
		initialday = currentday end
		----print("day passed"..currentday..initialday)
	end

	sh.shGUI.tick()
	end
	if (get_key_pressed(mkblipsoff)) then
		sh.clearblips()
	end
	if (get_key_pressed(mkblipson)) then
		sh.clearblips()
		sh.addblips()
	end
end

local cnt = 0
function sh.getproximityh()

	----print("getprox-h") -- Убрать для теста подфункций
	local plcoord = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)

	if(cnt >= #htable) then cnt = 0 end
	cnt = cnt + 1
	local coord = htable[cnt]

	if (GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(plcoord.x, plcoord.y, plcoord.z, coord[8], coord[9], coord[10], true) < 2) then
		stopproxtick = true --print("tick stopped")
		tickcooldown = 1000 --print("tick cooldown")
		htosave = htable[cnt] --print("table set for htable "..cnt)
		sh.safehouse() --print("safehouse initiated")
	end

end

local cntht = 1
function sh.getproximityht()

	----print("getprox-ht")
	local plcoord = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)

	if(cntht >= #httable) then cntht = 1 end
	cntht = cntht + 1

	local coord = httable[cntht]

	if (GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(plcoord.x, plcoord.y, plcoord.z, coord[14], coord[15], coord[16], true) < 2) then
		stopproxtick = true --print("tick stopped")
		tickcooldown = 1000 --print("tick cooldown")
		httosave = httable[cntht] --print("table set for httable "..cntht)
		sh.hotel() --print("hotel initiated")
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
		stopproxtick = true --print("tick stopped")
		tickcooldown = 1000 --print("tick cooldown")
		ctosave = ctable[cntc] --print("table set for ctable "..cntc)
		sh.customsh() --print("customsh initiated")
	end

end

function sh.safehouse()

	--print("safehouse")

	local counter = (currentmodel + 1)
	local owned = false
	local notowned = false
	local ownedbyother = false

	if (tonumber(htosave[13])==currentmodel) then--[counter])==1) then
	owned = true --print("sh set to owned")
	elseif (tonumber(htosave[13])==0) then--counter])==0) then
	notowned = true --print("sh set to not owned")
	elseif (tonumber(htosave[13])~=0 and tonumber(htosave[13])~=currentmodel) then--counter~=2) or (tonumber(htosave[3])==1 and counter~=3) or (tonumber(htosave[4])==1 and counter~=4)
	ownedbyother = true
	end

	if ownedbyother then
	sh.showhint(150,"This house is owned by another character")
	wait(500)
	stopproxtick = false

	elseif owned then
			--print("owned")
			sh.showhint(150,"Welcome Home, "..charactername)
			wait(750)
			--sh.camerawork(1, htosave[1])
			sh.shGUI.hidden = false
			sh.shGUI.buttonCount = 0
			sh.shGUI.addButton("Save Game",sh.savegame,1,0,0.2,0.06,0.06)
			sh.shGUI.addButton("Sell this house",sh.sellhouse,nil,0,0.2,0.06,0.06)
			sh.shGUI.addButton("Cancel",sh.cancel,nil,0,0.2,0.06,0.06)

	elseif notowned then
		local hprice = tonumber(htosave[12])
		sh.showhint(150,"Press E" .."\n".."to buy this house for $"..hprice.." or N to cancel.")
		decision = true
		buttontimer = 200
	end

	--print("end safehouse")
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

-- Очищение прочих слотов в сейве --
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
		--print("SG active. Changing htable field "..i)
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
		--print("SG active. Changing httable field "..o)
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
		--print("SG active. Changing ctable field "..p)
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
	--print("This type "..tp.." place is set as spawn location")
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

	--print("buying house")

	local price = tonumber(htosave[12])
	local mod = (sh.whoisplayer() - 1)
	local statname = "SP"..mod.."_TOTAL_CASH"
	local hash = GAMEPLAY.GET_HASH_KEY(statname)
	local bool, cash = STATS.STAT_GET_INT(hash, 0, -1)
	STATS.STAT_SET_INT(hash, (cash - price), true)
	--print("Purchased for "..price)

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

	--print("house bought")

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

	--print("selling house")

	local price = tonumber(htosave[12])
	local mod = (sh.whoisplayer() - 1)
	local statname = "SP"..mod.."_TOTAL_CASH"
	local hash = GAMEPLAY.GET_HASH_KEY(statname)
	local bool, cash = STATS.STAT_GET_INT(hash, 0, -1)
	STATS.STAT_SET_INT(hash, (cash + price), true)
	--print("Sold for "..price)
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

	--print("house sold")

end

local ahtdescr = {}
function sh.hotel()

	--print("hotel")

	stopproxtick = true --print("tick stopped")
	--wait(250)
	local counter = (currentmodel + 1)
	local owned = false
	local notowned = false
	local num = tonumber(httosave[1])
	ahtdescr = htdescr[num]
	sh.showhint(150,"Welcome to "..ahtdescr[2])

	if (tonumber(httosave[counter])==1) then
	owned = true --print("set to owned")
	elseif (tonumber(httosave[counter])==0) then
	notowned = true --print("set to not owned")
	end

	if owned then
			--print("owned")
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

	--print("end hotel")

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

	--print("renting room")
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
	--print("rented for "..price)

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

	--print("room rented")

end

function sh.daypassed()
	--print("daypassed")
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
	--print("daypassed end")
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

	--print("creating custom house")

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
	--print("chtocreate table created")

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

	--print("house created")

end

function sh.customsh()

	--print("custom safehouse")

	stopproxtick = true
	--print("tick stopped")
	local counter = (currentmodel + 1)
	--print(counter)
	local owned = false
	local notowned = false

	if (tonumber(ctosave[counter])==1) then
	owned = true --print("set to owned")
	elseif (tonumber(ctosave[counter])==0) then
	notowned = true --print("set to not owned")
	end

	if owned then
			--print("owned")
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

	--print("end custom safehouse")
end

function sh.cremove()

	--print("remove csh")
	local num = tonumber(ctosave[1])

	table.remove(ctosave, 13)
	table.insert(ctosave, 13, "0")
	table.remove(ctable, num)
	table.insert(ctable, num, ctosave)
	sh.writetofile()
		sh.clearblips()
		sh.addblips()
	--print("csh removed")
	sh.cancel()

end

function sh.writetofile()                              -- не забудь убрать _written
	--print("writetofile")

	if enablehouse then
	local file = io.open(savepath .. "savehouses", "w")
	io.output(file)
	for a, v in ipairs(htable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
		--print("Writing to file savehouses line "..a)

	end
	io.close(file)
	end

	if enablehotels then
		local sfile = io.open(savepath .. "hotels", "w")
		io.output(sfile)
		for a, v in ipairs(httable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
		--print("Writing to file hotels line "..a)

	end
	io.close(sfile)
	end

	if enablecustom then
		local nfile = io.open(savepath .. "custom", "w")
		io.output(nfile)
		for a, v in ipairs(ctable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
		--print("Writing to file custom line "..a)

	end
	io.close(nfile)
	end

	sh.loadfiles()
	--print("writetofile done")
end

function sh.domoneycheck(sum)

		local summa = tonumber(sum)
		local mod = (sh.whoisplayer() - 1)
		local statname = "SP"..mod.."_TOTAL_CASH"
		local hash = GAMEPLAY.GET_HASH_KEY(statname)
		local bool, cash = STATS.STAT_GET_INT(hash, 0, -1)
		--print("Player Money: "..cash..", sum needed: "..summa)
		if (cash >= summa) then return true else return false end
		--print("Money check finished, returning")
end

function sh.filecheck()

	if sh.checkdir() then --print("checkdir is not nil")
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
--print("checkdir")
	local file = io.open(savepath .. "dircheck", "w")
	if file==nil then io.close(file) return false
	else io.close(file) return true end
	--io.output(file)
	--io.write(vdata .. "\n")

--print("checkdir end")
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

local h = {{1, 0,0,0, 0,0,0,-948.62927246094,-1107.7398681641,2.1718480587006,36.55443572998,280000,0}, ---- 3+ Parking Space -- Canal Island
	{2, 0,0,0, 0,0,0,-952.64404296875,-1077.7933349609,2.6728272438049,204.45997619629,295000,0}, ---- 3+ Parking Space -- Canal Island
	{3, 0,0,0, 0,0,0,-1055.4119873047,-913.38513183594,3.4768340587616,27.156518936157,450000,0}, ---- 2+ Parking Space -- Canal Island
	{4, 0,0,0, 0,0,0,-1022.5373535156,-896.94165039063,5.411808013916,8.1293268203735,505000,0}, ---- 4+ Parking Space -- Canal Island
	{5, 0,0,0, 0,0,0,-1037.05078125,-1605.3411865234,4.9727439880371,31.708919525146,720000,0}, ---- 2+ Parking Space -- Beach Properties East Los Santos
	{6, 0,0,0, 0,0,0,-1116.9993896484,-1505.9289550781,4.4003367424011,198.03451538086,645000,0}, ---- 2+ Parking Space -- Beach Properties East Los Santos
	{7, 0,0,0, 0,0,0,-1337.6215820313,-1161.4849853516,4.5061941146851,311.9677734375,600000,0}, ---- 1+ Parking Space -- Beach Properties East Los Santos
	{8, 0,0,0, 0,0,0,39.449676513672,-1911.3236083984,21.953493118286,250.35412597656,180000,0}, ---- 4+ Parking Space -- Grove Street
	{9, 0,0,0, 0,0,0,333.0163269043,-1741.0684814453,29.730543136597,181.05769348145,215000,0}, ---- 5+ Parking Space -- Grove Street
	{10, 0,0,0, 0,0,0,269.39416503906,-1728.6916503906,29.645454406738,16.822315216064,237500,0}, ---- 3+ Parking Space -- Grove Street
	{11, 0,0,0, 0,0,0,401.64022827148,-1849.6203613281,27.31974029541,140.61996459961,295000,0}, ---- 6+ Parking Space -- Grove Street
	{12, 0,0,0, 0,0,0,1288.9748535156,-1710.6239013672,55.475147247314,208.09156799316,515000,0}, ---- 6+ Parking Space -- El Burro Heights
	{13, 0,0,0, 0,0,0,1360.6423339844,-1556.3548583984,56.343906402588,14.435604095459,400000,0}, ---- 2+ Parking Space -- El Burro Heights
	{14, 0,0,0, 0,0,0,1378.6868896484,-1515.2473144531,58.435737609863,179.30604553223,435000,0}, ---- 4+ Parking Space -- El Burro Heights
	{15, 0,0,0, 0,0,0,1336.5550537109,-1578.9893798828,54.444213867188,209.46823120117,475000,0}, ---- 4+ Parking Space -- El Burro Heights
	{16, 0,0,0, 0,0,0,1302.2478027344,-527.8447265625,71.46068572998,136.67851257324,835000,0}, ---- 7+ Parking Space -- Mirror Park
	{17, 0,0,0, 0,0,0,1250.7996826172,-515.73504638672,69.349075317383,246.84382629395,520000,0}, ---- 4+ Parking Space -- Mirror Park
	{18, 0,0,0, 0,0,0,1265.6666259766,-457.69116210938,70.517112731934,282.04858398438,760000,0}, ---- 4+ Parking Space -- Mirror Park
	{19, 0,0,0, 0,0,0,1046.1868896484,-497.85861206055,64.079368591309,311.04293823242,715000,0}, ---- 2+ Parking Space -- Mirror Park
	{20, 0,0,0, 0,0,0,1056.4312744141,-448.87069702148,66.257514953613,306.15551757813,745000,0}, ---- 2+ Parking Space -- Mirror Park
	{21, 0,0,0, 0,0,0,987.21600341797,-433.12399291992,64.049476623535,242.9315032959,675000,0}, ---- 2+ Parking Space -- Mirror Park
	{22, 0,0,0, 0,0,0,902.72497558594,-615.71728515625,58.453330993652,257.05575561523,925000,0}, ---- 7+ Parking Space -- Mirror Park
	{23, 0,0,0, 0,0,0,1250.8028564453,-620.91131591797,69.572090148926,211.92008972168,650000,0}, ---- 4+ Parking Space -- Mirror Park
	{24, 0,0,0, 0,0,0,-902.23156738281,190.49835205078,69.446006774902,75.457527160645,2150000,0}, ---- 6+ Parking Space -- Rockford Hills
	{25, 0,0,0, 0,0,0,-1537.1003417969,130.22229003906,57.371322631836,143.0191192627,8750000,0}, ---- 10+ Parking Space -- Rockford Hills
	{26, 0,0,0, 0,0,0,-1570.4002685547,22.326471328735,59.553974151611,344.14636230469,2550000,0}, ---- 6+ Parking Space -- Rockford Hills
	{27, 0,0,0, 0,0,0,-830.41027832031,115.35816955566,56.036769866943,111.43560791016,2800000,0}, ---- 3+ Parking Space -- Rockford Hills
	{28, 0,0,0, 0,0,0,-1961.0875244141,211.61895751953,86.802848815918,288.62756347656,1750000,0}, ---- 6+ Parking Space -- Vinewood Hills
	{29, 0,0,0, 0,0,0,-1844.5389404297,322.79928588867,90.900634765625,93.83032989502,3250000,0}, ---- 6+ Parking Space -- Vinewood Hills
	{30, 0,0,0, 0,0,0,-1367.4370117188,610.63262939453,133.87699890137,279.49926757813,2200000,0}, ---- 4+ Parking Space -- Vinewood Hills
	{31, 0,0,0, 0,0,0,-904.55102539063,588.05395507813,101.19079589844,124.93965911865,4100000,0}, ---- 4+ Parking Space -- Vinewood Hills
	{32, 0,0,0, 0,0,0,-1089.9547119141,548.59167480469,103.63329315186,124.12354278564,2600000,0}, ---- 7+ Parking Space -- Vinewood Hills
	{33, 0,0,0, 0,0,0,-476.54763793945,647.51190185547,144.38679504395,8.2062568664551,5650000,0}, ---- 5+ Parking Space -- Vinewood Hills
	{34, 0,0,0, 0,0,0,-450.81530761719,395.22500610352,104.77893829346,61.435531616211,3500000,0}, ---- 5+ Parking Space -- Vinewood Hills
	{35, 0,0,0, 0,0,0,-311.93542480469,474.85098266602,111.82409667969,129.8311920166,5100000,0}, ---- 6+ Parking Space -- Vinewood Hills
	{36, 0,0,0, 0,0,0,315.65103149414,502.03860473633,153.1798248291,201.265625,4600000,0}, ---- 2+ Parking Space -- Vinewood Hills
	{37, 0,0,0, 0,0,0,-176.34536743164,970.28295898438,237.52886962891,266.38717651367,6300000,0}, ---- 2+ Parking Space -- Vinewood Hills
	{38, 0,0,0, 0,0,0,-1832.0043945313,-625.11773681641,10.921403884888,317.86672973633,950000,0}, ---- 2+ Parking Space -- Del Perro
	{39, 0,0,0, 0,0,0,-1946.4677734375,-543.83410644531,11.862724304199,304.26159667969,935000,0}, ---- 2+ Parking Space -- Del Perro
	{40, 0,0,0, 0,0,0,-3093.8383789063,349.35998535156,7.5448389053345,255.62097167969,1450000,0}, ---- 2+ Parking Space -- Banham Canyon
	{41, 0,0,0, 0,0,0,-3089.1279296875,220.96971130371,14.118478775024,324.62582397461,1395000,0}, ---- 2+ Parking Space -- Banham Canyon
	{42, 0,0,0, 0,0,0,-3016.9416503906,746.73480224609,27.784296035767,76.191123962402,2350000,0}, ---- 3+ Parking Space -- Banham Canyon
	{43, 0,0,0, 0,0,0,-2972.6022949219,642.44671630859,25.992126464844,82.21174621582,2390000,0}, ---- 2+ Parking Space -- Banham Canyon
	{44, 0,0,0, 0,0,0,-3251.3361816406,1027.5341796875,11.757699966431,261.33053588867,890000,0}, ---- 3+ Parking Space -- Chumash
	{45, 0,0,0, 0,0,0,-3225.8903808594,911.29986572266,13.993273735046,66.674240112305,875000,0}, ---- 4+ Parking Space -- Chumash
	{46, 0,0,0, 0,0,0,-26.520606994629,6597.1923828125,31.860795974731,38.512851715088,450000,0}, ---- 4+ Parking Space -- Paleto Bay
	{47, 0,0,0, 0,0,0,-130.54441833496,6552.0903320313,29.872648239136,257.10583496094,360000,0}, ---- 5+ Parking Space -- Paleto Bay
	{48, 0,0,0, 0,0,0,-213.54542541504,6396.1772460938,33.085113525391,51.667655944824,305000,0}, ---- 4+ Parking Space -- Paleto Bay
	{49, 0,0,0, 0,0,0,-229.55303955078,6445.6064453125,31.197437286377,115.0393371582,435000,0}, ---- 6+ Parking Space -- Paleto Bay
	{50, 0,0,0, 0,0,0,-302.11633300781,6327.0400390625,32.887489318848,45.252174377441,385000,0}, ---- 5+ Parking Space -- Paleto Bay
	{51, 0,0,0, 0,0,0,-437.39315795898,6272.6123046875,30.068271636963,250.91780090332,412500,0}, ---- 4+ Parking Space -- Paleto Bay
	{52, 0,0,0, 0,0,0,31.447917938232,6596.4375,32.822250366211,237.10383605957,292500,0}, ---- 3+ Parking Space -- Paleto Bay
	{53, 0,0,0, 0,0,0,1725.1474609375,4641.9365234375,43.875492095947,112.04682922363,177500,0}, ---- 2+ Parking Space -- Grapeseed
	{54, 0,0,0, 0,0,0,1406.9671630859,3656.1767578125,34.430511474609,69.346641540527,99950,0}, ---- 2+ Parking Space -- Sandy Shores
	{55, 0,0,0, 0,0,0,1774.5689697266,3743.1286621094,34.655464172363,103.5650100708,66500,0}, ---- 3+ Parking Space -- Sandy Shores
	{56, 0,0,0, 0,0,0,1843.5395507813,3777.9790039063,33.585388183594,68.309127807617,87250,0}, ---- 2+ Parking Space -- Sandy Shores
	{57, 0,0,0, 0,0,0,2152.9885253906,3360.1979980469,45.431449890137,185.45785522461,25750,0}, ---- 1+ Parking Space -- Miscellaneous
	{58, 0,0,0, 0,0,0,2200.5888671875,3318.0815429688,47.054660797119,286.90353393555,49500,0}, ---- 1+ Parking Space -- Miscellaneous
	{59, 0,0,0, 0,0,0,3725.2941894531,4525.6293945313,22.470500946045,146.1325378418,22500,0}, ---- 1+ Parking Space -- Miscellaneous
	{60, 0,0,0, 0,0,0,3807.7465820313,4478.5322265625,6.3653988838196,150.94761657715,37250,0}, ---- 1+ Parking Space -- Miscellaneous
	{61, 0,0,0, 0,0,0,2332.7746582031,2524.2177734375,46.62939453125,194.46472167969,29000,0}, ---- 2+ Parking Space -- Miscellaneous
	--{62, 0,0,0, 0,0,0,1323.3957519531,-582.88482666016,73.246383666992,346.30725097656,1200000,0}, -
	--{63, 0,0,0, 0,0,0,97.582374572754,-255.97975158691,47.489917755127,16.740756988525,160000,0}, -
	}

function sh.filemakehouse() ---------------------------------убрать спавн!
	--print("making house")
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
	--print("mkhtable"..#mkhtable)
	local file = io.open(savepath .. "savehouses", "w")
	io.output(file)
	for a, v in ipairs(mkhtable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
	end
	--print("file created - h")
	io.close(file)

end

function sh.updateh()
	--print("updating house")
	local updtable = {}
	if (#h > #htable) then
		--print(#h.." > "..#htable)
		local counter = (#htable + 1)
		while (counter <= #h) do
			table.insert(updtable, h[counter])
			--print("doing while, counter="..counter)
			counter = counter + 1
		end
	local file = io.open(savepath .. "savehouses", "a")
	io.output(file)
	for a, v in ipairs(updtable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
	end
	io.close(file)
	else --print("house up to date")
	end
	hupdated = true
	--print("updating house done")
	sh.loadfiles()
end

function sh.updateht()
	--print("updating hotel")
	local updtable = {}
	if (#ht > #httable) then
		--print(#ht.." > "..#httable)
		local counter = (#httable + 1)
		while (counter <= #ht) do
			table.insert(updtable, ht[counter])
			--print("doing while, counter="..counter)
			counter = counter + 1
		end
	local file = io.open(savepath .. "hotels", "a")
	io.output(file)
	for a, v in ipairs(updtable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
	end
	io.close(file)
	else --print("hotel up to date")
	end
	htupdated = true
	--print("updating hotel done")
	sh.loadfiles()
end

function sh.filemakehotel()

	local mkhottable = {}
	local i = 1
	while (i <= #ht) do
		table.insert(mkhottable, ht[i])
		i = i + 1
	end
	--print("mkhottable"..#mkhottable)
	local file = io.open(savepath .. "hotels", "w")
	io.output(file)
	for a, v in ipairs(mkhottable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
	end
	--print("file created - hot")
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
	--print("mkctable"..#mkctable)
	local file = io.open(savepath .. "custom", "w")
	io.output(file)
	for a, v in ipairs(mkctable) do
		local vdata = sh.tostring(v)
		io.write(vdata .. "\n")
	end
	--print("file created - cus")
	io.close(file)

end

function sh.loadfiles()
	--print("loadfiles")
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

	--print("files loaded")

end

function sh.getarrayh(str)
	local vals = {}
	for val in string.gmatch(str, '[^,]+') do
		table.insert(vals, val)
	end
	table.insert(htable, vals)
	--print("entries in htable:"..#htable)
end

function sh.getarrayht(str)
	local vals = {}
	for val in string.gmatch(str, '[^,]+') do
		table.insert(vals, val)
	end
	table.insert(httable, vals)
	--print("entries in httable:"..#httable)
end

function sh.getarrayc(str)
	local vals = {}
	for val in string.gmatch(str, '[^,]+') do
		table.insert(vals, val)
	end
	table.insert(ctable, vals)
	--print("entries in ctable:"..#ctable)
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

	--print("checking spawn")
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

	--print("checkspawn finished")

end

function sh.spawnplayer(sptype, array)

	CAM.DO_SCREEN_FADE_OUT(250)
	--print("spawnplayer")
	if (sptype == 1) then --print("1")
		ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(array[8]), tonumber(array[9]), tonumber(array[10]),true,true,true,true)
		ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(array[11]))
		TIME.SET_CLOCK_TIME(spawnhour, spawnminute, 0)
	elseif (sptype == 2) then --print("2")
		ENTITY.SET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(),tonumber(array[14]), tonumber(array[15]), tonumber(array[16]),true,true,true,true)
		ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(),tonumber(array[17]))
		TIME.SET_CLOCK_TIME(spawnhour, spawnminute, 0)
	end
	CAM.DO_SCREEN_FADE_IN(250)
	--print("spawnplayer end")
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
	--print("adding blips")

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

	--print("shblip"..#shblip)
	--print("phblip"..#phblip)
	--print("ohblip"..#ohblip)
	--print("ahtblip"..#ahtblip)
	--print("ohtblip"..#ohtblip)
	--print("forrent"..#forrent)
	--print("rented"..#rented)
	--print("cblip"..#cblip)
	--print("bliptable "..#bliptable)

end

function sh.clearblips()

	--print("clearing blips")
	local i = 1
	while (i <= #bliptable) do
		UI.REMOVE_BLIP(bliptable[i])
		--print("remove blip "..bliptable[i])
		i=i+1
	end
	wait(500)
	--print("blips cleared")

end

function sh.cancel()
	sh.shGUI.buttonCount = 0
	sh.shGUI.hidden = true
	wait(2750)
	stopproxtick = false
end

return sh
