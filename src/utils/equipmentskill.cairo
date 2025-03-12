use crimson_fate::models::equipmentskill::EEquipmentSkill;
use core::panic_with_felt252;

pub fn select_equipment_skill(index: u16) -> EEquipmentSkill {
    match index {
        0 => EEquipmentSkill::Flame_Arrow,
        1 => EEquipmentSkill::Fire_Explose,
        2 => EEquipmentSkill::Groundfire,
        3 => EEquipmentSkill::Flame_Orb,
        4 => EEquipmentSkill::Flame_Trail,
        5 => EEquipmentSkill::Fire_Shield,
        6 => EEquipmentSkill::Bouncing_Thunder,
        7 => EEquipmentSkill::Lightning_Explose,
        8 => EEquipmentSkill::Lightning_Strike,
        9 => EEquipmentSkill::Rotate_Lightning_Ball,
        10 => EEquipmentSkill::Static_Lightning_Ball,
        11 => EEquipmentSkill::Lightning_Shield,
        12 => EEquipmentSkill::Machine_Gun,
        13 => EEquipmentSkill::Rotate_Saw_Blade,
        14 => EEquipmentSkill::Static_Saw,
        15 => EEquipmentSkill::Light_Gun_Drone,
        16 => EEquipmentSkill::Rocket_Drone,
        17 => EEquipmentSkill::Shotgun,
        18 => EEquipmentSkill::Ground_Stamp,
        19 => EEquipmentSkill::Magic_Burst,
        20 => EEquipmentSkill::Immune_Shield,
        21 => EEquipmentSkill::Moonlight_Gyro,
        22 => EEquipmentSkill::Meteor,
        23 => EEquipmentSkill::Holy_Light,
        24 => EEquipmentSkill::Radiance,
        25 => EEquipmentSkill::Toxic_Explose,
        26 => EEquipmentSkill::Toxic_Swamp,
        27 => EEquipmentSkill::Acid_Rain,
        28 => EEquipmentSkill::Venom_Shot,
        29 => EEquipmentSkill::Plague_Ward,
        30 => EEquipmentSkill::Cloak,
        31 => EEquipmentSkill::Pants,
        32 => EEquipmentSkill::Gloves,
        33 => EEquipmentSkill::Boots,
        34 => EEquipmentSkill::Magic_Ring,
        _ => panic_with_felt252('index out of range')
    }
}
