--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|             DEVELOPER UTILS
]]

--- Ped functions.
-- @script client/peds.lua

--- @section Tables

--- @table created_peds: Used to store created peds and their associated data.
local created_peds = {}

--- @section Local functions

--- Gives a weapon to a ped with optional configurations such as ammo count, equip immediately, hidden status, accuracy, and invincibility.
-- @function give_weapon
-- @param ped number: The ped to give the weapon to.
-- @param weapon_name string: The name of the weapon to give.
-- @param ammo number: The amount of ammo to give (optional).
-- @param equip_now boolean: Equip the weapon immediately (optional).
-- @param is_hidden boolean: Weapon is hidden or not (optional).
-- @param accuracy number: Accuracy of the ped with the weapon (optional).
-- @param invincible boolean: Ped is invincible or not (optional).
-- @usage utils.peds.give_weapon(ped, 'WEAPON_PISTOL', 100, true, false, 100.0, true)
local function give_weapon(ped, weapon_name, ammo, equip_now, is_hidden, accuracy, invincible)
    if ped and weapon_name then
        local weapon_hash = GetHashKey(weapon_name)
        GiveWeaponToPed(ped, weapon_hash, ammo or 0, is_hidden or false, equip_now or false)
        if accuracy then
            SetPedAccuracy(ped, math.floor(accuracy))
        end
        if invincible then
            SetEntityInvincible(ped, true)
        end
    end
end

--- Creates a ped based on provided data which includes base data, animation data, and weapon data.
-- @function create_ped
-- @param data table: A table containing ped creation data.
-- @usage local your_ped = utils.peds.create_ped(ped_data)
-- @example
--[[
    local ped_data = {
        base_data = {
            model = "a_m_m_business_01", -- Model of the ped
            coords = vector3(-254.09, -971.48, 31.22), -- Coordinates where the ped will be spawned
            scenario = "WORLD_HUMAN_AA_COFFEE", -- Scenario the ped will be using (optional)
            networked = false -- Whether the ped is networked or not
        },
        animation_data = { -- Optional
            dict = "amb@world_human_aa_coffee@base", -- Animation dictionary
            anim = "base", -- Animation name
            blend_in = 8.0, -- Blend in speed
            blend_out = -8.0, -- Blend out speed
            duration = -1, -- Duration of the animation
            flag = 49, -- Animation flag
            playback_rate = 1.0 -- Playback rate of the animation
        },
        weapon_data = { -- Optional
            weapon_name = "WEAPON_PISTOL", -- Weapon to give to the ped
            ammo = 100, -- Amount of ammo
            equip_now = true, -- Equip the weapon immediately
            is_hidden = false, -- Weapon is hidden or not
            accuracy = 100.0, -- Accuracy of the ped with the weapon
            invincible = true -- Ped is invincible or not
        }
    }
    local your_ped = utils.peds.create_ped(ped_data)  
]]
local function create_ped(data)
    local base_data = data.base_data or {}
    utils.requests.model(GetHashKey(base_data.model))
    local ped = CreatePed(4, GetHashKey(base_data.model), base_data.coords.x, base_data.coords.y, base_data.coords.z - 1, base_data.coords.w, base_data.networked or false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    if data.animation_data then
        utils.requests.anim(animation_data.dict)
        TaskPlayAnim(ped, data.animation_data.dict, data.animation_data.anim, data.animation_data.blend_in or 8.0, data.animation_data.blend_out or -8.0, data.animation_data.duration or -1, data.animation_data.flag or 0, data.animation_data.playback_rate or 1.0, false, false, false)
    elseif base_data.scenario then
        TaskStartScenarioInPlace(ped, base_data.scenario, 0, true)
    end
    local weapon_data = data.weapon_data or {}
    if weapon_data.weapon_name then
        give_weapon(ped, weapon_data.weapon_name, weapon_data.ammo, weapon_data.equip_now, weapon_data.is_hidden, weapon_data.accuracy, weapon_data.invincible)
    end
    created_peds[#created_peds + 1] = { id = base_data.id, ped = ped, category = base_data.category }
    return ped
end

--- Creates multiple peds based on a provided configuration.
-- @function create_peds
-- @param ped_config table: A table containing configurations for multiple peds.
-- @usage utils.peds.create_peds(peds)
local function create_peds(ped_config)
    for _, ped_data in ipairs(ped_config) do
        create_ped(ped_data)
    end
end

--- Removes a single ped and also removes it from the created_peds table.
-- @function remove_ped
-- @param ped number: The ped to remove.
-- @usage utils.peds.remove_ped(ped)
local function remove_ped(ped)
    DeleteEntity(ped)
    for i = #created_peds, 1, -1 do
        if created_peds[i].ped == ped then
            table.remove(created_peds, i)
            break
        end
    end
end

--- Removes all created peds.
-- @function remove_all_peds
-- @usage utils.peds.remove_all_peds()
local function remove_all_peds()
    for _, ped_data in ipairs(created_peds) do
        remove_ped(ped_data.ped)
    end
    created_peds = {}
end

--- Removes peds based on their categories.
-- @function remove_peds_by_categories
-- @param categories table: A list of categories to match for ped removal.
-- @usage utils.peds.remove_peds_by_categories({'workers', 'guards'})
local function remove_peds_by_categories(categories)
    print("Starting ped removal for categories:", table.concat(categories, ", "))
    local initialCount = #created_peds
    local removedCount = 0

    for i = #created_peds, 1, -1 do
        local ped_data = created_peds[i]
        for _, category in ipairs(categories) do
            if ped_data.category == category then
                print("Removing ped:", ped_data.ped, "Category:", category)
                remove_ped(ped_data.ped) -- remove_ped will handle deletion and removal from the list
                removedCount = removedCount + 1
                break -- Exit the inner loop since the ped matches a category and will be removed
            end
        end
    end

    print(string.format("Attempted to remove %d peds. Initial peds: %d. Remaining peds: %d", removedCount, initialCount, #created_peds))
end


--- @section Assign local functions

utils.peds = utils.peds or {}

utils.peds.create_ped = create_ped
utils.peds.create_peds = create_peds
utils.peds.remove_ped = remove_ped
utils.peds.remove_all_peds = remove_all_peds
utils.peds.remove_peds_by_categories = remove_peds_by_categories