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

class StatusHUD {
    constructor() {
        this.container_selector = '#main_container';
        this.status_style = 'circle';
        this.buff_style = 'circle';
        this.debuff_style = 'circle';
        this.injuries = {};
        this.buffs = {};
        this.debuffs = {};
        this.active_statuses = {
            hunger: true,
            thirst: true,
            hygiene: true,
            stress: true,
            oxygen: true
        };
    }

    build_hud() {
        // All credits for human body svg: https://codepen.io/schirrel/pen/qBdVqaG
        const human_body = `
            <div class="human_body">
                <svg id="body" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 198.81 693.96">
                    <path class="head" d="M122.33,106.46c-3.19-4.62-1.59-24.7-1.59-24.7,6.21-4.62,6.85-18.17,6.85-18.17s0.48,2.39,2.87.8,3.19-17.69,2.55-19.12-3.35-1-3.35-1,3.82-21-2.71-31.87S105,0,98.9,0s-21.51,1.59-28,12.43S68.15,44.3,68.15,44.3s-2.71-.48-3.35,1S65,62.79,67.35,64.38s2.87-.8,2.87-0.8,0.64,13.55,6.85,18.17c0,0,1.59,20.08-1.59,24.7h46.85Z" transform="translate(0.5 0.5)"/>
                    <path class="torso_upper" d="M147.08,247.36c-0.06-7.1.64-14.06,2.71-19.47,5.31-13.86,1.87-35.54,4.26-32.35l-5.58-77s-22.95-7.49-26.13-12.11H75.48c-3.19,4.62-26.13,12.11-26.13,12.11l-5.58,77C46.15,192.36,42.71,214,48,227.9c2.07,5.41,2.78,12.37,2.71,19.47h96.34Z" transform="translate(0.5 0.5)"/>
                    <path class="torso_lower" d="M50.73,247.36a136.19,136.19,0,0,1-3.62,28.82c-2.55,10.36-11,68.53-11.79,89.72L97,368.29l1.91-.82,1.91,0.82,61.67-2.39c-0.8-21.2-9.24-79.36-11.79-89.72a136.21,136.21,0,0,1-3.62-28.82H50.73Z" transform="translate(0.5 0.5)"/>
                    <path class="forearm_right" d="M43.76,195.54c-2.39,3.19-4.94,16.09-5.1,25.82s-3.19,23.27-5.74,29,2.23,35.22-.32,50.36-10.36,42.55-10.36,47.81L3.76,346.3c1-10.36-5.42-86.06-3.35-90.68s4-15.46,2.71-22.63S0.42,189.49,4.4,179.92s-0.8-27.25,9.88-44.62,35.06-16.73,35.06-16.73Z" transform="translate(0.5 0.5)"/>
                    <path class="hand_right" d="M22.25,348.54c0,5.26,2.87,6.53,5.42,11.47S27,375.94,27,375.94c2.23,14.82.48,14.82-2.23,14.66s-6.53-12.75-6.53-12.75l-4-1.91s-3.19,3.51-.8,8.92,16.25,12.75,14.66,14.66-6.37-.16-6.37-0.16,9.56,9.24,8.45,10.36a3.53,3.53,0,0,1-2.87.8s2.71,3.19.48,4.62-8.6-3.19-8.6-3.19C10.46,410.69,2,389.33.74,386.94s2.07-30.28,3-40.64Z" transform="translate(0.5 0.5)"/>
                    <path class="thigh_right" d="M35.11,508.33c1.67-14.63,4.15-24,4.67-31.36,0.8-11.31-5.26-89.88-4.46-111.07L97,368.29s0.32,12.43-2.07,21-7.33,19-7.33,33.78-2.23,48.45-6.53,62.31c-3.08,9.94-7,16-7.48,22.91H35.11Z" transform="translate(0.5 0.5)"/>
                    <path class="calf_right" d="M52.37,640.8c0.48-6.53-4.14-41.75-8.76-55.3s-10-16.25-10-48.76a248.59,248.59,0,0,1,1.54-28.4H73.57a21.52,21.52,0,0,0,1.27,8.8c4,11.47,4.62,37.45.48,54.5s-1.75,52.27-1.44,55.3Z" transform="translate(0.5 0.5)"/>
                    <path class="foot_right" d="M73.88,626.94c0.32,3,3.35,6.05,4.94,12.91s-3.51,9.56-1.75,20.4,2.55,31.56-3.35,32.51S66.39,691,66.39,691c-5.9.48-22.79,0.16-25.66-3.19s6.85-26.93,7.81-30.28,0.8-6.69.91-9.4,2.92-7.33,2.92-7.33Z" transform="translate(0.5 0.5)"/>
                    <path class="forearm_left" d="M194,346.3c-1-10.36,5.42-86.06,3.35-90.68s-4-15.46-2.71-22.63,2.71-43.51-1.27-53.07,0.8-27.25-9.88-44.62-35.06-16.73-35.06-16.73l5.58,77c2.39,3.19,4.94,16.09,5.1,25.82s3.19,23.27,5.74,29-2.23,35.22.32,50.36,10.36,42.55,10.36,47.81Z" transform="translate(0.5 0.5)"/>
                    <path class="hand_left" d="M175.56,348.54c0,5.26-2.87,6.53-5.42,11.47s0.64,15.94.64,15.94c-2.23,14.82-.48,14.82,2.23,14.66s6.53-12.75,6.53-12.75l4-1.91s3.19,3.51.8,8.92-16.25,12.75-14.66,14.66,6.37-.16,6.37-0.16-9.56,9.24-8.45,10.36a3.53,3.53,0,0,0,2.87.8s-2.71,3.19-.48,4.62,8.61-3.19,8.61-3.19c8.76-1.28,17.21-22.63,18.49-25s-2.07-30.28-3-40.64Z" transform="translate(0.5 0.5)"/>
                    <path class="thigh_left" d="M162.7,508.33c-1.67-14.63-4.15-24-4.67-31.36-0.8-11.31,5.26-89.88,4.46-111.07l-61.67,2.39s-0.32,12.43,2.07,21,7.33,19,7.33,33.78,2.23,48.45,6.53,62.31c3.08,9.94,7,16,7.48,22.91H162.7Z" transform="translate(0.5 0.5)"/>
                    <path class="calf_left" d="M145.44,640.8c-0.48-6.53,4.14-41.75,8.76-55.3s10-16.25,10-48.76a248.59,248.59,0,0,0-1.54-28.4H124.24a21.52,21.52,0,0,1-1.27,8.8c-4,11.47-4.62,37.45-.48,54.5s1.75,52.27,1.44,55.3Z" transform="translate(0.5 0.5)"/>
                    <path class="foot_left" d="M123.93,626.94c-0.32,3-3.35,6.05-4.94,12.91s3.51,9.56,1.75,20.4-2.55,31.56,3.35,32.51,7.33-1.75,7.33-1.75c5.9,0.48,22.79.16,25.66-3.19s-6.85-26.93-7.81-30.28-0.8-6.69-.91-9.4-2.92-7.33-2.92-7.33Z" transform="translate(0.5 0.5)"/>
                </svg>
            </div>
        `;
        const map_container = `
            <div class="map_container hidden">
                <div class="distance_indicator">
                    <i class="fa-solid fa-location-crosshairs"></i>
                    <p>3.2 miles</p>
                </div>
                <div class="direction_indicator">
                    <p>NW</p>
                </div>
                <div class="street_name_indicator">
                    <i class="fa-solid fa-location-dot"></i>
                    <p>San Andres Ave, Pillbox Hill</p>
                </div>
            </div>
        `;
        const statuses_container = $('<div class="statuses_container"></div>');
        const stat_names = ['hunger', 'thirst', 'hygiene', 'stress', 'oxygen'];
        const stat_icons = ['utensils', 'tint', 'shower', 'brain', 'lungs'];
        stat_names.forEach((name, index) => {
            let stat_item
            let hidden = this.active_statuses[name] ? '' : 'hidden'
            if (this.status_style === 'square') {
                stat_item = `
                <div class="stat_item ${hidden}">
                    <div class="svg_box" style="border-radius: 5px;">
                        <svg viewBox="0 0 101 101" class="progress_svg">
                            <path class="progress_square_border ${name}_border" d="M 15, 10 H 85 C 90, 10 90, 10 90, 15 V 85 C 90, 90 90, 90 85, 90 H 15 C 10, 90 10, 90 10, 85 V 15 C 10, 10 10, 10 15, 10 Z" />
                            <path class="progress_square ${name}_fill" d="M 15, 10 H 85 C 90, 10 90, 10 90, 15 V 85 C 90, 90 90,90 85, 90 H 15 C 10, 90 10, 90 10, 85 V 15 C 10, 10 10, 10 15, 10 Z" stroke-dasharray="320" stroke-dashoffset="320"/>
                        </svg>
                        <span class="icon_background"></span>
                        <i class="fa-solid fa-${stat_icons[index]} ${name}_icon"></i>
                    </div>
                </div>
            `;
            } else if (this.status_style === 'circle') {
                stat_item = `
                    <div class="stat_item ${hidden}">
                        <div class="svg_box" style="border-radius: 50%;">
                            <svg viewBox="0 0 36 36" class="circular-chart">
                                <path class="circle-bg ${name}_border" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"/>
                                <path class="circle ${name}_fill" stroke-dasharray="100, 100" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"/>
                            </svg>
                            <i class="fa-solid fa-${stat_icons[index]} ${name}_icon"></i>
                        </div>
                    </div>
                `;
            }
            statuses_container.append(stat_item);
        });
        const health_armour_container = $('<div class="health_armour_container"></div>');
        const health_armour = ['health', 'armour'];
        health_armour.forEach((name, index) => {
            let content = `<div class="progress_bar ${name}_bar">`;
            let segments = name == 'health' ? 10 : 5
            for (let i = 0; i < segments; i++) {
                content += `<div class="progress_segment ${name}_segment" data-segment="${i}"></div>`;
            }
            content += '</div>';
            health_armour_container.append(content);
        });
        const buffs_debuffs_container = `
            <div class="buffs_debuffs_container">
                <div class="buffs_container"></div>
                <div class="debuffs_container"></div>
            </div>
        `;
        const hud_container = $('<div class="hud_container"></div>').append(statuses_container, health_armour_container, buffs_debuffs_container);
        $(this.container_selector).append(human_body, map_container, hud_container);
    }

