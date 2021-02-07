local name, ns = ...
local L = {}
ns.L = L

setmetatable(L, { __index = function(t, k)
    local v = tostring(k)
    t[k] = v
    return v
end })

L.Version = ns.version .. " is the current version."
L.OutOfDate = "There is an update available for |cff" .. ns.color .. ns.name .. "|r! Please go to GitHub, WoWInterface, or Curse to download the latest version."
L.Install = "Thanks for installing |cff" .. ns.color .. ns.name .. "|r!"
L.Update = "Thanks for updating to |cff" .. ns.color .. "v" .. ns.version .. "|r!"
L.Help = "Information and How to Use|r\nType |cff" .. ns.color .. "/wp|r to get your/your target's coordinates.\nYou can send your coordinates to different channels, like party, guild, instance, or whisper: |cff" .. ns.color .. "/wp guild|r, |cff" .. ns.color .. "/wp whisper NAME|r.\nCheck out the addon on GitHub, WoWInterface, or Curse for more info and support!\nYou can also get help directly from the author on Discord: " .. ns.discord
L.MessageManual = "Coordinates set to: "
L.MessagePlayer = "My coordinates are: "
L.MessageTarget = "%s%s is at: " -- targetName, targetHP
L.ParentPlace = "Usually you are unable to place a Map Pin here, but |cff" .. ns.color .. ns.name .. "|r has figured out how to place one for you!"
L.NoPlace = "Unable to place a Map Pin here!"

-- Check locale and assign appropriate
local CURRENT_LOCALE = GetLocale()

-- English
if CURRENT_LOCALE == "enUS" then return end

-- German
if CURRENT_LOCALE == "deDE" then return end

-- Spanish
if CURRENT_LOCALE == "esES" then return end

-- Latin-American Spanish
if CURRENT_LOCALE == "esMX" then return end

-- French
if CURRENT_LOCALE == "frFR" then return end

-- Italian
if CURRENT_LOCALE == "itIT" then return end

-- Brazilian Portuguese
if CURRENT_LOCALE == "ptBR" then return end

-- Russian
if CURRENT_LOCALE == "ruRU" then return end

-- Korean
if CURRENT_LOCALE == "koKR" then return end

-- Simplified Chinese
if CURRENT_LOCALE == "zhCN" then return end

-- Traditional Chinese
if CURRENT_LOCALE == "zhTW" then return end
