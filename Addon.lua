---
-- Ravenous GPS
--   Let people know where you/your target are!
-- Author: waldenp0nd
-- License: Public Domain
---
local name, ravGPS = ...

local defaults = {
    COMMAND = "wp",
    LOCALE =  "enUS"
}

local guild, _, _, _ = GetGuildInfo("player")

local function prettyPrint(message, full)
    if full == false then
        message = message .. ":"
    end
    local prefix = "|cffff6b6b" .. ravGPS.name .. (full and " " or ":|r ")
    print(prefix .. message)
end

local function sendVersionData()
    C_ChatInfo.SendAddonMessage(name, RAVGPS_version, "YELL")
    C_ChatInfo.SendAddonMessage(name, RAVGPS_version, "PARTY")
    C_ChatInfo.SendAddonMessage(name, RAVGPS_version, "RAID")
    if guild then
        C_ChatInfo.SendAddonMessage(name, RAVGPS_version, "GUILD")
    end
end

local function coordinates(a, b)
    local channel = a and ((a:lower() == "p" or a:lower() == "party") and "PARTY" or (a:lower() == "i" or a:lower() == "instance" or a:lower() == "r" or a:lower() == "raid") and "RAID" or (a:lower() == "g" or a:lower() == "guild") and "GUILD" or (a:lower() == "o" or a:lower() == "officer") and "OFFICER" or (a:lower() == "w" or a:lower() == "whisper") and "WHISPER" or nil) or nil
    local channelTarget = a and (b and b or 1) or playerName
    local targetName, _ = UnitName("target")
    local waypoint = C_Map.GetUserWaypoint()
    local mapID = C_Map.GetBestMapForUnit("player")
    local mapInfo = C_Map.GetMapInfo(mapID)
    local placedOnParent = false
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
            print(string.format(ravGPS.locales[ravGPS.locale].parentplace, ravGPS.name))
        end
        message = ((targetName and targetName ~= playerName) and string.format(ravGPS.locales[ravGPS.locale].messages.target, targetName) or ravGPS.locales[ravGPS.locale].messages.player) .. mapInfo.name .. " " .. string.format("%.4f", coordinates.x) * 100 .. ", " .. string.format("%.4f", coordinates.y) * 100 .. " " .. C_Map.GetUserWaypointHyperlink()
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
        prettyPrint(ravGPS.locales[ravGPS.locale].cantplace)
    end
end

SLASH_RAVGPS1 = "/" .. defaults.COMMAND
SLASH_RAVGPS2 = "/ravgps"
local function slashHandler(message, editbox)
    local command, argument, _ = strsplit(" ", message)
    if command == "version" or command == "v" then
        prettyPrint(string.format(ravGPS.locales[ravGPS.locale].version, ravGPS.version))
        sendVersionData()
    elseif command == "help" or command == "h" then
        prettyPrint(ravGPS.locales[ravGPS.locale].help[1])
        print(string.format(ravGPS.locales[ravGPS.locale].help[2], defaults.COMMAND))
        print(string.format(ravGPS.locales[ravGPS.locale].help[3], defaults.COMMAND, defaults.COMMAND))
        print(string.format(ravGPS.locales[ravGPS.locale].help[4], ravGPS.name))
        print(string.format(ravGPS.locales[ravGPS.locale].help[5], ravGPS.discord))
    else
        coordinates(command, argument)
    end
end
SlashCmdList["RAVGPS"] = slashHandler

local function OnEvent(self, event, arg, ...)
    if arg == name then
        if event == "ADDON_LOADED" then
            ravGPS.locale = GetLocale()
            if not ravGPS.locales[ravGPS.locale] then
                ravGPS.locale = defaults.LOCALE
            end
            if not RAVGPS_version then
                prettyPrint(string.format(ravGPS.locales[ravGPS.locale].load.install, ravGPS.name))
            elseif RAVGPS_version ~= ravGPS.version then
                prettyPrint(string.format(ravGPS.locales[ravGPS.locale].load.update, ravGPS.version))
            end
            if not RAVGPS_version or RAVGPS_version ~= ravGPS.version then
                print(string.format(ravGPS.locales[ravGPS.locale].help[2], defaults.COMMAND))
                print(string.format(ravGPS.locales[ravGPS.locale].help[3], defaults.COMMAND, defaults.COMMAND))
                print(string.format(ravGPS.locales[ravGPS.locale].load.both, defaults.COMMAND))
                RAV_seenUpdate = false
            end
            RAVGPS_version = ravGPS.version
            C_ChatInfo.RegisterAddonMessagePrefix(name)
            sendVersionData()
        elseif event == "CHAT_MSG_ADDON" and RAVGPS_seenUpdate == false then
            local message, _ = ...
            local a, b, c = strsplit(".", ravGPS.version)
            local d, e, f = strsplit(".", message)
            if (d > a) or (d == a and e > b) or (d == a and e == b and f > c) then
                prettyPrint(string.format(ravGPS.locales[ravGPS.locale].load.outofdate, ravGPS.name))
                RAVGPS_seenUpdate = true
            end
        end
    end
end
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("CHAT_MSG_ADDON")
f:SetScript("OnEvent", OnEvent)
