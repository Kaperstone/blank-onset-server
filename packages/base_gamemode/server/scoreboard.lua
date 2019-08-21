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

AddRemoteEvent("scoreboard:getdata", function(player)
	local PlayerTable = { } -- Initlize the table we collect all the player information to
	
	-- Loop through all the players connected
	for _, player in ipairs(GetAllPlayers()) do
		if PlayerData[player] ~= nil then
			-- Collect
			PlayerTable[player] = {
				player,
				GetPlayerName(player),
				PlayerData[player].kills,
				PlayerData[player].deaths,
				PlayerData[player].bounty,
				GetPlayerPing(player)
			}
		end
	end
	
	-- Calling the second phase of updating the scoreboard
	CallRemoteEvent(player, "scoreboard:update", GetServerName(), GetPlayerCount(), GetMaxPlayers(), PlayerTable)
end)
