local name, ns = ...
local L = ns.L

function ns:PrettyPrint(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff" .. ns.color .. ns.name .. ":|r " .. message)
end

function ns:Coordinates(a, b, c)
    local mapID = c and a:gsub("#", "") or C_Map.GetBestMapForUnit("player")
    local x = c and b or a
    local y = c and c or b

    local mapInfo = C_Map.GetMapInfo(mapID)

    local placedOnParent = false
    -- Jump up parentMapIDs when unable to set a waypoint on current map
    -- Only do so when not explicitly passing in X and Y
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

    if x and y then
        x = tonumber(x) / 100
        y = tonumber(y) / 100
    else
        local coordinates = C_Map.GetPlayerMapPosition(mapID, "player")
        x = coordinates.x
        y = coordinates.y
    end

    if C_Map.CanSetUserWaypointOnMap(mapID) then
        C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapID, x, y))
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)

        if placedOnParent then
            print(L.ParentPlace)
        end
        ns:PrettyPrint(L.Place:format("|cffffff00|Hworldmap:" .. mapID .. ":" .. string.format("%.4f", x) * 10000 .. ":" .. string.format("%.4f", y) * 10000 .. "|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a |cffffff00" .. mapInfo.name .. " " .. string.format("%.4f", x) * 100 .. ", " .. string.format("%.4f", y) * 100 .. "|r]|h|r"))
    else
        ns:PrettyPrint(L.NoPlace)
    end
end

function ns:Share(a, b, c)
    local channel = b and ((b:lower() == "p" or b:lower() == "party") and "PARTY" or (b:lower() == "i" or b:lower() == "instance" or b:lower() == "r" or b:lower() == "raid") and "RAID" or (b:lower() == "g" or b:lower() == "guild") and "GUILD" or (b:lower() == "o" or b:lower() == "officer") and "OFFICER" or (b:lower() == "w" or b:lower() == "whisper") and "WHISPER" or nil) or IsInInstance() and "INSTANCE" or IsInRaid() and "RAID" or IsInGroup() and "PARTY" or nil
    local channelTarget = channel == "WHISPER" and (c and c or (UnitIsPlayer("target") and UnitName("target") or UnitName("player"))) or 1

    if channel and C_Map.HasUserWaypoint() then
        local waypoint = C_Map.GetUserWaypoint()

        C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(waypoint.uiMapID, waypoint.position.x, waypoint.position.y))

        local mapInfo = C_Map.GetMapInfo(waypoint.uiMapID)
        local mapName = mapInfo.name
        if mapInfo.parentMapID then
            local parentMapInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
            mapName = mapName .. ", " .. parentMapInfo.name
        end
        SendChatMessage(mapName .. " @ " .. string.format("%.4f", waypoint.position.x) * 100 .. ", " .. string.format("%.4f", waypoint.position.y) * 100 .. " " .. C_Map.GetUserWaypointHyperlink(), channel, _, channelTarget)
    else
        ns:PrettyPrint(L.NoWaypoint)
    end
end

-- Unlimited-distance waypoints by redefining function
local navStateToTargetAlpha = {
    [0] = 0,
    [1] = 0.6,
    [2] = 1,
}
function SuperTrackedFrame:GetTargetAlphaBaseValue()
    local distance = C_Navigation.GetDistance()
    local state = distance >= 999 and 1 or (distance >= 25 and distance <= 70) and 2 or C_Navigation.GetTargetState()
    local alpha = navStateToTargetAlpha[state]
    if alpha and alpha > 0 then
        if self.isClamped then
            return 1
        end
    end

    return alpha
end
