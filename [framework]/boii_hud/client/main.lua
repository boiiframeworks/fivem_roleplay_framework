--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|                   HUD
]]

--- Client side HUD.
-- @module client/main

--- Import utility library
utils = exports.boii_utils:get_utils()

local radar_shown = false
local hud_components = { 1, 2, 3, 4, 7, 9, 13, 19, 20, 21, 22 }
local disable_controls = { 37 }
local disable_ammo = true
local vehicle_mileages = {}
local is_driving = false
local player_buffs = {}
local player_debuffs = {}
local indicator_states = {
    left = false,
    right = false,
    hazards = false
}

--- Gets the distance to the current waypoint if set
-- @param player: The players ped
local function get_waypoint_distance(player)
    local waypoint = GetFirstBlipInfoId(8)
    if DoesBlipExist(waypoint) then
        local coords = GetBlipInfoIdCoord(waypoint)
        local player_coords = GetEntityCoords(player)
        local distance = #(player_coords - coords) / 1609.34
        return string.format('%.1f miles', distance)
    end
end

--- Update radar UI when the player is in a vehicle.
-- @param player: The player ped
-- @param player_vehicle: The vehicle the player is currently in
-- @param radar_shown: The current state of the radar display
-- @return bool: The updated state of radar_shown
local function update_radar_ui(player, player_vehicle, radar_shown)
    if not radar_shown then
        DisplayRadar(true)
        radar_shown = true
    end
    local direction = utils.player.get_cardinal_direction(player_vehicle)
    local road_name = utils.player.get_street_name(player)
    local distance = get_waypoint_distance(player) or ''
    if direction then
        SendNUIMessage({
            action = 'update_map',
            direction = direction,
            road_name = road_name,
            distance = distance
        })
    end
    return radar_shown
end

--- Hide the radar UI when the player is not in a vehicle.
-- @param radar_shown: The current state of the radar display
-- @return bool: The updated state of radar_shown
local function hide_radar_ui(radar_shown)
    if radar_shown then
        DisplayRadar(false)
        radar_shown = false
    end
    SendNUIMessage({ action = 'hide_map' })
    return radar_shown
end

--- Disable HUD components and controls.
local function disable_components()
	while true do
		for i = 1, #hud_components do
			HideHudComponentThisFrame(hud_components[i])
		end
		for i = 1, #disable_controls do
			DisableControlAction(2, disable_controls[i], true)
		end
		DisplayAmmoThisFrame(disable_ammo)
		Wait(0)
	end
end

--- Initialize the minimap.
local function init_map()
    DisplayRadar(false)
    radar_shown = false
    Wait(150)
    local default_aspect_ratio = 1920 / 1080
    local res_x, res_y = GetActiveScreenResolution()
    local aspect_ratio = res_x / res_y
    local map_offset = 0
    if aspect_ratio > default_aspect_ratio then
        map_offset = ((default_aspect_ratio - aspect_ratio) / 3.6) - 0.008
    end
    local minimap_width = 0.200
    local minimap_height = minimap_width * res_x / res_y
    utils.requests.texture("map", false)
    SetMinimapClipType(0)
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "map", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "map", "radarmasksm")
    SetMinimapComponentPosition("minimap", "R", "T", -0.008 + map_offset, 0.025, minimap_width / 1.715, minimap_height / 1.715)
    SetMinimapComponentPosition("minimap_mask", "R", "T", -0.015 + map_offset, 0.0650, minimap_width, minimap_height)
    SetMinimapComponentPosition('minimap_blur', 'R', 'T', 0.065 + map_offset, -0.035, minimap_width, minimap_height)
    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetBigmapActive(true, false)
    SetMinimapClipType(0)
    SetBigmapActive(false, false)
    Wait(50)
    local minimap = RequestScaleformMovie('minimap')
    BeginScaleformMovieMethod(minimap, 'HIDE_SATNAV')
	EndScaleformMovieMethod()
    CreateThread(disable_components)
end
init_map()

--- Update vehicle mileage
-- @param vehicle_player: Plate for the vehicle.
-- @param speed: Speed vehicle is traveling at.
-- @param dt: Distance travelled. 
local function update_mileage(vehicle_plate, speed, dt)
    local vehicle_data = vehicle_mileages[vehicle_plate]
    if not vehicle_data then
        vehicle_mileages[vehicle_plate] = {
            mileage = 0,
            accumulated_distance = 0
        }
        vehicle_data = vehicle_mileages[vehicle_plate]
    end
    local distance_traveled = speed * (dt / 3600)
    vehicle_data.accumulated_distance = vehicle_data.accumulated_distance + distance_traveled
    if vehicle_data.accumulated_distance >= 1.0 then
        local miles = math.floor(vehicle_data.accumulated_distance)
        vehicle_data.mileage = vehicle_data.mileage + miles
        vehicle_data.accumulated_distance = vehicle_data.accumulated_distance - miles
    end
