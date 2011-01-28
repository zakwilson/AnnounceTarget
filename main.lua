local shorts = {
   ["Warthog Territorial Defender"] = "WTD",
   ["UIT Marauder"] = "UIT Maud",
   ["Corvus Vulturius - Anniversary Edition"] = "Corvult AE",
   ["Corvus Vulturius"] = "Corvult",
   ["Corvus Greyhound"] = "Greyhound",
   ["Corvus Marauder Mercenary"] = "CorMaud",
   ["BioCom Vulture XT"] = "Vult XT",
   ["Itani Valkyrie"] = "Valk",
   ["Valkyrie Vengeance"] = "Valk Vengeance",
   ["Valkyrie Rune"] = "Valk Rune",
   ["Valkyrie X-1"] = "X-1",
   ["Centurion Itani Border Guardian"] = "IBG Cent",
   ["IDF Valkyrie Vigilant"] = "IDF Valk",
   ["Serco Vulture Guardian"] = "SVG",
   ["Serco Prometheus"] = "Prom",
   ["Serco Prometheus MkII"] = "Prom2",
   ["Serco Prometheus MkIII"] = "Prom3",
   ["Serco SkyCommand Prometheus"] = "SCP",
   ["Orion Centurion Rev C"] = "Rev C",
   ["Orion Hornet Convoy Guardian"] = "Orion Hornet CG",
   ["TPG Maurader Type B"] = "Maud Type B",
   ["TPG Maurader Type X"] = "Maud Type X",
   ["TPG Atlas Type B"] = "Atlas Type B",
   ["TPG Atlas Type X"] = "Atlas Type X",
   ["TPG Raptor"] = "Raptor",
   ["TPG Raptor Mark II"] = "Raptor MkII",
   ["Tunguska Centaur Aggresso"] = "Centaur Aggresso",
   ["Tunguska Mineral Marauder"] = "Mineral Maud",
   ["Vulture MkII"] = "Vult2",
   ["Vulture MkIII"] = "Vult3",
   ["Vulture MkIV"] = "Vult4",
   ["Warthog MkII"] = "Hog2",
   ["Warthog MkIII"] = "Hog3",
   ["Warthog MkIV"] = "Hog4",
   ["Centaur MkII"] = "Taur2",
   ["Centaur MkIII"] = "Taur3",
   ["Ragnarok MkII"] = "Rag2",
   ["Ragnarok MkIII"] = "Rag3",
   ["Valent EC-101 Type B"] = "EC-101 Type B",
   ["Valent EC-101 Type B"] = "Maud Rev B",
   ["Axia EC-101 MkII"] = "EC-101 MkII",
   ["Axia Marauder MkII"] = "Maud2",
   ["Behemoth"] = "Moth",
   ["Behemoth XC"] = "XC",
   ["Behemoth Heavy Miner"] = "Miner Moth",
   ["Behemoth Heavy Miner MkII"] = "Miner Moth2",
   ["Aeolus Light Behemoth"] = "Light Moth"
}

function shortenName(arg)
   local name = tostring(arg)
   if shorts[name] then
      return shorts[name]
   else
      return name
   end
end

menu = {}
menu.info = iup.stationnameframe{iup.label{title="VPR Configuration Panel"}}
menu.close = iup.stationbutton{title="Cancel", expand="HORIZONTAL", action=function() HideDialog(menu.dlg) end}
menu.accept = iup.stationbutton{title="Accept", expand="HORIZONTAL"}
menu.uibinds = {}
menu.binds = {"atgroup", "atguild", "atgrouphelp", "atguildhelp", "atguilddistress", "atreport"}
menu.alias = {"announcetarget group", "announcetarget guild", "announcetarget grouphelp", "announcetarget guildhelp", "announcetarget guilddistress", "announcetarget report"}
menu.characters = {"1", "2", "3", "4", "5", "6"}