    update_injury(body_part, is_injured) {
        let path = $(`.${body_part}`);
        if (is_injured) {
            path.addClass('injured');
        } else {
            path.removeClass('injured');
        }
    }

    update_stats(stats) {
        Object.keys(stats).forEach((key) => {
            if (key === 'health' || key === 'armour') {
                this.update_progress_bar(key, stats[key]);
            } else {
                this.set_svg_progress(`.${key}_fill`, stats[key]);
            }
        });
    }
    
    set_svg_progress(selector, percentage) {
        if (this.status_style === 'square') {
            let total_length = 320;
            let offset = total_length * ((100 - percentage) / 100);
            $(selector).css('stroke-dashoffset', offset);
        } else if (this.status_style === 'circle') {
            const circumference = 100;
            const offset = circumference * (1 - percentage / 100);
            $(selector).css('stroke-dashoffset', offset);
        }
    }
    
    update_progress_bar(name, percentage) {
        let segments = name == 'health' ? 10 : 6
        const filledSegments = Math.ceil((percentage / 100) * segments);
        $(`.${name}_segment`).each(function(index) {
            if (index < filledSegments) {
                $(this).addClass('filled');
            } else {
                $(this).removeClass('filled');
            }
        });
    }

    update_map(direction, road_name, distance) {
        $('.street_name_indicator p').text(road_name || '');
        $('.direction_indicator p').text(direction || '');
        $('.distance_indicator p').text(distance || '');
    }

