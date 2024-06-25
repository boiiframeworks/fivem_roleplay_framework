# V 1.8.0

- Restructure to entire code base.
-> Moved files from individual folders to shared 'scripts' folders in respective areas.
-> Moved all 'utils' direct export functions to below each function to keep them close to the functions.
-> Added individual exports for each function where neccessary to remove the need for importing the entire library.

- Shared: Debug
-> Added new functions:
--> log_stack_trace: Logs the current stack trace.
--> dump: Dumps the content of a variable to the log this converts the variable into a JSON string.
--> measure_execution_time: Measures and logs the execution time of a function.
--> log_resource_usage: Logs the current resource usage of the server.
--> try_catch: Moved from general to debug, emulates try-catch behavior in Lua.
--> once: Moved from general to debug, ensures a function is called only once.
--> throttle: Moved from general to debug, throttles function execution.
--> is_number: Moved from general to debug, validates if value is a number.
--> is_table: Moved from general to debug, validates if value is a table.
--> is_string: Moved from general to debug, validates if value is a string.
--> is_function: Moved from general to debug, validates if value is a function.
--> coalesce: Moved from general to debug, returns the first non-nil value from the given arguments.
--> is_empty: Checks if a given value is empty (table or string).
--> debounce: Creates a debounced version of a function.

- Shared: General
-> Moved functions from general to debug: try_catch, once, throttle, is_number, is_table, is_string, is_function, coalesce.
-> Added new functions:
--> hex_to_rgb: Converts a hex value into rgb.
--> generate_uuid: Creates a new UUID, useful for unique identifiers.

- Shared: Keys
-> Added new functions:
--> print_key_list: Prints the list of all keys and their codes.
--> key_exists: Checks if a key exists in the keys table.

- Shared: Maths
-> Added new functions:
--> mean: Calculates the mean (average) of a list of numbers.
--> median: Calculates the median of a list of numbers.
--> mode: Calculates the mode (most frequent value) of a list of numbers.
--> standard_deviation: Calculates the standard deviation of a list of numbers.
--> linear_regression: Calculates the linear regression coefficients (slope and intercept) for a set of points.

- Shared: Networking -- test section! need tables code first.
-> Removed section, has been split into client and server functions respectively. 

- Shared: Strings
-> Added new functions:
--> to_upper:  Converts a string to uppercase.
--> to_lower: Converts a string to lowercase.
--> truncate: Truncates a string to a specified length.
--> repeat_string: Repeats a string a specified number of times.
--> to_title_case: Converts a string to a title case.
--> capitalize_first: Converts the first character of a string to uppercase.
--> remove_char: Removes all occurrences of a specified character from a string.
--> convert_case: Converts a string from one case to another.
--> slugify: Converts a string to a URL-friendly slug.
--> count_words: Counts the number of words in a string.
--> levenshtein: Calculates the Levenshtein distance between two strings.
--> is_palindrome: Checks if a given string is a palindrome.

- Shared: Tables
-> Added new functions:
--> deep_compare: Compares two nested tables.
--> chunk_table: Chunks a table into smaller tables of a specified size.
--> rotate_table: Rotates a table n places.
--> index_of: Returns the index of a value in a table.
--> zip: Zips two tables into a table of pairs.
--> unzip: Unzips a table of pairs into two separate tables.
--> invert: Inverts a table, swapping keys and values.
--> concatenate: Concatenates two tables.

- Client: Blips
-> Added new functions:
--> pulse_blip: Pulses a blip.
--> flash_blip: Flashes a blip for a certain duration.
--> set_blip_route: Set a route to the blip on the minimap.
--> set_blip_priority: Set the priority of a blip.
--> remove_blip_by_label: Remove a blip by its label.

- Client: Commands
-> Added new function get_suggestions for retrieving command chat suggestions when required.

- Client: Config
-> Removed client config entirely now set all settings server side and callback handles sharing to client.

- Client: Environment
-> Added new functions:
--> set_weather: Sets the current weather.
--> set_game_time: Sets the current game time.
--> get_wind_speed: Retrieves the current wind speed.
--> get_wind_direction: Retrieves the current wind direction.
--> set_wind_speed: Sets the wind speed.
--> set_wind_direction: Sets the wind direction.
--> get_sunrise_sunset_times: Retrieves the sunrise and sunset times based on the weather type.
--> is_daytime: Checks if the current time is day or night.
--> get_current_season: Retrieves the current season based on the in-game date.
--> get_environment_details: Retrieves comprehensive environment details including current season, time, weather, sunrise/sunset times, wind direction and speed, etc.
--> get_distance_to_water: Get the distance from the player to the nearest water body.
--> get_water_height_at_coords: Get the water height at a specific location.

- Client: Frameworks
-> Moved into new bridges folder; client/scripts/bridges.
-> Now automatically detects and sets framework so no longer needs to be defined in config.
-> Added new functions: 
--> get_item: Callback to use server side get_item.

- Client: Groups
-> Added new functions:
--> is_leader: Checks if the player is the leader of a specified group.
--> is_member: Checks if the player is a member of a specified group.
--> get_group_members: Fetches all members of the specified group.
--> get_group_members_by_id: Fetches all members of the group the specified player is in.

- Client: Player
-> Added new functions:
--> play_animation: Runs animation on the player with params.
--> is_player_in_water: Checks if the player is in water.
--> get_player_height_from_water: Retrieves the player's height from the nearest water surface.
--> is_player_near_water: Checks if the player is near water.

- Client: UI
-> Removed and moved to client/scripts/bridges, still uses utils.ui functions.

- Client / Server: Notifications
-> Modified notification bridge function to optimise and improve, now auto detects and uses notify resource without specifying.

- Client: Progressbar
-> Refactor and optimised the progress bridge, still need to add additional progress bar resources, now auto detects resource without specifying.

- Client: Vehicles
-> Modified get_vehicle_details now returns is_rear_engine flag for rear engine vehicles, also stores distance from closest vehicle.

- Server: Config
-> Modified rep, skills, and licences table to simplify.

- Server: Licences
-> Adjusted functions to work with new config layout.

- Server: Reputation
-> Adjusted functions to work with new config layout.

- Server: Skills
-> Adjusted functions to work with new config layout.

- Server: Frameworks
-> Moved some functions around to organise the file a little better.
-> Modified inventory related functions to detect boii_inventory or ox_inventory and redirect from framework functions if using resource is started.
-> Updated update_item_data function now covers new qb-inventory and ox_inventory.

- Client: Bridges

-> Added new bridge for drawtext ui covers show and hide drawtext for boii_ui, ox_lib, qb-core, okokTextUI, es_extended.