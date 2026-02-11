if (SERVER) then
    local myPrimaryWeapons = {
        Tier1 = {},
        Tier2 = {},
        SMGs = {},
        Tier2Rifles = {},
        Tier2SniperRifles = {},
        Shotguns = {},
        Tier1Shotguns = {
            {"weapon_addon_shotgun", "weapon_shotgun", "models/weapons/w_shotgun.mdl"}
        },
        Tier2Shotguns = {}
    }

    for i, v in pairs(myPrimaryWeapons.SMGs) do
        myPrimaryWeapons.Tier1[i] = v
    end
    for i, v in pairs(myPrimaryWeapons.Tier1Shotguns) do
        myPrimaryWeapons.Tier1[i] = v
        myPrimaryWeapons.Shotguns[i] = v
    end
    for i, v in pairs(myPrimaryWeapons.Tier2Shotguns) do
        myPrimaryWeapons.Tier2[i] = v
        myPrimaryWeapons.Shotguns[i] = v
    end
    for i, v in pairs(myPrimaryWeapons.Tier2Rifles) do
        myPrimaryWeapons.Tier2[i] = v
    end
    for i, v in pairs(myPrimaryWeapons.Tier2SniperRifles) do
        myPrimaryWeapons.Tier2[i] = v
    end

    local myMeleeWeapons = {
        {"weapon_addon_melee", "weapon_crowbar", "models/weapons/w_crowbar.mdl"}
    }

	local myPlayerModels = {
        ["models/vocaloid/hatsune_miku_v3/hatsune_miku_v3_player.mdl"] = "playericons/miku.png"
	}

	local playerModelSent = false
    local primarySent, meleeSent = false, false
    function tryHook()
        --[[
            You are also able to override any of these tables, but it's not recommended
            Especially useful if you're making a custom campaign.
        ]]
        if _G.PrimaryWeapons and not primarySent then
            primarySent = true
            --_G.PrimaryWeapons = myPrimaryWeapons
            --[[
                You can also change specific tables of the primary weapons, ex.
                _G.PrimaryWeapons.Tier1 = myPrimaryWeapons.Tier1
            ]]
            for i, v in pairs(myPrimaryWeapons) do
                for _, w in ipairs(v) do
                    table.insert(_G.PrimaryWeapons[i], w)
                    print(w[1])
                end
            end
        end
        if _G.MeleeWeapons and not meleeSent then
            meleeSent = true
            --_G.MeleeWeapons = myMeleeWeapons
            for _, v in ipairs(myMeleeWeapons) do
                table.insert(_G.MeleeWeapons, v)
                print(v[1])
            end
        end
		if _G.PlayerModels and not playerModelSent then
            playerModelSent = true
            --_G.PlayerModels = myPlayerModels
            for k, v in pairs(myPlayerModels) do
                _G.PlayerModels[k] = v
                print(k)
            end
		end
    end

    hook.Add("Initialize", "AddonInitialize", function()
        print("Left 2 Mod Addon is now initialized!")
        tryHook()
    end)

    hook.Add("Left2ModInitialize", "AddCustomWeapons", function()
        tryHook()
    end)
end
