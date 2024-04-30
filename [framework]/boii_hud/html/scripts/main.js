/*
    ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
   |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
   | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
   |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
   | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
   |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                             | |                                                                                
                             |_|                   HUD
*/


let hud = null;
let speedometer = null;

window.addEventListener('message', function(event) {
    let data = event.data;

    switch(data.action) {
        case 'init_hud':
            hud = new StatusHUD();
            hud.build_hud();
            speedometer = new Speedo();
            speedometer.build();
            break;
        case 'update_stats':
            hud.update_stats(data.statuses);
            break;
        case 'update_map':
            hud.show_map();
            hud.update_map(data.direction, data.road_name, data.distance);
            break;
        case 'update_injury':
            hud.update_injury(data.area, data.injured);
            break;
        case 'update_buffs':
            hud.update_buffs(data.buffs);
            break;
        case 'update_debuffs':
            hud.update_debuffs(data.debuffs);
            break;
        case 'hide_map':
            hud.hide_map();
            if (speedometer) {
                speedometer.hide();
            }
            break;
        case 'update_speedo':
            if (speedometer) {
                speedometer.show();
                speedometer.update_speed(data.speed);
                speedometer.update_gear(data.gear);
                speedometer.update_fuel(data.fuel);
                speedometer.update_body_health(data.engine_health);
                speedometer.update_engine_health(data.body_health);
                speedometer.update_mileage(data.mileage);
            }
        case 'update_indicator':
            if (speedometer) {
                speedometer.update_indicator(data.indicator, data.colour, data.animation);
            }
            break;
    }
});