    show_map() {
        $('.map_container').removeClass('hidden');
    }

    hide_map() {
        $('.map_container').addClass('hidden');
    }

    update_buffs(new_buffs) {
        const container = $('.buffs_container');
        container.empty();
        Object.keys(new_buffs).forEach(id => {
            this.add_buff(new_buffs[id]);
        });
    }

    update_debuffs(new_debuffs) {
        const container = $('.debuffs_container');
        container.empty();
        Object.keys(new_debuffs).forEach(id => {
            this.add_debuff(new_debuffs[id]);
        });
    }

    add_buff(buff) {
        const container = $('.buffs_container');
        const buff_element = $(`
            <div class="buff" id="buff-${buff.id}">
                <i class="${buff.icon}"></i>
            </div>
        `).css({
            'border': `3px solid ${buff.colour}`,
            'border-radius': this.buff_style === 'circle' ? '50%' : '6px',
        });
        container.append(buff_element);
        this.buffs[buff.id] = buff;
        if (buff.duration && buff.duration > 0) {
            setTimeout(() => {
                this.remove_buff(buff.id);
            }, buff.duration * 1000);
        }
    }

    add_debuff(debuff) {
        const container = $('.debuffs_container');
        const debuff_element = $(`
            <div class="debuff" id="debuff-${debuff.id}">
                <i class="${debuff.icon}"></i>
            </div>
        `).css({
            'border': `3px solid ${debuff.colour}`,
            'border-radius': this.debuff_style === 'circle' ? '50%' : '6px',
        });
        container.append(debuff_element);
        this.debuffs[debuff.id] = debuff;

        if (debuff.duration) {
            setTimeout(() => {
                this.remove_debuff(debuff.id);
            }, debuff.duration * 1000);
        }
    }

