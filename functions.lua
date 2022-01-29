local name, ns = ...
local L = ns.L

local playerName = UnitName("player")

function ns:PrettyPrint(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff" .. ns.color .. ns.name .. ":|r " .. message)
end

function ns:Coordinates(a, b, c)
    local waypoint = C_Map.GetUserWaypoint()
    local mapID = C_Map.GetBestMapForUnit("player")
    local mapInfo = C_Map.GetMapInfo(mapID)
    local channel = a and ((a:lower() == "p" or a:lower() == "party") and "PARTY" or (a:lower() == "i" or a:lower() == "instance" or a:lower() == "r" or a:lower() == "raid") and "RAID" or (a:lower() == "g" or a:lower() == "guild") and "GUILD" or (a:lower() == "o" or a:lower() == "officer") and "OFFICER" or (a:lower() == "w" or a:lower() == "whisper") and "WHISPER" or nil) or nil
    local channelTarget = a and (b and b or 1) or playerName
    if channel == "WHISPER" and channelTarget == 1 then
        channelTarget = playerName
    end
    local x = channel == nil and a or nil
    local y = channel == nil and b or nil
    if c then
        mapID = a
        x = b
        y = c
    end
    local placedOnParent = false
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
        if channel then
            SendChatMessage(mapInfo.name .. " " .. string.format("%.4f", coordinates.x) * 100 .. " " .. string.format("%.4f", coordinates.y) * 100 .. " " .. C_Map.GetUserWaypointHyperlink(), channel, _, channelTarget)
        else
            ns:PrettyPrint(string.format(L.Place, "|cffffd100|Hworldmap:" .. mapID .. ":" .. string.format("%.4f", coordinates.x) * 10000 .. ":" .. string.format("%.4f", coordinates.y) * 10000 .. "|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a |cffeeeeee" .. mapInfo.name .. "|r |cffbbbbbb" .. string.format("%.4f", coordinates.x) * 100 .. ", " .. string.format("%.4f", coordinates.y) * 100 .. "|r]|h|r"))
        end
        if x and y then
            C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        elseif waypoint then
            C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(waypoint.uiMapID, waypoint.position.x, waypoint.position.y))
        else
            C_Map.ClearUserWaypoint()
        end
        if TomTom and not channel then
            TomTom:AddWaypoint(mapID, coordinates.x, coordinates.y, {
                title = "Waypoint",
                from = "|cff" .. ns.color .. ns.name .. "|r",
                cleardistance = 0,
            })
        end
    else
        ns:PrettyPrint(L.NoPlace)
    end
end
