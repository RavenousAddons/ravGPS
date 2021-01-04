local name, ravGPS = ...
local L = ravGPS.L

function ravGPS_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("CHAT_MSG_ADDON")
end

function ravGPS_OnEvent(self, event, arg, ...)
    if arg == name then
        if event == "ADDON_LOADED" then
            -- ravGPS:SetDefaultOptions()
            if not RAVGPS_version then
                ravGPS:PrettyPrint(L.Install)
            elseif RAVGPS_version ~= ravGPS.version then
                ravGPS:PrettyPrint(L.Update)
            end
            if not RAVGPS_version or RAVGPS_version ~= ravGPS.version then
                RAVGPS_seenUpdate = false
            end
            RAVGPS_version = ravGPS.version
            C_ChatInfo.RegisterAddonMessagePrefix(name)
            ravGPS:SendVersion()
        elseif event == "CHAT_MSG_ADDON" and RAVGPS_seenUpdate == false then
            local message, _ = ...
            local a, b, c = strsplit(".", ravGPS.version)
            local d, e, f = strsplit(".", message)
            if (d > a) or (d == a and e > b) or (d == a and e == b and f > c) then
                ravGPS:PrettyPrint(L.OutOfDate)
                RAVGPS_seenUpdate = true
            end
        end
    end
end

SlashCmdList["RAVGPS"] = function(message, editbox)
    local a, b, c = strsplit(" ", message)
    if a == "version" or a == "v" then
        ravGPS:PrettyPrint(L.Version)
        ravGPS:SendVersion()
    elseif a == "h" or string.match(a, "help") then
        ravGPS:PrettyPrint(L.Help)
    elseif a == "c" or string.match(a, "clear") then
        C_Map.ClearUserWaypoint()
    else
        ravGPS:coordinates(a, b, c)
    end
end
SLASH_RAVGPS1 = "/" .. ravGPS.command
SLASH_RAVGPS2 = "/ravGPS"
