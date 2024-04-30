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

--- Stores vehicle mileages
GlobalState.vehicle_mileages = {}

--- Updates vehicle mileage by plate
-- @param plate: Plate of vehicle to update
-- @param mileage: New mileage value
RegisterServerEvent('boii_hud:sv:update_vehicle_mileage', function(plate, mileage)
    local current_mileage = GlobalState.vehicle_mileages[plate] or 0
    if math.abs(current_mileage - mileage) >= 1 then
        GlobalState.vehicle_mileages[plate] = mileage
        TriggerClientEvent('boii_hud:cl:update_vehicle_mileage', -1, plate, mileage)
    end
end)

--- Request vehicle mileages from global state
RegisterServerEvent('boii_hud:sv:request_vehicle_mileages', function()
    local _src = source
    TriggerClientEvent('boii_hud:cl:update_vehicle_mileage', _src, GlobalState.vehicle_mileages)
end)

-- Sync vehicle indicators
-- @param indicator: The indicator being activated
-- @param state: State of the indicator
RegisterServerEvent('boii_hud:sv:sync_indicators', function(indicator, state)
    local _src = source
    print("Syncing indicators for source: ", _src, "Indicator: ", indicator, "State: ", state)
    TriggerClientEvent('boii_hud:cl:update_indicators', -1, _src, indicator, state)
end)