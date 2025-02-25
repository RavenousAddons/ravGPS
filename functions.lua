local ADDON_NAME, ns = ...
local L = ns.L

-- Return a Map ID (loops if passed Map Name)
local function getMapID(input)
    input = input:gsub("#", "")
    if tonumber(input, 10) == nil then
        for i = 1, 2225, 1 do
            local mapInfo = C_Map.GetMapInfo(i)
            if type(mapInfo) == "table" and mapInfo.name and mapInfo.name:upper():gsub("%s+", ""):match(input:upper():gsub("%s+", "")) then
                return mapInfo.mapID
            end
        end
    end
    return input
end

-- x y
-- m x y
-- x y n
-- m x y n

function ns:Coordinates(a, b, c, d)
    if a == nil or #a == 0 then
        a = nil
    end
    local mapID, x, y, note
    if d then
        mapID = getMapID(a)
        x = b
        y = c
        note = d
    elseif c then
        if tonumber(c, 10) == nil then
            mapID = C_Map.GetBestMapForUnit("player")
            x = a
            y = b
            note = c
        else
            mapID = getMapID(a)
            x = b
            y = c
        end
    else
        mapID = C_Map.GetBestMapForUnit("player")
        x = a
        y = b
    end

    local mapInfo = C_Map.GetMapInfo(mapID)

    local placedOnParent = false
    -- Jump up parentMapIDs when unable to set a waypoint on current map
    -- Only do so when not explicitly passing in X and Y
    if x == nil and y == nil then
        while not C_Map.CanSetUserWaypointOnMap(mapID) or not C_Map.GetPlayerMapPosition(mapID, "player") do
            if type(mapInfo) == "table" and mapInfo.parentMapID then
                placedOnParent = true
                mapID = mapInfo.parentMapID
                mapInfo = C_Map.GetMapInfo(mapID)
            else
                break
            end
        end
    end

    if mapID == 0 then
        ns:PrettyPrint(L.NoPlace)
        return
    end

    if x and y then
        x = tonumber(x) / 100
        y = tonumber(y) / 100
    else
        local coordinates = C_Map.GetPlayerMapPosition(mapID, "player")
        x = type(coordinates) == "table" and coordinates.x or nil
        y = type(coordinates) == "table" and coordinates.y or nil
    end

    if x and y and C_Map.CanSetUserWaypointOnMap(mapID) then
        C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapID, x, y))
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)

        if placedOnParent then
            print(L.ParentPlace)
        end
        ns:PrettyPrint(L.Place:format("|cffffff00|Hworldmap:" .. mapID .. ":" .. string.format("%.4f", x) * 10000 .. ":" .. string.format("%.4f", y) * 10000 .. "|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a |cffffff00" .. mapInfo.name .. " " .. string.format("%.4f", x) * 100 .. ", " .. string.format("%.4f", y) * 100 .. (note and (" " .. note .. " ") or "") .. "|r]|h|r"))
    else
        ns:PrettyPrint(L.NoPlace)
    end
end

local function GetChannelInfo(c, t)
    if tonumber(c, 10) ~= nil then
        local target, _ = GetChannelName(c)

        return "CHANNEL", target
    elseif type(c) == "string" and #c:gsub("%s+", "") then
        c = c:upper():gsub("%s+", "")

        local channel = nil
        local target = 1

        channel = (c == "B" or c == "BG" or c == "BATTLEGROUND") and "BATTLEGROUND" or channel
        channel = (c == "G" or c == "GUILD") and "GUILD" or channel
        channel = (c == "I" or c == "INSTANCE" or c == "INSTANCECHAT" or c == "INSTANCE_CHAT") and "INSTANCE_CHAT" or channel
        channel = (c == "O" or c == "OFFICER") and "OFFICER" or channel
        channel = (c == "P" or c == "PARTY") and "PARTY" or channel
        channel = (c == "R" or c == "RAID") and "RAID" or channel
        channel = (c == "RW" or c == "RAIDWARNING" or c == "RAID_WARNING") and "RAID_WARNING" or channel
        channel = (c == "S" or c == "SAY") and "SAY" or channel
        channel = (c == "W" or c == "WHISPER") and "WHISPER" or channel

        if channel == "INSTANCE_CHAT" then
            channel = UnitInBattleground("player") and "BATTLEGROUND" or IsInInstance() and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY" or nil
        end

        if channel == "WHISPER" then
            target = t and t or UnitIsPlayer("target") and UnitName("target") or UnitName("player")
        end

        return channel, target
    elseif UnitInBattleground("player") or IsInInstance() or IsInRaid() or IsInGroup() then
        local channel = UnitInBattleground("player") and "BATTLEGROUND" or IsInInstance() and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY"

        return channel, 1
    end
    return nil, 1
end

function ns:Share(channel, target)
    if C_Map.HasUserWaypoint() then
        channel, target = GetChannelInfo(channel, target)

        if channel and target then
            local waypoint = C_Map.GetUserWaypoint()

            local mapInfo = C_Map.GetMapInfo(waypoint.uiMapID)
            local mapName = mapInfo.name
            if mapInfo.parentMapID then
                local parentMapInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
                mapName = mapName .. ", " .. parentMapInfo.name
            end
            SendChatMessage(mapName .. " @ " .. string.format("%.4f", waypoint.position.x) * 100 .. ", " .. string.format("%.4f", waypoint.position.y) * 100 .. " " .. C_Map.GetUserWaypointHyperlink(), channel, _, target)
        else
            ns:PrettyPrint(L.NoShareChannel)
        end
    else
        ns:PrettyPrint(L.NoShareMapPin)
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