end

--- Updates speedo
-- @param speed_unit string: String name for speed type mph or kph
-- @param player_vehicle: The vehicle the player is driving
local function update_speedo(speed_unit, player_vehicle)
    if not is_driving then return end
    local speed_mps = GetEntitySpeed(player_vehicle)
    local vehicle_plate = GetVehicleNumberPlateText(player_vehicle)
    if not vehicle_mileages[vehicle_plate] then
        vehicle_mileages[vehicle_plate] = { mileage = 0, accumulated_distance = 0 }
    end
    local speed = speed_mps * (speed_unit == 'mph' and 2.23694 or 3.6)
    update_mileage(vehicle_plate, speed, 1)
    local rpm = GetVehicleCurrentRpm(player_vehicle) * 100
    local gear = GetVehicleCurrentGear(player_vehicle)
    local engine_health = GetVehicleEngineHealth(player_vehicle) / 10
    local body_health = GetVehicleBodyHealth(player_vehicle) / 10
    local fuel_level = GetVehicleFuelLevel(player_vehicle)
    local formatted_mileage = string.format("%06d", vehicle_mileages[vehicle_plate].mileage)
    SendNUIMessage({
        action = 'update_speedo',
        speed = math.floor(speed),
        rpm = rpm,
        gear = gear,
        engine_health = engine_health,
        body_health = body_health,
        fuel = fuel_level,
        mileage = formatted_mileage
    })
end

--- Update hud periodically
local function update_hud()
    while true do
        local player = PlayerPedId()
        local player_vehicle = GetVehiclePedIsIn(player, false)
        local driver_seat_ped = GetPedInVehicleSeat(player_vehicle, -1)
        if player_vehicle ~= 0 and driver_seat_ped == player then
            radar_shown = update_radar_ui(player, player_vehicle, radar_shown)
            is_driving = true
            if is_driving then
                update_speedo('mph', player_vehicle)
            end
        else
            radar_shown = hide_radar_ui(radar_shown)
            is_driving = false
        end

        -- If you dont want to use boii_statuses this part requires editing
        local player_data = exports.boii_statuses:get_data()
        if player_data and player_data.statuses then
            player_data.statuses.health = player_data.statuses.health / 2
            SendNUIMessage({
                action = 'update_stats',
                statuses = player_data.statuses
            })
        end
        Wait(250)
    end
end

--- Updates a players injury
-- @param body_part string: String name of the body part to apply injury.
-- @param is_injured: Boolean value to toggle injury status
local function update_injury(body_part, is_injured)
    SendNUIMessage({
        action = 'update_stats',
        area = body_part,
        injured = is_injured
    })
end

--- Initialize the HUD when the script starts.
local function init_hud()
    init_map()
    SendNUIMessage({ action = 'init_hud' })
    TriggerServerEvent('boii_hud:sv:request_vehicle_mileages')
    CreateThread(update_hud)
end
exports('init', init_hud)
--init_hud()

--- @section Events

--- Updates vehicle mileages
-- @param plate: Plate of the vehicle
-- @param mileage: Current vehicle mileage
RegisterNetEvent('boii_hud:cl:update_vehicle_mileage', function(plate, mileage)
    if vehicle_mileages[plate] then
        vehicle_mileages[plate].mileage = mileage
    end
end)

--- Updates a players injury status
-- @param body_part: The name of the body part to update
-- @param is_injured: Boolean value to toggle injury status
-- @see update_injury
RegisterNetEvent('boii_hud:cl:update_injury_status', function(body_part, is_injured)
    update_injury(body_part, is_injured)
end)

--- Updates vehicle indicators
-- @param _src: Source player receive from server
-- @param indicator: The indicator to update
-- @param state: The state for the indicator
RegisterNetEvent('boii_hud:cl:update_indicators', function(_src, indicator, state)
    local playerPed = GetPlayerPed(GetPlayerFromServerId(_src))
    if not DoesEntityExist(playerPed) then
        print("Player ped does not exist for source: ", _src)
        return
    end
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    if not DoesEntityExist(playerVehicle) then
        print("Player vehicle does not exist for source: ", _src)
        return
    end
    local indicatorLights = {
        left_indicator = 1,
        right_indicator = 0,
        hazards = {0, 1}
    }
    local lights = indicatorLights[indicator]
    if type(lights) == "table" then
        for _, lightIndex in ipairs(lights) do
            SetVehicleIndicatorLights(playerVehicle, lightIndex, state)
        end
    else
        SetVehicleIndicatorLights(playerVehicle, lights, state)
    end
end)

--- Adds a buff to player table and sends to hud
-- @param buff: The buff to add
RegisterNetEvent('boii_hud:cl:add_buff', function(buff)
    player_buffs[buff.id] = buff
    SendNUIMessage({
        action = 'update_buffs',
        buffs = player_buffs
    })
end)

