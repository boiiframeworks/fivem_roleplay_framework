item_list.hobo_life = {

    --- Begging
    beggers_sign = {
        id = 'beggers_sign',
        category = 'hobo_life',
        label = 'Blank Begger Sign',
        description = 'A blank beggers sign, find a pen and write on it!',
        image = 'beggers_sign.png',
        model = 'prop_cs_street_card_01',
        weight = 100,
        max_stack = nil,
        unique = false,
        on_use = {
            event = {
                event_type = 'client',
                event = 'boii_hobolife:cl:create_beggers_sign'
            },
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item', 
                params = {
                    item = 'beggers_sign'
                }
            }
        }
    },

    permanent_marker = {
        id = 'permanent_marker',
        category = 'hobo_life',
        label = 'Permanent Marker',
        description = 'A permanent marker, I wonder what you could write on?',
        image = 'permanent_marker.png',
        model = 'bkr_prop_fakeid_penclipboard',
        weight = 100,
        max_stack = nil,
        unique = false,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item', 
                params = {
                    item = 'permanent_marker'
                }
            }
        }
    },

    beggers_sign_01 = {
        id = 'beggers_sign_01',
        category = 'hobo_life',
        label = 'Beggers Sign #1',
        description = 'Need money for beer, pot and hookers! At least Im not lying.',
        image = 'beggers_sign_01.png',
        model = 'prop_beggers_sign_01',
        weight = 100,
        max_stack = nil,
        unique = false,
        on_use = {
            event = {
                event_type = 'server',
                event = 'boii_hobolife:sv:init_begging',
                params = { sign_type = 'beggers_sign_01' }
            },
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item', 
                params = {
                    item = 'beggers_sign_01'
                }
            }
        }
    },
    
    beggers_sign_02 = {
        id = 'beggers_sign_02',
        category = 'hobo_life',
        label = 'Beggers Sign #2',
        description = 'Serbian bad guys stole all my money! Please help!',
        image = 'beggers_sign_02.png',
        model = 'prop_beggers_sign_02',
        weight = 100,
        max_stack = nil,
        unique = false,
        on_use = {
            event = {
                event_type = 'server',
                event = 'boii_hobolife:sv:init_begging',
                params = { sign_type = 'beggers_sign_02' }
            },
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item', 
                params = {
                    item = 'beggers_sign_02'
                }
            }
        }
    },

    beggers_sign_03 = {
        id = 'beggers_sign_03',
        category = 'hobo_life',
        label = 'Beggers Sign #3',
        description = 'Bet you cant hit me with a quarter!',
        image = 'beggers_sign_03.png',
        model = 'prop_beggers_sign_03',
        weight = 100,
        max_stack = nil,
        unique = false,
        on_use = {
            event = {
                event_type = 'server',
                event = 'boii_hobolife:sv:init_begging',
                params = { sign_type = 'beggers_sign_03' }
            },
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item', 
                params = {
                    item = 'beggers_sign_03'
                }
            }
        }
    },

    beggers_sign_04 = {
        id = 'beggers_sign_04',
        category = 'hobo_life',
        label = 'Beggers Sign #4',
        description = 'Console burst again! Need money to help fix!',
        image = 'beggers_sign_04.png',
        model = 'prop_beggers_sign_04',
        weight = 100,
        max_stack = nil,
        unique = false,
        on_use = {
            event = {
                event_type = 'server',
                event = 'boii_hobolife:sv:init_begging',
                params = { sign_type = 'beggers_sign_04' }
            },
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item', 
                params = {
                    item = 'beggers_sign_04'
                }
            }
        }
    },

    -- Recipe items
    stale_cheese_sandwich = {
        id = 'stale_cheese_sandwich',
        category = 'consumables',
        label = 'Stale Cheese Sandwich',
        description = 'A old, stale cheese sandwich, sort of tasty though?',
        image = 'stale_cheese_sandwich.png',
        weight = 1,
        model = 'prop_sandwich_01',
        on_use = {
            progressbar = {
                header = 'Eating..',
                icon = 'fa-solid fa-burger',
                duration = 2500,
                animation = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 },
                props = {
                    { model = 'prop_sandwich_01', bone = 18905, coords = vector3(0.13, 0.05, 0.02), rotation = vector3(-50.0, 16.0, 60.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
                },
                on_success = {
                    event = {
                        event_type = 'server',
                        event = 'boii_items:sv:consume_item',
                        params = {
                            item = 'stale_cheese_sandwich',
                            statuses = {
                                hunger = { add = 20, remove = 0 },
                                thirst = { add = 0, remove = 5 },
                                stress = { add = 3, remove = 0 }
                            }
                        },
                    },
                    notify = {
                        type = 'success',
                        header = 'CONSUMABLES',
                        message = 'You ate a stale cheese sandwich.',
                        duration = 3000
                    },
                },
                on_cancel = {
                    notify = {
                        type = 'error',
                        header = 'CONSUMABLES',
                        message = 'You stopped eating your stale cheese sandwich..',
                        duration = 3000
                    },
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'stale_cheese_sandwich'
                }
            }
        }
    },

    stale_steak_sandwich = {
        id = 'stale_steak_sandwich',
        category = 'consumables',
        label = 'Stale Steak Sandwich',
        description = 'A old, stale steak sandwich, sort of tasty though?',
        image = 'stale_steak_sandwich.png',
        weight = 1,
        model = 'prop_sandwich_01',
        on_use = {
            progressbar = {
                header = 'Eating..',
                icon = 'fa-solid fa-burger',
                duration = 2500,
                animation = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 },
                props = {
                    { model = 'prop_sandwich_01', bone = 18905, coords = vector3(0.13, 0.05, 0.02), rotation = vector3(-50.0, 16.0, 60.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
                },
                on_success = {
                    event = {
                        event_type = 'server',
                        event = 'boii_items:sv:consume_item',
                        params = {
                            item = 'stale_steak_sandwich',
                            statuses = {
                                hunger = { add = 35, remove = 0 },
                                thirst = { add = 0, remove = 5 },
                                stress = { add = 3, remove = 0 }
                            }
                        },
                    },
                    notify = {
                        type = 'success',
                        header = 'CONSUMABLES',
                        message = 'You ate a stale steak sandwich.',
                        duration = 3000
                    },
                },
                on_cancel = {
                    notify = {
                        type = 'error',
                        header = 'CONSUMABLES',
                        message = 'You stopped eating your stale steak sandwich..',
                        duration = 3000
                    },
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'stale_steak_sandwich'
                }
            }
        }
    },

    rat_taco = {
        id = 'rat_taco',
        category = 'consumables',
        label = 'Rat Taco',
        description = 'A nicely spiced rat taco? Eww..',
        image = 'rat_taco.png',
        weight = 1,
        model = 'prop_taco_01',
        on_use = {
            progressbar = {
                header = 'Eating..',
                icon = 'fa-solid fa-burger',
                duration = 2500,
                animation = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 },
                props = {
                    { model = 'prop_taco_01', bone = 18905, coords = vector3(0.13, 0.05, 0.02), rotation = vector3(-50.0, 16.0, 60.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
                },
                on_success = {
                    event = {
                        event_type = 'server',
                        event = 'boii_items:sv:consume_item',
                        params = {
                            item = 'rat_taco',
                            statuses = {
                                hunger = { add = 40, remove = 0 },
                                thirst = { add = 0, remove = 5 },
                                stress = { add = 3, remove = 0 }
                            }
                        },
                    },
                    notify = {
                        type = 'success',
                        header = 'CONSUMABLES',
                        message = 'You ate a spiced rat.',
                        duration = 3000
                    },
                },
                on_cancel = {
                    notify = {
                        type = 'error',
                        header = 'CONSUMABLES',
                        message = 'You stopped eating your spice rat..',
                        duration = 3000
                    },
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'rat_taco'
                }
            }
        }
    },

    pigeon_soup = {
        id = 'pigeon_soup',
        category = 'consumables',
        label = 'Pigeon Soup',
        description = 'A warm bowl of pigeon soup, feathers and all..',
        image = 'pigeon_soup.png',
        weight = 1,
        model = 'v_res_mbowl',
        on_use = {
            progressbar = {
                header = 'Eating..',
                icon = 'fa-solid fa-burger',
                duration = 2500,
                animation = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 },
                props = {
                    { model = 'v_res_mbowl', bone = 18905, coords = vector3(0.13, 0.05, 0.02), rotation = vector3(-50.0, 16.0, 60.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
                },
                on_success = {
                    event = {
                        event_type = 'server',
                        event = 'boii_items:sv:consume_item',
                        params = {
                            item = 'pigeon_soup',
                            statuses = {
                                hunger = { add = 45, remove = 0 },
                                thirst = { add = 0, remove = 5 },
                                stress = { add = 3, remove = 0 }
                            }
                        },
                    },
                    notify = {
                        type = 'success',
                        header = 'CONSUMABLES',
                        message = 'You ate a bowl of pigeon soup.',
                        duration = 3000
                    },
                },
                on_cancel = {
                    notify = {
                        type = 'error',
                        header = 'CONSUMABLES',
                        message = 'You stopped eating a bowl of pigeon soup..',
                        duration = 3000
                    },
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'pigeon_soup'
                }
            }
        }
    },

    back_alley_borscht = {
        id = 'back_alley_borscht',
        category = 'consumables',
        label = 'Back Alley Borscht',
        description = 'A warm bowl of borscht! Who doesnt love beetroot..',
        image = 'back_alley_borscht.png',
        weight = 1,
        model = 'v_res_mbowl',
        on_use = {
            progressbar = {
                header = 'Eating..',
                icon = 'fa-solid fa-burger',
                duration = 2500,
                animation = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 },
                props = {
                    { model = 'v_res_mbowl', bone = 18905, coords = vector3(0.13, 0.05, 0.02), rotation = vector3(-50.0, 16.0, 60.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
                },
                on_success = {
                    event = {
                        event_type = 'server',
                        event = 'boii_items:sv:consume_item',
                        params = {
                            item = 'back_alley_borscht',
                            statuses = {
                                hunger = { add = 45, remove = 0 },
                                thirst = { add = 0, remove = 5 },
                                stress = { add = 3, remove = 0 }
                            }
                        },
                    },
                    notify = {
                        type = 'success',
                        header = 'CONSUMABLES',
                        message = 'You ate a bowl of pigeon soup.',
                        duration = 3000
                    },
                },
                on_cancel = {
                    notify = {
                        type = 'error',
                        header = 'CONSUMABLES',
                        message = 'You stopped eating a bowl of pigeon soup..',
                        duration = 3000
                    },
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'back_alley_borscht'
                }
            }
        }
    },

    rabbit_stew = {
        id = 'rabbit_stew',
        category = 'consumables',
        label = 'Rabbit Stew',
        description = 'A warm bowl of rabbit stew!',
        image = 'rabbit_stew.png',
        weight = 1,
        model = 'prop_cs_bowl_01b',
        on_use = {
            progressbar = {
                header = 'Eating..',
                icon = 'fa-solid fa-burger',
                duration = 2500,
                animation = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 },
                props = {
                    { model = 'prop_cs_bowl_01b', bone = 18905, coords = vector3(0.13, 0.05, 0.02), rotation = vector3(-50.0, 16.0, 60.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
                },
                on_success = {
                    event = {
                        event_type = 'server',
                        event = 'boii_items:sv:consume_item',
                        params = {
                            item = 'rabbit_stew',
                            statuses = {
                                hunger = { add = 55, remove = 0 },
                                thirst = { add = 0, remove = 5 },
                                stress = { add = 3, remove = 0 }
                            }
                        },
                    },
                    notify = {
                        type = 'success',
                        header = 'CONSUMABLES',
                        message = 'You ate a bowl of rabbit stew.',
                        duration = 3000
                    },
                },
                on_cancel = {
                    notify = {
                        type = 'error',
                        header = 'CONSUMABLES',
                        message = 'You stopped eating a bowl of rabbit stew..',
                        duration = 3000
                    },
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'rabbit_stew'
                }
            }
        }
    },

    rabbit_taco = {
        id = 'rabbit_taco',
        category = 'consumables',
        label = 'Rabbit Taco',
        description = 'A taco except made with rabbit!',
        image = 'rabbit_taco.png',
        weight = 1,
        model = 'prop_taco_01',
        on_use = {
            progressbar = {
                header = 'Eating..',
                icon = 'fa-solid fa-burger',
                duration = 2500,
                animation = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 },
                props = {
                    { model = 'prop_taco_01', bone = 18905, coords = vector3(0.13, 0.05, 0.02), rotation = vector3(-50.0, 16.0, 60.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
                },
                on_success = {
                    event = {
                        event_type = 'server',
                        event = 'boii_items:sv:consume_item',
                        params = {
                            item = 'rabbit_taco',
                            statuses = {
                                hunger = { add = 75, remove = 0 },
                                thirst = { add = 0, remove = 5 },
                                stress = { add = 3, remove = 0 }
                            }
                        },
                    },
                    notify = {
                        type = 'success',
                        header = 'CONSUMABLES',
                        message = 'You ate a rabbit taco.',
                        duration = 3000
                    },
                },
                on_cancel = {
                    notify = {
                        type = 'error',
                        header = 'CONSUMABLES',
                        message = 'You stopped eating a rabbit taco..',
                        duration = 3000
                    },
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'rabbit_taco'
                }
            }
        }
    },

    gutter_goulash = {
        id = 'gutter_goulash',
        category = 'consumables',
        label = 'Gutter Goulash',
        description = 'A bowl of goulash made from gutter grub!',
        image = 'gutter_goulash.png',
        weight = 1,
        model = 'prop_cs_bowl_01b',
        on_use = {
            progressbar = {
                header = 'Eating..',
                icon = 'fa-solid fa-burger',
                duration = 2500,
                animation = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 },
                props = {
                    { model = 'prop_cs_bowl_01b', bone = 18905, coords = vector3(0.13, 0.05, 0.02), rotation = vector3(-50.0, 16.0, 60.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
                },
                on_success = {
                    event = {
                        event_type = 'server',
                        event = 'boii_items:sv:consume_item',
                        params = {
                            item = 'gutter_goulash',
                            statuses = {
                                hunger = { add = 90, remove = 0 },
                                thirst = { add = 10, remove = 0 },
                                stress = { add = 3, remove = 0 }
                            }
                        },
                    },
                    notify = {
                        type = 'success',
                        header = 'CONSUMABLES',
                        message = 'You ate a bowl of gutter goulash.',
                        duration = 3000
                    },
                },
                on_cancel = {
                    notify = {
                        type = 'error',
                        header = 'CONSUMABLES',
                        message = 'You stopped eating a bowl of gutter goulash..',
                        duration = 3000
                    },
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'gutter_goulash'
                }
            }
        }
    },

    sidewalk_stir_fry = {
        id = 'sidewalk_stir_fry',
        category = 'consumables',
        label = 'Sidewalk Stir Fry',
        description = 'A bowl of sidewalk stir fry! Actually tasty..',
        image = 'sidewalk_stir_fry.png',
        weight = 1,
        model = 'prop_cs_bowl_01b',
        on_use = {
            progressbar = {
                header = 'Eating..',
                icon = 'fa-solid fa-burger',
                duration = 2500,
                animation = { dict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger', flags = 49, blend_in = 8.0, blend_out = -8.0, duration = -1, playback = 1, lock_x = 0, lock_y = 0, lock_z = 0 },
                props = {
                    { model = 'prop_cs_bowl_01b', bone = 18905, coords = vector3(0.13, 0.05, 0.02), rotation = vector3(-50.0, 16.0, 60.0), soft_pin = false, collision = false, is_ped = true, rot_order = 1, sync_rot = true }
                },
                on_success = {
                    event = {
                        event_type = 'server',
                        event = 'boii_items:sv:consume_item',
                        params = {
                            item = 'sidewalk_stir_fry',
                            statuses = {
                                hunger = { add = 100, remove = 0 },
                                thirst = { add = 20, remove = 0 },
                                stress = { add = 3, remove = 0 }
                            }
                        },
                    },
                    notify = {
                        type = 'success',
                        header = 'CONSUMABLES',
                        message = 'You ate a bowl of sidewalk stir fry.',
                        duration = 3000
                    },
                },
                on_cancel = {
                    notify = {
                        type = 'error',
                        header = 'CONSUMABLES',
                        message = 'You stopped eating a bowl of sidewalk stir fry..',
                        duration = 3000
                    },
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'sidewalk_stir_fry'
                }
            }
        }
    },

    -- Ingredients
    old_bread = {
        id = 'old_bread',
        category = 'ingredients',
        label = 'Old Bread',
        description = 'A old, moldy piece of bread.',
        image = 'old_bread.png',
        weight = 1,
        model = 'v_res_fa_bread03',
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'stale_cheese_sandwich'
                }
            }
        }
    },

    old_cheese = {
        id = 'old_cheese',
        category = 'ingredients',
        label = 'Old Cheese',
        description = 'A old, moldy block of cheese.',
        image = 'old_cheese.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'old_cheese'
                }
            }
        }
    },

    old_steak = {
        id = 'old_steak',
        category = 'ingredients',
        label = 'Old Steak',
        description = 'A old, half eaten steak.',
        image = 'old_steak.png',
        weight = 1,
        model = 'prop_cs_steak',
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'old_steak'
                }
            }
        }
    },

    can_tomato_soup = {
        id = 'can_tomato_soup',
        category = 'ingredients',
        label = 'Canned Tomato Soup',
        description = 'A can of tomato soup.',
        image = 'can_tomato_soup.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'can_tomato_soup'
                }
            }
        }
    },

    can_sweetcorn = {
        id = 'can_sweetcorn',
        category = 'ingredients',
        label = 'Canned Sweetcorn',
        description = 'A can of sweetcorn.',
        image = 'can_sweetcorn.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'can_sweetcorn'
                }
            }
        }
    },

    lettuce = {
        id = 'lettuce',
        category = 'ingredients',
        label = 'Lettuce',
        description = 'A large crisp lettuce.',
        image = 'lettuce.png',
        weight = 1,
        model = 'prop_veg_crop_03_cab',
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'lettuce'
                }
            }
        }
    },

    onion = {
        id = 'onion',
        category = 'ingredients',
        label = 'Onion',
        description = 'A large red onion.',
        image = 'onion.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'onion'
                }
            }
        }
    },

    potato = {
        id = 'potato',
        category = 'ingredients',
        label = 'Potato',
        description = 'A large all rounder potato.',
        image = 'potato.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'potato'
                }
            }
        }
    },

    carrot = {
        id = 'carrot',
        category = 'ingredients',
        label = 'Carrot',
        description = 'A large carrot.',
        image = 'carrot.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'carrot'
                }
            }
        }
    },

    beetroot = {
        id = 'beetroot',
        category = 'ingredients',
        label = 'Beetroot',
        description = 'A large beetroot.',
        image = 'beetroot.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'beetroot'
                }
            }
        }
    },

    curdled_milk = {
        id = 'curdled_milk',
        category = 'ingredients',
        label = 'Curdled Milk',
        description = 'A carton of curdled milk.. cheesey..',
        image = 'curdled_milk.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'curdled_milk'
                }
            }
        }
    },

    spice_mix = {
        id = 'spice_mix',
        category = 'ingredients',
        label = 'Spice Mix',
        description = 'A container of spice mix.',
        image = 'spice_mix.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'spice_mix'
                }
            }
        }
    },

    taco_shell = {
        id = 'taco_shell',
        category = 'ingredients',
        label = 'Taco Shell',
        description = 'A empty taco shell.',
        image = 'taco_shell.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'taco_shell'
                }
            }
        }
    },

    egg = {
        id = 'egg',
        category = 'ingredients',
        label = 'Egg',
        description = 'A large chicken egg.',
        image = 'egg.png',
        model = 'v_ret_247_eggs',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'egg'
                }
            }
        }
    },

    dead_rat = {
        id = 'dead_rat',
        category = 'ingredients',
        label = 'Dead Rat',
        description = 'A dead rat.. Its still warm..',
        image = 'dead_rat.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'dead_rat'
                }
            }
        }
    },

    dead_pigeon = {
        id = 'dead_pigeon',
        category = 'ingredients',
        label = 'Dead Pigeon',
        description = 'A dead pigeon.. Its still warm..',
        image = 'dead_pigeon.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'dead_pigeon'
                }
            }
        }
    },

    dead_rabbit = {
        id = 'dead_rabbit',
        category = 'ingredients',
        label = 'Dead Rabbit',
        description = 'A dead rabbit.. Its still warm..',
        image = 'dead_rabbit.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'dead_rabbit'
                }
            }
        }
    },

    soy_sauce_packet = {
        id = 'soy_sauce_packet',
        category = 'ingredients',
        label = 'Soy Sauce Packet',
        description = 'A packet of soy sauce..',
        image = 'soy_sauce_packet.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'soy_sauce_packet'
                }
            }
        }
    },

    instant_noodles = {
        id = 'instant_noodles',
        category = 'ingredients',
        label = 'Instant Noodles',
        description = 'A tub of instant noodles..',
        image = 'instant_noodles.png',
        weight = 1,
        model = 'v_res_fa_potnoodle',
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'instant_noodles'
                }
            }
        }
    },

    -- Burnt food
    burnt_sandwich = {
        id = 'burnt_sandwich',
        category = 'junk',
        label = 'Burnt Sandwich',
        description = 'A burnt sandwich.. So burnt you cant tell what it was.',
        image = 'burnt_sandwich.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'burnt_sandwich'
                }
            }
        }
    },

    burnt_soup = {
        id = 'burnt_soup',
        category = 'junk',
        label = 'Burnt Soup',
        description = 'A burnt pot of soup.. So burnt you cant tell what it was.',
        image = 'burnt_soup.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'burnt_soup'
                }
            }
        }
    },

    burnt_taco = {
        id = 'burnt_taco',
        category = 'junk',
        label = 'Burnt Taco',
        description = 'A burnt taco.. So burnt you cant tell what it was..',
        image = 'burnt_taco.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'burnt_taco'
                }
            }
        }
    },

    burnt_stew = {
        id = 'burnt_stew',
        category = 'junk',
        label = 'Burnt Stew',
        description = 'A burnt stew.. So burnt you cant tell what it was..',
        image = 'burnt_stew.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'burnt_stew'
                }
            }
        }
    },

    -- Companions
    companion_rat = {
        id = 'companion_rat',
        category = 'companion',
        label = 'Companion: Rat',
        description = 'Your very own pet rat.',
        image = 'companion_rat.png',
        weight = 1,
        on_use = {
            event = {
                event_type = 'server',
                event = 'boii_hobolife:sv:spawn_companion',
                params = {
                    companion = 'rat', 
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_rat'
                }
            }
        },
        data = {}
    },

    companion_pigeon = {
        id = 'companion_pigeon',
        category = 'companion',
        label = 'Companion: Pigeon',
        description = 'Your very own pet pigeon.',
        image = 'companion_pigeon.png',
        weight = 1,
        on_use = {
            event = {
                event_type = 'server',
                event = 'boii_hobolife:sv:spawn_companion',
                params = {
                    companion = 'pigeon', 
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_pigeon'
                }
            }
        },
        data = {}
    },

    companion_cat = {
        id = 'companion_cat',
        category = 'companion',
        label = 'Companion: Cat',
        description = 'Your very own pet cat.',
        image = 'companion_cat.png',
        weight = 1,
        on_use = {
            event = {
                event_type = 'server',
                event = 'boii_hobolife:sv:spawn_companion',
                params = {
                    companion = 'cat', 
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_cat'
                }
            }
        },
        data = {}
    },

    companion_chicken = {
        id = 'companion_chicken',
        category = 'companion',
        label = 'Companion: Chicken',
        description = 'Your very own pet chicken.',
        image = 'companion_chicken.png',
        weight = 1,
        on_use = {
            event = {
                event_type = 'server',
                event = 'boii_hobolife:sv:spawn_companion',
                params = {
                    companion = 'chicken', 
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_chicken'
                }
            }
        },
        data = {}
    },

    companion_seagull = {
        id = 'companion_seagull',
        category = 'companion',
        label = 'Companion: Seagull',
        description = 'Your very own pet seagull.',
        image = 'companion_seagull.png',
        weight = 1,
        on_use = {
            event = {
                event_type = 'server',
                event = 'boii_hobolife:sv:spawn_companion',
                params = {
                    companion = 'seagull', 
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_seagull'
                }
            }
        },
        data = {}
    },

    companion_crow = {
        id = 'companion_crow',
        category = 'companion',
        label = 'Companion: Seagull',
        description = 'Your very own pet crow.',
        image = 'companion_crow.png',
        weight = 1,
        on_use = {
            event = {
                event_type = 'server',
                event = 'boii_hobolife:sv:spawn_companion',
                params = {
                    companion = 'crow', 
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_crow'
                }
            }
        },
        data = {}
    },

    companion_rabbit = {
        id = 'companion_rabbit',
        category = 'companion',
        label = 'Companion: Rabbit',
        description = 'Your very own pet rabbit.',
        image = 'companion_rabbit.png',
        weight = 1,
        on_use = {
            event = {
                event_type = 'server',
                event = 'boii_hobolife:sv:spawn_companion',
                params = {
                    companion = 'rabbit', 
                }
            }
        },
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_rabbit'
                }
            }
        },
        data = {}
    },

    companion_rat_food = {
        id = 'companion_rat_food',
        category = 'companion',
        label = 'Rat Food',
        description = 'Food for your pet rat.',
        image = 'companion_rat_food.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_rat_food'
                }
            }
        },
        data = {}
    },

    companion_rabbit_food = {
        id = 'companion_rabbit_food',
        category = 'companion',
        label = 'Rabbit Food',
        description = 'Food for your pet rabbit.',
        image = 'companion_rabbit_food.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_rabbit_food'
                }
            }
        },
        data = {}
    },

    companion_bird_food = {
        id = 'companion_bird_food',
        category = 'companion',
        label = 'Bird Seed',
        description = 'Food for your pet birds.',
        image = 'companion_bird_food.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_bird_food'
                }
            }
        },
        data = {}
    },

    companion_cat_food = {
        id = 'companion_cat_food',
        category = 'companion',
        label = 'Cat Food',
        description = 'Food for your pet cat.',
        image = 'companion_cat_food.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_cat_food'
                }
            }
        },
        data = {}
    },

    companion_chicken_food = {
        id = 'companion_chicken_food',
        category = 'companion',
        label = 'Chicken Feed',
        description = 'Food for your pet chicken.',
        image = 'companion_chicken_food.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_chicken_food'
                }
            }
        },
        data = {}
    },

    companion_bandage = {
        id = 'companion_bandage',
        category = 'companion',
        label = 'Companion Bandage',
        description = 'A bandage for restoring your companions health.',
        image = 'companion_bandage.png',
        weight = 1,
        on_drop = {
            event = {
                event_type = 'server',
                event = 'boii_items:cl:drop_item',
                params = {
                    item = 'companion_bandage'
                }
            }
        },
        data = {}
    },

}