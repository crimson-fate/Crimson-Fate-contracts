use crimson_fate::models::skill::{CommonSkill, EvilSkill};
use core::panic_with_felt252;

pub fn common_skill_to_index(skill: felt252) -> u16 {
    if skill == CommonSkill::Fire_Explose.into() {
        return 0;
    } else if skill == CommonSkill::Groundfire.into() {
        return 1;
    } else if skill == CommonSkill::Flame_Trail.into() {
        return 2;
    } else if skill == CommonSkill::Fire_Shield.into() {
        return 3;
    } else if skill == CommonSkill::Bouncing_Thunder.into() {
        return 4;
    } else if skill == CommonSkill::Lightning_Explose.into() {
        return 5;
    } else if skill == CommonSkill::Static_Lightning_Ball.into() {
        return 6;
    } else if skill == CommonSkill::Lightning_Shield.into() {
        return 7;
    } else if skill == CommonSkill::Machine_Gun.into() {
        return 8;
    } else if skill == CommonSkill::Rotate_Saw_Blade.into() {
        return 9;
    } else if skill == CommonSkill::Static_Saw.into() {
        return 10;
    } else if skill == CommonSkill::Shotgun.into() {
        return 11;
    } else if skill == CommonSkill::Ground_Stamp.into() {
        return 12;
    } else if skill == CommonSkill::Immune_Shield.into() {
        return 13;
    } else if skill == CommonSkill::Moonlight_Gyro.into() {
        return 14;
    } else if skill == CommonSkill::Meteor.into() {
        return 15;
    } else if skill == CommonSkill::Radiance.into() {
        return 16;
    } else if skill == CommonSkill::Toxic_Swamp.into() {
        return 17;
    } else if skill == CommonSkill::Venom_Shot.into() {
        return 18;
    } else if skill == CommonSkill::Plague_Ward.into() {
        return 19;
    }
    panic_with_felt252('skill not found')
}

pub fn evil_skill_to_index(skill: felt252) -> u16 {
    if skill == EvilSkill::Flame_Arrow.into() {
        return 0;
    } else if skill == EvilSkill::Flame_Orb.into() {
        return 1;
    } else if skill == EvilSkill::Lightning_Strike.into() {
        return 2;
    } else if skill == EvilSkill::Rotate_Lightning_Ball.into() {
        return 3;
    } else if skill == EvilSkill::Light_Gun_Drone.into() {
        return 4;
    } else if skill == EvilSkill::Rocket_Drone.into() {
        return 5;
    } else if skill == EvilSkill::Magic_Burst.into() {
        return 6;
    } else if skill == EvilSkill::Holy_Light.into() {
        return 7;
    } else if skill == EvilSkill::Toxic_Explose.into() {
        return 8;
    } else if skill == EvilSkill::Acid_Rain.into() {
        return 9;
    }
    panic_with_felt252('skill not found')
}

pub fn index_to_common_skill(index: u16) -> felt252 {
    match index {
        0 => CommonSkill::Fire_Explose.into(),
        1 => CommonSkill::Groundfire.into(),
        2 => CommonSkill::Flame_Trail.into(),
        3 => CommonSkill::Fire_Shield.into(),
        4 => CommonSkill::Bouncing_Thunder.into(),
        5 => CommonSkill::Lightning_Explose.into(),
        6 => CommonSkill::Static_Lightning_Ball.into(),
        7 => CommonSkill::Lightning_Shield.into(),
        8 => CommonSkill::Machine_Gun.into(),
        9 => CommonSkill::Rotate_Saw_Blade.into(),
        10 => CommonSkill::Static_Saw.into(),
        11 => CommonSkill::Shotgun.into(),
        12 => CommonSkill::Ground_Stamp.into(),
        13 => CommonSkill::Immune_Shield.into(),
        14 => CommonSkill::Moonlight_Gyro.into(),
        15 => CommonSkill::Meteor.into(),
        16 => CommonSkill::Radiance.into(),
        17 => CommonSkill::Toxic_Swamp.into(),
        18 => CommonSkill::Venom_Shot.into(),
        19 => CommonSkill::Plague_Ward.into(),
        _ => panic_with_felt252('index out of range')
    }
}

pub fn index_to_evil_skill(index: u16) -> felt252 {
    match index {
        0 => EvilSkill::Flame_Arrow.into(),
        1 => EvilSkill::Flame_Orb.into(),
        2 => EvilSkill::Lightning_Strike.into(),
        3 => EvilSkill::Rotate_Lightning_Ball.into(),
        4 => EvilSkill::Light_Gun_Drone.into(),
        5 => EvilSkill::Rocket_Drone.into(),
        6 => EvilSkill::Magic_Burst.into(),
        7 => EvilSkill::Holy_Light.into(),
        8 => EvilSkill::Toxic_Explose.into(),
        9 => EvilSkill::Acid_Rain.into(),
        _ => panic_with_felt252('index out of range')
    }
}
