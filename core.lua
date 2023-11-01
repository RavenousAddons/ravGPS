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
                ns:PrettyPrint("This version adds the ability to add notes to your waypoint text:|n/wp #10 50 50 Treasure")
            elseif RAVGPS_version ~= ns.version then
                ns:PrettyPrint(L.Update)
                ns:PrettyPrint("This version adds the ability to add notes to your waypoint text:|n/wp #10 50 50 Treasure")
            end
            RAVGPS_version = ns.version
        end
    end
end

function ravGPS_OnAddonCompartmentClick(addonName, buttonName)
    if buttonName == "RightButton" then
        ns:Share()
        return
    end
    ns:Coordinates()
end

function ravGPS_OnAddonCompartmentEnter()
    GameTooltip:SetOwner(DropDownList1)
    GameTooltip:SetText(ns.name .. "        v" .. ns.version)
    GameTooltip:AddLine(" ", 1, 1, 1, true)
    GameTooltip:AddLine(L.AddonCompartmentTooltip1, 1, 1, 1, true)
    GameTooltip:AddLine(L.AddonCompartmentTooltip2, 1, 1, 1, true)
    GameTooltip:Show()
end

SlashCmdList["RAVGPS"] = function(message, editbox)
    local a, b, c, d
    if message:match(",") then
        a, b, c, d = strsplit(",", message)
    else
        a, b, c, d = strsplit(" ", message)
    end

    if a == "version" or a == "v" then
        ns:PrettyPrint(L.Version)
    elseif a == "h" or a:match("help") then
        ns:PrettyPrint(L.Help)
    elseif a == "c" or a:match("clear") then
        C_Map.ClearUserWaypoint()
    elseif a == "s" or a:match("share") then
        ns:Share(b, c)
    else
        ns:Coordinates(a, b, c, d)
    end
end
SLASH_RAVGPS1 = "/" .. ns.command
SLASH_RAVGPS2 = "/gps"
SLASH_RAVGPS3 = "/ravgps"
