local name, ns = ...
local L = ns.L

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
    local a, b, c = strsplit(" ", message)
    if a == "version" or a == "v" then
        ns:PrettyPrint(L.Version)
    elseif a == "h" or string.match(a, "help") then
        ns:PrettyPrint(L.Help)
    elseif a == "c" or string.match(a, "clear") then
        C_Map.ClearUserWaypoint()
    else
        ns:Coordinates(a, b, c)
    end
end
SLASH_RAVGPS1 = "/wp"
