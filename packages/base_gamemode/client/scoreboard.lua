--[[
	This is a modified version of the original scoreboard provided by Blue Mountains <https://github.com/BlueMountainsIO>

	

	Copyright (C) 2019 Blue Mountains GmbH

	This program is free software: you can redistribute it and/or modify it under the terms of the Onset
	Open Source License as published by Blue Mountains GmbH.

	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
	even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	See the Onset Open Source License for more details.

	You should have received a copy of the Onset Open Source License along with this program. If not,
	see https://bluemountains.io/Onset_OpenSourceSoftware_License.txt
]]--

-- Creating private variable for the gui, so we can modify it
local scoreboard
-- Remember that this is the client side
-- We don't need to specify the player we interact with

local function OnPackageStart()
	-- Creates the scoreboard gui
	scoreboard = CreateWebUI(0.0, 0.0, 0.0, 0.0, 5, 10)

	-- Attach's the web code to the gui
	LoadWebFile(scoreboard, "http://asset/"..GetPackageName().."/gui/scoreboard/scoreboard.html")

	-- We don't want it too big or fullscreen
	SetWebSize(scoreboard, 1065, 600)

	-- The fuck is this.
	SetWebAlignment(scoreboard, 0.5, 0.5)
	
	-- Creates limited window
	SetWebAnchors(scoreboard, 0.5, 0.5, 0.5, 0.5)

	-- By default, it should be hidden until the tab key is pressed
	SetWebVisibility(scoreboard, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStart)

local function OnPackageStop()
	-- We don't need the gui anymore
	-- Lets remove stuff properly
	DestroyWebUI(scoreboard)
end
AddEvent("OnPackageStop", OnPackageStop)

--- If you wish to notify the player that he changed resolution
-- If they haven't guessed it till now.
-- function OnResolutionChange(width, height)
-- 	AddPlayerChat("Resolution changed to "..width.."x"..height)
-- end
-- AddEvent("OnResolutionChange", OnResolutionChange)

-- Create private functions that can be used only within this file.

local function OnKeyPress(key)
	-- When the player presses the tab button
	if key == "Tab" then
		-- Get updated player data
		CallRemoteEvent("scoreboard:getdata")

		-- Show the scoreboard to the player to show that its working and responsive.
		SetWebVisibility(scoreboard, WEB_VISIBLE)
	end
end
AddEvent("OnKeyPress", OnKeyPress)

local function OnKeyRelease(key)
	-- When the finger get's hurt and he releases the tab key
	if key == "Tab" then
		SetWebVisibility(scoreboard, WEB_HIDDEN)
	end
end
AddEvent("OnKeyRelease", OnKeyRelease)

function OnGetScoreboardData(servername, playercount, maxplayers, players)
	-- Set basic infroamtion
	ExecuteWebJS(scoreboard, "SetServerName('"..servername.."');")
	ExecuteWebJS(scoreboard, "SetPlayerCount("..playercount..", "..maxplayers..");")

	-- Reset the player list
	ExecuteWebJS(scoreboard, "RemovePlayers();")

	-- Loop through all the players and add each of them to the list
	for player, data in ipairs(players) do
		-- Add all the players to the webgui
		ExecuteWebJS(scoreboard, "AddPlayer("..player..", '"..data[1].."', "..data[2]..", "..data[3]..", '"..data[4].."', "..data[5]..");")
	end
end
AddRemoteEvent("scoreboard:update", OnGetScoreboardData)