    remove_buff(id) {
        $(`#buff-${id}`).remove();
        delete this.buffs[id];
    }

    remove_debuff(id) {
        $(`#debuff-${id}`).remove();
        delete this.debuffs[id];
    }
}

/*
$(document).ready(function() {
    let hud = new StatusHUD();
    hud.build_hud();
    let example_data = {
        health: 100,
        armour: 50,
        hunger: 0,
        thirst: 50,
        hygiene: 90,
        stress: 20,
        oxygen: 100
    };

    hud.update_stats(example_data);
    
    hud.show_map();

    let example_buffs = [
        {
            id: 'stamina',
            label: 'Endurance Boost',
            icon: 'fa-solid fa-heart-pulse',
            description: 'Your stamina regeneration has been increased by 100%.',
            duration: 0, // in seconds
            colour: 'rgba(255, 255, 255, 1)',
            can_remove: true
        },
        {
            id: 'speed',
            label: 'Adrenaline Rush',
            icon: 'fa-solid fa-bolt',
            description: 'Your movement speed has been increased by 20%.',
            duration: 0, // in seconds
            colour: 'rgba(255, 255, 255, 1)',
            can_remove: true
        }
    ];

    let example_debuffs = [
        {
            id: 'poison',
            label: 'Poison Debuff',
            icon: 'fa-solid fa-skull-crossbones',
            description: 'Health slowly decreases over time.',
            duration: 0, // in seconds
            colour: 'rgba(255, 255, 255, 0.3)',
            can_remove: true
        },
        {
            id: 'fatigue',
            label: 'Fatigue Debuff',
            icon: 'fa-solid fa-tired',
            description: 'Stamina regeneration decreased by 15%!',
            duration: 0, // in seconds
            colour: 'rgba(255, 255, 255, 0.3)',
            can_remove: true
        }
    ];

    example_buffs.forEach(buff => {
        hud.add_buff(buff);
    });

    example_debuffs.forEach(debuff => {
        hud.add_debuff(debuff);
    });

    hud.update_injury('head', true);
    hud.update_injury('forearm_right', true);
});
*/