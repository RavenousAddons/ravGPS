local name, ravGPS = ...
ravGPS.name = "Ravenous GPS"
ravGPS.version = GetAddOnMetadata(name, "Version")
ravGPS.github = "https://github.com/waldenp0nd/ravGPS"
ravGPS.curseforge = "https://www.curseforge.com/wow/addons/ravgps"
ravGPS.wowinterface = "https://www.wowinterface.com/downloads/info25839-RavenousGPS.html"
ravGPS.discord = "https://discord.gg/dNfqnRf2fq"
ravGPS.color = "ff6b6b"
ravGPS.locales = {
    ["enUS"] = {
        ["help"] = {
            "Information and How to Use",
            "Type |cff" .. ravGPS.color .. "/%s|r to get your/your target's coordinates.", -- ravGPS.name
            "You can send your coordinates to different channels, like party, guild, instance, or whisper: |cff" .. ravGPS.color .. "/%s guild|r, |cff" .. ravGPS.color .. "/%s whisper NAME|r.", -- defaults.COMMAND, defaults.COMMAND
            "Check out |cff" .. ravGPS.color .. "%s|r on GitHub, WoWInterface, or Curse for more info and support!", -- ravGPS.name
            "You can also get help directly from the author on Discord: %s" -- ravGPS.discord
        },
        ["messages"] = {
            ["player"] = "My coordinates are: ",
            ["target"] = "%s is up at " -- targetName
        },
        ["load"] = {
            ["outofdate"] = "There is an update available for |cff" .. ravGPS.color .. "%s|r! Please go to GitHub, WoWInterface, or Curse to download.", -- ravGPS.name
            ["install"] = "Thanks for installing |cff" .. ravGPS.color .. "%s|r!", -- ravGPS.name
            ["update"] = "Thanks for updating to |cff" .. ravGPS.color .. "v%s|r!", -- ravGPS.version
            ["both"] = "Type |cff" .. ravGPS.color .. "/%s help|r to familiarize yourself with the addon." -- defaults.COMMAND
        },
        ["version"] = "%s is the current version.", -- ravGPS.version
        ["parentplace"] = "Usually you are unable to place a Map Pin here, but |cff" .. ravGPS.color .. "%s|r has figured out how to place one for you!", -- ravGPS.name
        ["cantplace"] = "Unable to place a Map Pin here!"
    }
}
