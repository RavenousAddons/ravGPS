local name, ravGPS = ...
local L = ravGPS.L

local faction, _ = UnitFactionGroup("player")

function ravGPS:PrettyPrint(message, full)
    if full == false then
        message = message .. ":"
    end
    local prefix = "|cff" .. ravGPS.color .. ravGPS.name .. (full and " " or ":|r ")
    DEFAULT_CHAT_FRAME:AddMessage(prefix .. message)
end

function ravGPS:SendVersion()
    local inInstance, _ = IsInInstance()
    if inInstance then
        C_ChatInfo.SendAddonMessage(name, RAVGPS_version, "INSTANCE_CHAT")
    elseif IsInGroup() then
        if GetNumGroupMembers() > 5 then
            C_ChatInfo.SendAddonMessage(name, RAVGPS_version, "RAID")
        end
        C_ChatInfo.SendAddonMessage(name, RAVGPS_version, "PARTY")
    end
    local guildName, _, _, _ = GetGuildInfo("player")
    if guildName then
        C_ChatInfo.SendAddonMessage(name, RAVGPS_version, "GUILD")
    end
end

function ravGPS:coordinates(a, b)
    local channel = a and ((a:lower() == "p" or a:lower() == "party") and "PARTY" or (a:lower() == "i" or a:lower() == "instance" or a:lower() == "r" or a:lower() == "raid") and "RAID" or (a:lower() == "g" or a:lower() == "guild") and "GUILD" or (a:lower() == "o" or a:lower() == "officer") and "OFFICER" or (a:lower() == "w" or a:lower() == "whisper") and "WHISPER" or nil) or nil
    local channelTarget = a and (b and b or 1) or playerName
    local waypoint = C_Map.GetUserWaypoint()
    local mapID = C_Map.GetBestMapForUnit("player")
    local mapInfo = C_Map.GetMapInfo(mapID)
    local placedOnParent = false
    local targetName, _ = UnitName("target")
    local hp, hpMax = UnitHealth("target"), UnitHealthMax("target")
    local targetHP = hp < hpMax and " (" .. math.floor(hp / hpMax * 100) .. "%)" or ""
    -- Jump up parentMapIDs when unable to set a waypoint on current map
    while (not C_Map.CanSetUserWaypointOnMap(mapID)) do
        if mapInfo.parentMapID then
            placedOnParent = true
            mapID = mapInfo.parentMapID
            mapInfo = C_Map.GetMapInfo(mapID)
        else
            break
        end
    end
    local coordinates = C_Map.GetPlayerMapPosition(mapID, "player")
    if coordinates and C_Map.CanSetUserWaypointOnMap(mapID) then
        C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapID, coordinates.x, coordinates.y))
        if placedOnParent then
            print(L.ParentPlace)
        end
        message = ((targetName and targetName ~= playerName) and string.format(L.MessageTarget, targetName, targetHP) or L.MessagePlayer) .. mapInfo.name .. " " .. string.format("%.4f", coordinates.x) * 100 .. " " .. string.format("%.4f", coordinates.y) * 100 .. " " .. C_Map.GetUserWaypointHyperlink()
        if channel then
            SendChatMessage(message, channel, _, channelTarget)
        else
            print(message)
        end
        if waypoint then
            C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(waypoint.uiMapID, waypoint.position.x, waypoint.position.y))
        else
            C_Map.ClearUserWaypoint()
        end
    else
        ravGPS:PrettyPrint(L.NoPlace)
    end
end
