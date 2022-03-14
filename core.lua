local name, ns = ...
local L = ns.L

local playerName = UnitName("player")

function ravGPS_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")
end

function ravGPS_OnEvent(self, event, arg, ...)
    if arg == name then
        if event == "ADDON_LOADED" then
            if not RAVGPS_version then
                ns:PrettyPrint(L.Install)
            elseif RAVGPS_version ~= ns.version then
                ns:PrettyPrint(L.Update)
            end
            RAVGPS_version = ns.version
        end
    end
end

SlashCmdList["RAVGPS"] = function(message, editbox)
    local a, b, c
    if message:match(",") then
        a, b, c = strsplit(",", message)
    else
        a, b, c = strsplit(" ", message)
    end
    if a == "version" or a == "v" then
        ns:PrettyPrint(L.Version)
    elseif a == "h" or a:match("help") then
        ns:PrettyPrint(L.Help)
    elseif a == "c" or a:match("clear") then
        C_Map.ClearUserWaypoint()
    elseif a == "s" or a:match("share") then
        ns:Share(a, b, c)
    else
        ns:Coordinates(a, b, c)
    end
end
SLASH_RAVGPS1 = "/gps"
SLASH_RAVGPS2 = "/wp"