for n=1, 6 do
    menu.uibinds[n] = {
        key=iup.text{value=menu.characters[n], size=15, action=function(self, k, v) if #v > 1 then return iup.IGNORE else menu.characters[n] = v end end}
    }
end

menu.mainbox = iup.pdarootframe{
    iup.vbox{
        iup.label{title="Customize your binds:"},
        iup.hbox{iup.label{title="Group Announce Engaging bound to"}, menu.uibinds[1].key, gap=5},
        iup.hbox{iup.label{title="Guild Announce Engaging bound to"}, menu.uibinds[2].key, gap=5},
        iup.hbox{iup.label{title="Group Call Target bound to"}, menu.uibinds[3].key, gap=5},
        iup.hbox{iup.label{title="Guild Call Target bound to"}, menu.uibinds[4].key, gap=5},
        iup.hbox{iup.label{title="Distress Call bound to"}, menu.uibinds[5].key, gap=5},
        iup.hbox{iup.label{title="Report 4357 bound to"}, menu.uibinds[6].key, gap=5},
        gap=5,
        margin="2x2",
    }
}

menu.buttons = iup.hbox{
    iup.pdarootframe{menu.accept},
    iup.pdarootframe{menu.close},
    gap=5
}

menu.dlg = iup.dialog{
    iup.hbox{
        iup.fill{},
        iup.vbox{
            iup.fill{},
            iup.vbox{
                menu.info,
                menu.mainbox,
                menu.buttons,
                gap=5,
                expand="NO",
            },
            iup.fill{},
        },
        iup.fill{},
    };
    boarder="NO",
    topmost="YES",
    minibox="NO",
    maxbox="NO",
    resize="NO",
    menubox="NO",
    bgcolor="0 0 0 96 *",
    fullscreen="YES",
    defaultesc=menu.close,
}

function setATBinds()
    for n=1, 6 do
	gkinterface.GKProcessCommand("alias " .. menu.binds[n]  .. " \"" .. menu.alias[n] .. "\"")
        gkinterface.GKProcessCommand("bind " .. menu.characters[n]  .. " " .. menu.binds[n])
    end
end

function menu.accept:action()
    setATBinds()
    HideDialog(menu.dlg)
    print("\127ffffffVPR Binds saved! Type \"/announcetarget config\" to modify your binds.")
end

menu.dlg:map()

function announcetarget(junk, args)
    local msg = tostring(args[1])

    if msg == "config" then
        ShowDialog(menu.dlg, iup.CENTER, iup.CENTER)
    end
    
    if GetTargetInfo() == nil then
        return -- no need to continue
    end

    local tname, thealth, tdistance, tfactionid, tguild, tshiptmp = GetTargetInfo()
    local tship = shortenName(tshiptmp)
    local mship = shortenName(GetActiveShipName())
    local d1, d2, d3, d4, d5, d6, dmg, max = GetActiveShipHealth()
    local mhealth = math.floor(100*(max-dmg)/max);

    local toMSG = ""
    local me = ""
    local tshipandhealth = ""
    if msg == "group" or msg == "grouphelp" then
        toMSG = "GROUP"
    elseif msg == "guild" or msg == "guildhelp" then
        toMSG = "GUILD"
        me = "/me "
    end

    if thealth == nil then
        if toMSG ~= "" then
            SendChat("Targeting " .. tname .. ".", toMSG)
        end
        return -- no need to continue
    end

    if tguild ~= "" then
        tname = "[".. tguild .."] ".. tname    
    end
    if tship ~= "Robot" then 
        tshipandhealth = "("..tship..", "..math.floor(thealth*100).."%)"
    else tshipandhealth = "("..math.floor(thealth*100).."%)"
    end

    if string.len(msg) == 5 then -- not help
	    SendChat(me.."("..mhealth.."%) engaging \""..tname.. "\" "..tshipandhealth.." at "..math.floor(tdistance).."m", toMSG)
    elseif string.len(msg) == 9 then -- help
	   	SendChat("All pilots engage: \""..tname.. "\" "..tshipandhealth, toMSG)
    elseif msg == "guilddistress" then 
	   	SendChat(me.."("..mship..", "..mhealth.."%) being attacked by \""..tname.. "\" "..tshipandhealth.. ". REQUESTING ASSISTANCE.", "GROUP")
	   	SendChat(me.."("..mship..", "..mhealth.."%) being attacked by \""..tname.. "\" "..tshipandhealth.. ". REQUESTING ASSISTANCE.", "GUILD")
    elseif msg == "report" then
	if("*" == string.sub(tname,0,1)) then
		print("\127ffffffNo reporting bots to 4357!")
	else	
		SendChat(tname .. " spotted piloting " .. Article(tship) .. " in ".. ShortLocationStr(GetCurrentSectorid()), "CHANNEL", 4357)
	end
    end
end

RegisterUserCommand("announcetarget", announcetarget, "junk")
