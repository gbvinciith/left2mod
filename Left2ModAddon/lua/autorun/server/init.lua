if (SERVER) then
	--[[
	Explanation here, for the weapons.

	Most of the weapon_spawn information is here:
	https://developer.valvesoftware.com/wiki/Weapon_spawn
	https://developer.valvesoftware.com/wiki/Weapon_melee_spawn

	The difference between the official L4D2 entity and this, is that you can add custom weapons.
	(I do recommend keeping most spawns on random categories, such as "any tier 1 primary" or "any shotgun", to keep the variety up.
	Melee weapons are the same, however they use "any" for random.

	Do try to keep the weapon ID unique, possibly with an identifier (ex. "weapon_shotgun" becomes "authorname_weapon_shotgun")

	Melee weapons are simple,
	{"spawn name", "weapon class", "model path"}

	Primary weapons are a little more complex, but still simple.
	They work the same way as melee weapons, with the added table layers for organization and variety.

	Try to keep your weapons outside of Tier1, Tier2, SMGs, and Shotguns.
	Putting them into the other tables is enough.
	]]
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

	--To make life easier, compress the tables
	--Because this exists, I recommend keeping weapons outside of the global-ish categories.
	--(Tier1, Tier2, SMGS, and Shotguns)
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

	--[[
	Playermodels are one of the simplest additions you can make, and are used for the survivors.

	model = player icon
	["path/to/model.mdl"] = "path/to/material.png"
	]]
	local myPlayerModels = {
        ["models/vocaloid/hatsune_miku_v3/hatsune_miku_v3_player.mdl"] = "playericons/miku.png"
	}

	--[[
	Ahead is generally where your addon hooks onto the main L2M code.
	]]
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

	--Try hooking onto the addon, if the gamemode loads *before* the addon.
    hook.Add("Initialize", "AddonInitialize", function()
        print("Left 2 Mod Addon is now initialized!")
        tryHook()
    end)

	--In the case where the gamemode loads *after* the addon.
    hook.Add("Left2ModInitialize", "AddCustomWeapons", function()
		--Wait a tick or two so the gamemode can initialize first
		coroutine.yield()
		timer.Simple(0, function()
			tryHook()
		end)
    end)
end
