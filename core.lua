local ADDON_NAME, ns = ...
local L = ns.L

function ravGPS_OnLoad(self)
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function ravGPS_OnEvent(self, event, arg, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        local isInitialLogin, isReloadingUi = ...
        if not RAVGPS_version then
            ns:PrettyPrint(L.Install)
        elseif RAVGPS_version ~= ns.version then
            -- Version-specific messages go here...
        end
        RAVGPS_version = ns.version
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end

AddonCompartmentFrame:RegisterAddon({
    text = ns.name,
    icon = ns.icon,
    registerForAnyClick = true,
    notCheckable = true,
    func = function(button, menuInputData, menu)
        local mouseButton = menuInputData.buttonName
        if mouseButton == "RightButton" then
            ns:Share()
            return
        end
        ns:Coordinates()
    end,
    funcOnEnter = function(menuItem)
        GameTooltip:SetOwner(menuItem)
        GameTooltip:SetText(ns.name .. "        v" .. ns.version)
        GameTooltip:AddLine(" ", 1, 1, 1, true)
        GameTooltip:AddLine(L.AddonCompartmentTooltip1, 1, 1, 1, true)
        GameTooltip:AddLine(L.AddonCompartmentTooltip2, 1, 1, 1, true)
        GameTooltip:Show()
    end,
    funcOnLeave = function()
        GameTooltip:Hide()
    end,
})

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