--- Removes a buff from player table and removes from hud
-- @param buff: The buff to remove
RegisterNetEvent('boii_hud:cl:remove_buff', function(id)
    player_buffs[id] = nil
    SendNUIMessage({
        action = 'update_buffs',
        buffs = player_buffs
    })
end)

--- Updates a buff
-- @param buff: The buff to update
RegisterNetEvent('boii_hud:cl:update_buff', function(buff)
    if player_buffs[buff.id] then
        player_buffs[buff.id] = buff
        SendNUIMessage({
            action = 'update_buffs',
            buffs = player_buffs
        })
    end
end)

--- Adds a debuff to player table and sends to hud
-- @param debuff: The debuff to add
RegisterNetEvent('boii_hud:cl:add_debuff', function(debuff)
    player_debuffs[debuff.id] = debuff
    SendNUIMessage({
        action = 'update_debuffs',
        debuffs = player_debuffs
    })
end)

--- Removes a debuff from player table and removes from hud
-- @param debuff: The debuff to remove
RegisterNetEvent('boii_hud:cl:remove_debuff', function(id)
    player_debuffs[id] = nil
    SendNUIMessage({
        action = 'update_debuffs',
        debuffs = player_debuffs
    })
end)

--- Updates a debuff
-- @param debuff: The debuff to update
RegisterNetEvent('boii_hud:cl:update_debuff', function(debuff)
    if player_buffs[debuff.id] then
        player_buffs[debuff.id] = debuff
        SendNUIMessage({
            action = 'update_debuffs',
            buffs = player_debuffs
        })
    end
end)

--- @section Keymapping

--- May change these to a thread and key check when in car was mostly just to test things actually work, will see how it goes.

RegisterCommand('left_indicator', function()
    local player = PlayerPedId()
    local player_vehicle = GetVehiclePedIsIn(player, false)
    if player_vehicle ~= 0 and GetPedInVehicleSeat(player_vehicle, -1) == player then
        indicator_states.left = not indicator_states.left
        TriggerServerEvent('boii_hud:sv:sync_indicators', 'left_indicator', indicator_states.left)
        SendNUIMessage({ 
            action = 'update_indicator',
            indicator = 'left_indicator',
            colour = indicator_states.left and 'orange' or 'white',
            animation = indicator_states.left and 'flash 0.8s infinite' or 'none'
        })
    end
end, false)
RegisterKeyMapping('left_indicator', 'Toggle Left Indicator', 'keyboard', 'B')

RegisterCommand('right_indicator', function()
    local player = PlayerPedId()
    local player_vehicle = GetVehiclePedIsIn(player, false)
    if player_vehicle ~= 0 and GetPedInVehicleSeat(player_vehicle, -1) == player then
        indicator_states.right = not indicator_states.right
        TriggerServerEvent('boii_hud:sv:sync_indicators', 'right_indicator', indicator_states.right)
        SendNUIMessage({ 
            action = 'update_indicator',
            indicator = 'right_indicator',
            colour = indicator_states.right and 'orange' or 'white',
            animation = indicator_states.right and 'flash 0.8s infinite' or 'none'
        })
    end
end, false)
RegisterKeyMapping('right_indicator', 'Toggle Right Indicator', 'keyboard', 'N')

RegisterCommand('hazards', function()
    local player = PlayerPedId()
    local player_vehicle = GetVehiclePedIsIn(player, false)
    if player_vehicle ~= 0 and GetPedInVehicleSeat(player_vehicle, -1) == player then
        indicator_states.hazards = not indicator_states.hazards
        TriggerServerEvent('boii_hud:sv:sync_indicators', 'hazards', indicator_states.hazards)
        SendNUIMessage({ 
            action = 'update_indicator',
            indicator = 'left_indicator',
            colour = indicator_states.hazards and 'orange' or 'white',
            animation = indicator_states.hazards and 'flash 0.8s infinite' or 'none'
        })
        SendNUIMessage({ 
            action = 'update_indicator',
            indicator = 'right_indicator',
            colour = indicator_states.hazards and 'orange' or 'white',
            animation = indicator_states.hazards and 'flash 0.8s infinite' or 'none'
        })
    end
end, false)
RegisterKeyMapping('hazards', 'Toggle Hazard Lights', 'keyboard', 'M')

RegisterCommand('toggle_engine', function()
    local player = PlayerPedId()
    local player_vehicle = GetVehiclePedIsIn(player, false)
    if player_vehicle ~= 0 and GetPedInVehicleSeat(player_vehicle, -1) == player then
        local engine_status = GetIsVehicleEngineRunning(player_vehicle)
        SetVehicleEngineOn(player_vehicle, not engine_status, false, true)
        SendNUIMessage({ 
        action = 'update_indicator',
        indicator = 'engine_state',
        colour = engine_status and '#1f1e1e' or 'orange'
    })
    end
end, false)
RegisterKeyMapping('toggle_engine', 'Toggle Engine On/Off', 'keyboard', 'Y')
