-------------------------------------------------------------------------------------
------------------------------------Version 0.8.7------------------------------------
-------------------------------------------------------------------------------------
-------------------Created by Kopalov with help from Henny Smafter-------------------
-------------------------------------------------------------------------------------
local GUI = {}
local modversion = "0.8.7"
GUI.GUI = {}
GUI.buttonCount = 0
GUI.loaded = false
GUI.selection = 0
GUI.time = 0
GUI.hidden = false
function GUI.addButton(name, func,args, xmin, xmax, ymin, ymax)
	GUI.selection = 0
	print("Added Button"..name )
	GUI.GUI[GUI.buttonCount+1] = {}
	GUI.GUI[GUI.buttonCount+1]["name"] = name
	GUI.GUI[GUI.buttonCount+1]["func"] = func
	GUI.GUI[GUI.buttonCount+1]["args"] = args
	GUI.GUI[GUI.buttonCount+1]["active"] = false
	GUI.GUI[GUI.buttonCount+1]["xmin"] = xmin
	GUI.GUI[GUI.buttonCount+1]["ymin"] = ymin * (GUI.buttonCount + 0.01) +0.02
	GUI.GUI[GUI.buttonCount+1]["xmax"] = xmax
	GUI.GUI[GUI.buttonCount+1]["ymax"] = ymax
	GUI.buttonCount = GUI.buttonCount+1
end
--Added for GUI
function GUI.updateButtonStatus(status)
	GUI.GUI[GUI.selection+1]["name"] = string.gsub( GUI.GUI[GUI.selection+1]["name"], "%a+$", status, 1 )
end

function GUI.unload()
end
function GUI.init()

	GUI.loaded = true
end
function GUI.tick()
	if(not GUI.hidden)then
		if( GUI.time == 0) then
			GUI.time = GAMEPLAY.GET_GAME_TIMER()
		end
		if((GAMEPLAY.GET_GAME_TIMER() - GUI.time)> 100) then
			GUI.updateSelection()
		end
		GUI.renderGUI()
		if(not GUI.loaded ) then
			GUI.init()
		end
	end
end

function GUI.updateSelection() --77
	if(get_key_pressed(Keys.NumPad2)) or (enablecontroller and (CONTROLS.IS_CONTROL_PRESSED(2,77)) and  (CONTROLS.IS_CONTROL_PRESSED(2,4))) then
		if(GUI.selection < GUI.buttonCount -1  )then
			GUI.selection = GUI.selection +1
			GUI.time = 0
		end
	elseif (get_key_pressed(Keys.NumPad8)) or (enablecontroller and (CONTROLS.IS_CONTROL_PRESSED(2,77)) and (CONTROLS.IS_CONTROL_PRESSED(2,3))) then
		if(GUI.selection > 0)then
			GUI.selection = GUI.selection -1
			GUI.time = 0
		end
	elseif (get_key_pressed(Keys.NumPad5)) or (enablecontroller and (CONTROLS.IS_CONTROL_PRESSED(2,77)) and (CONTROLS.IS_CONTROL_PRESSED(2,70))) then
		if(type(GUI.GUI[GUI.selection +1]["func"]) == "function") then
			GUI.GUI[GUI.selection +1]["func"](GUI.GUI[GUI.selection +1]["args"])
		else
			print(type(GUI.GUI[GUI.selection]["func"]))
		end
		GUI.time = 0
	end
	local iterator = 0
	for id, settings in ipairs(GUI.GUI) do
		GUI.GUI[id]["active"] = false
		if(iterator == GUI.selection ) then
			GUI.GUI[iterator +1]["active"] = true
		end
		iterator = iterator +1
	end
end

function GUI.renderGUI()
	 GUI.renderButtons()
end
function GUI.renderBox(xMin,xMax,yMin,yMax,color1,color2,color3,color4)
	GRAPHICS.DRAW_RECT(xMin, yMin,xMax, yMax, color1, color2, color3, color4);
end

function GUI.renderButtons()
	-- Changed for GUI
	for id, settings in pairs(GUI.GUI) do
		local screen_w = 0
		local screen_h = 0
		screen_w, screen_h =  GRAPHICS.GET_SCREEN_RESOLUTION(0, 0)
		boxColor = {30,32,29,150}
		--boxColor = {70,95,95,250}
		if(settings["active"]) then
			boxColor = {92,137,166,160}
			--boxColor = {218,242,216,255}
		end
		UI.SET_TEXT_FONT(2)
		UI.SET_TEXT_SCALE(0.0, 0.5)
		UI.SET_TEXT_COLOUR(255, 255, 255, 255)
		UI.SET_TEXT_CENTRE(false)
		UI.SET_TEXT_DROPSHADOW(255, 255, 255, 255, 100)
		UI.SET_TEXT_EDGE(0, 0, 0, 0, 0)
		UI._SET_TEXT_ENTRY("STRING")
		UI._ADD_TEXT_COMPONENT_STRING(settings["name"])
		UI._DRAW_TEXT(settings["xmin"]+ 0.02, (settings["ymin"]  + 0.075 - 0.0125 ))
		--UI._DRAW_TEXT(settings["xmin"]+ 0.00, (settings["ymin"]  + 0.035 - 0.0125 ))
		UI._ADD_TEXT_COMPONENT_STRING(settings["name"])
		GUI.renderBox(settings["xmin"] ,settings["xmax"], settings["ymin"] + 0.075, settings["ymax"] - 0.0,boxColor[1],boxColor[2],boxColor[3],boxColor[4])
		--GUI.renderBox(settings["xmin"] ,settings["xmax"], settings["ymin"] + 0.035, settings["ymax"] - 0.01,30,32,29,150)
		--GUI.renderBox(settings["xmin"] ,settings["xmax"], settings["ymin"] + 0.035, settings["ymax"] - 0.01,boxColor[1],boxColor[2],boxColor[3],boxColor[4])
	end

	UI.SET_TEXT_FONT(1)
 	UI.SET_TEXT_SCALE(0.0, 0.60)
 	UI.SET_TEXT_COLOUR(255, 255, 255, 255)
 	UI.SET_TEXT_CENTRE(false)
 	UI.SET_TEXT_DROPSHADOW(255, 255, 255, 255, 100)
 	UI.SET_TEXT_EDGE(0, 0, 0, 0, 0)
 	UI._SET_TEXT_ENTRY("STRING")
 	UI._ADD_TEXT_COMPONENT_STRING("The Savehouse Mod")
 	UI._DRAW_TEXT(0.01+ 0.01, (0.025  + 0.00 - 0.0125 ))
 	GUI.renderBox(0.01,0.31,0.0,0.13 - 0.00,52,93,149,240)
 	
 	GUI.version_box()
 	
end

function GUI.version_box()
	
	UI.SET_TEXT_FONT(1)
 	UI.SET_TEXT_SCALE(0.0, 0.60)
 	UI.SET_TEXT_COLOUR(255, 255, 255, 255)
 	UI.SET_TEXT_CENTRE(false)
 	UI.SET_TEXT_RIGHT_JUSTIFY(true)
 	UI.SET_TEXT_DROPSHADOW(255, 255, 255, 255, 100)
 	UI.SET_TEXT_EDGE(0, 0, 0, 0, 0)
 	UI._SET_TEXT_ENTRY("STRING")
 	UI._ADD_TEXT_COMPONENT_STRING("Mod Version is "..modversion)
 	UI._DRAW_TEXT(0.9,0.95)
	
end

return GUI
