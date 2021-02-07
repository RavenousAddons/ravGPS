local name, ns = ...
local L = ns.L

local playerName = UnitName("player")
local faction, _ = UnitFactionGroup("player")

function ns:PrettyPrint(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff" .. ns.color .. ns.name .. ":|r " .. message)
end

function ns:Coordinates(a, b, c)
    local waypoint = C_Map.GetUserWaypoint()
    local mapID = C_Map.GetBestMapForUnit("player")
    local mapInfo = C_Map.GetMapInfo(mapID)
    local channel = a and ((a:lower() == "p" or a:lower() == "party") and "PARTY" or (a:lower() == "i" or a:lower() == "instance" or a:lower() == "r" or a:lower() == "raid") and "RAID" or (a:lower() == "g" or a:lower() == "guild") and "GUILD" or (a:lower() == "o" or a:lower() == "officer") and "OFFICER" or (a:lower() == "w" or a:lower() == "whisper") and "WHISPER" or nil) or nil
    local channelTarget = a and (b and b or 1) or playerName
    local x = channel == nil and a or nil
    local y = channel == nil and b or nil
    if c then
        mapID = a
        x = b
        y = c
    end
    local placedOnParent = false
    local targetName, _ = UnitName("target")
    local hp, hpMax = UnitHealth("target"), UnitHealthMax("target")
    local targetHP = hp < hpMax and " (" .. math.floor(hp / hpMax * 100) .. "%)" or ""
    -- Jump up parentMapIDs when unable to set a waypoint on current map
    -- Only do so when not explicitly setting X and Y
    if not x and not y then
        while (not C_Map.CanSetUserWaypointOnMap(mapID)) do
            if mapInfo.parentMapID then
                placedOnParent = true
                mapID = mapInfo.parentMapID
                mapInfo = C_Map.GetMapInfo(mapID)
            else
                break
            end
        end
    end
    local coordinates = C_Map.GetPlayerMapPosition(mapID, "player")
    if x and y then
        coordinates.x = x / 100
        coordinates.y = y / 100
    end
    if coordinates and C_Map.CanSetUserWaypointOnMap(mapID) then
        C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapID, coordinates.x, coordinates.y))
        if placedOnParent then
            print(L.ParentPlace)
        end
        message = ((targetName and targetName ~= playerName) and string.format(L.MessageTarget, targetName, targetHP) or (x and y) and L.MessageManual or L.MessagePlayer) .. mapInfo.name .. " " .. string.format("%.4f", coordinates.x) * 100 .. " " .. string.format("%.4f", coordinates.y) * 100 .. " " .. C_Map.GetUserWaypointHyperlink()
        if channel then
            SendChatMessage(message, channel, _, channelTarget)
        else
            ns:PrettyPrint(message)
        end
        if x and y then
            C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        elseif waypoint then
            C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(waypoint.uiMapID, waypoint.position.x, waypoint.position.y))
        else
            C_Map.ClearUserWaypoint()
        end
    else
        ns:PrettyPrint(L.NoPlace)
    end
end
