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

--- Networking functions.
-- @script client/scripts/networking.lua

--- @section Tables

--- Stores synced data.
--- @table SYNCED_DATA
local SYNCED_DATA = {}

--- Stores callback data.
--- @table DATA_CALLBACKS
local DATA_CALLBACKS = {}

--- @section Constants

local MAX_TABLE_DEPTH = 3
local LAST_SYNC_TIME = 0
local SYNC_INTERVAL = 1000

--- @section Internal helper functions

--- Validates nested tables recursively up to a maximum depth.
--- @function validate_table
--- @param t The table to validate.
--- @param depth The current depth of recursion.
--- @return true if the table is valid, false otherwise.
local function validate_table(t, depth)
    if depth > MAX_TABLE_DEPTH then
        return false
    end
    for k, v in pairs(t) do
        local v_type = type(v)
        if v_type == 'table' then
            if not validate_table(v, depth + 1) then
                return false
            end
        elseif v_type ~= 'number' and v_type ~= 'string' then
            return false
        end
    end
    return true
end

--- Validates the provided data's type and nested table depth.
--- @function validate_data
--- @param data The data to validate.
--- @return true if the data is valid, false otherwise.
local function validate_data(data)
    local data_type = type(data)
    if data_type == 'number' or data_type == 'string' then
        return true
    elseif data_type == 'table' then
        return validate_table(data, 1)
    else
        return false
    end
end

--- @section Local functions

--- Creates a new synced data table if it doesn't exist.
--- @function create_synced_table
--- @param table_name The name of the table to create.
--- @usage utils.networking.create_synced_table('player_data')
local function create_synced_table(table_name)
    if not SYNCED_DATA[table_name] then
        SYNCED_DATA[table_name] = {}
    else
        utils.debug.warn('Table ' .. table_name .. ' already exists.')
    end
end

exports('networking_create_synced_table', create_synced_table)
utils.networking.create_synced_table = create_synced_table

--- Sets a key-value pair in the synced table and triggers a server event.
--- @function set_synced_data
--- @param table_name The name of the table.
--- @param key The key to set the data for.
--- @param value The value to set.
--- @usage utils.networking.set_synced_data('player_data', 'health', 100)
local function set_synced_data(table_name, key, value)
    if GetGameTimer() - LAST_SYNC_TIME < SYNC_INTERVAL then
        utils.debug.warn('Data sync rate limit reached. Try again later.')
        return
    end
    if SYNCED_DATA[table_name] then
        if validate_data(value) then
            local old_value = SYNCED_DATA[table_name][key]
            SYNCED_DATA[table_name][key] = value

            if DATA_CALLBACKS[table_name] and DATA_CALLBACKS[table_name][key] then
                DATA_CALLBACKS[table_name][key](old_value, value)
            end
            local data_to_send = utils.tables.deep_copy(SYNCED_DATA[table_name][key])
            TriggerServerEvent('boii_utils2:sv:sync_data', table_name, key, data_to_send)
            LAST_SYNC_TIME = GetGameTimer()
        else
            utils.debug.err('Invalid data provided for table ' .. table_name .. '.')
        end
    else
        utils.debug.err('Table ' .. table_name .. ' doesnt exist.')
    end
end

exports('networking_set_synced_data', set_synced_data)
utils.networking.set_synced_data = set_synced_data

--- Sets multiple key-value pairs in the synced table.
--- @function set_bulk_synced_data
--- @param table_name The name of the table.
--- @param data The data to set (as a table of key-value pairs).
--- @usage utils.networking.set_bulk_synced_data('player_data', {health=100, stamina=80})
local function set_bulk_synced_data(table_name, data)
    for k, v in pairs(data) do
        set_synced_data(table_name, k, v)
    end
end

exports('networking_set_bulk_synced_data', set_bulk_synced_data)
utils.networking.set_bulk_synced_data = set_bulk_synced_data

--- Retrieves a value from the synced table.
--- @function get_synced_data
--- @param table_name The name of the table.
--- @param key The key to retrieve the data for.
--- @return The value associated with the key, or nil if not found.
--- @usage local health = utils.networking.get_synced_data('player_data', 'health', 100)
local function get_synced_data(table_name, key)
    return SYNCED_DATA[table_name] and SYNCED_DATA[table_name][key]
end

exports('networking_get_synced_data', get_synced_data)
utils.networking.get_synced_data = get_synced_data

--- Retrieves multiple values from the synced table based on provided keys.
--- @function get_bulk_synced_data
--- @param table_name The name of the table.
--- @param keys A table of keys to retrieve data for.
--- @return A table of key-value pairs representing the requested data.
--- @usage local data = utils.networking.get_bulk_synced_data('player_data', {'health', 'stamina'})
local function get_bulk_synced_data(table_name, keys)
    local results = {}
    for _, key in ipairs(keys) do
        results[key] = get_synced_data(table_name, key)
    end
    return results
end

exports('networking_get_bulk_synced_data', get_bulk_synced_data)
utils.networking.get_bulk_synced_data = get_bulk_synced_data

--- Registers a callback function for when specific data changes.
--- @function register_data_callback
--- @param table_name The name of the table containing the data.
--- @param key The key within the table to monitor.
--- @param callback The function to execute when the data changes.
--- @usage utils.networking.register_data_callback('player_data', 'health', function(old_val, new_val) ... end)
local function register_data_callback(table_name, key, callback)
    DATA_CALLBACKS[table_name] = DATA_CALLBACKS[table_name] or {}
    DATA_CALLBACKS[table_name][key] = callback
end

exports('networking_register_data_callback', register_data_callback)
utils.networking.register_data_callback = register_data_callback

--- @section Events

--- Handles server events to update local synced data.
--- @event boii_utils2:cl:update_synced_data
--- @param table_name The name of the table.
--- @param key The key that was updated.
--- @param value The new value for the key.
RegisterNetEvent('boii_utils2:cl:update_synced_data')
AddEventHandler('boii_utils2:cl:update_synced_data', function(table_name, key, value)
    if SYNCED_DATA[table_name] then
        SYNCED_DATA[table_name][key] = value
    else
        utils.debug.err('Received data for non-existent table ' .. table_name .. '.')
    end
end)

--- @section Testing

if TESTING then

    RegisterCommand('utils:client_networking_test', function()
        exports.boii_utils2:networking_create_synced_table('player_data')
        exports.boii_utils2:networking_set_synced_data('player_data', 'health', 100)
        exports.boii_utils2:networking_set_bulk_synced_data('player_data', {stamina = 80, hunger = 50})
        local health = exports.boii_utils2:networking_get_synced_data('player_data', 'health')
        print('Health:', health)
        local data = exports.boii_utils2:networking_get_bulk_synced_data('player_data', {'health', 'stamina', 'hunger'})
        print('Bulk Data:', data.health, data.stamina, data.hunger)
        exports.boii_utils2:networking_register_data_callback('player_data', 'health', function(old_val, new_val)
            print('Health changed from', old_val, 'to', new_val)
        end)
        exports.boii_utils2:networking_set_synced_data('player_data', 'health', 90)
    end)

end
