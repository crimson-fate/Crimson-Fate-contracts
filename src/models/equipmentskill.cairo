use starknet::ContractAddress;

#[derive(Drop, Copy, Serde)]
#[dojo::model]
pub struct CurrentReceiveSkill {
    #[key]
    pub player: ContractAddress,
    pub skills: Span<SelectSkill>,
}

#[derive(Drop, Copy, Serde, Introspect)]
pub struct SelectSkill {
    pub skill: EEquipmentSkill,
    pub is_selected: bool,
}

#[derive(Drop, Copy, Serde, PartialEq, Introspect)]
pub enum EEquipmentSkill {
    Flame_Arrow,
    Fire_Explose,
    Groundfire,
    Flame_Orb,
    Flame_Trail,
    Fire_Shield,
    Bouncing_Thunder,
    Lightning_Explose,
    Lightning_Strike,
    Rotate_Lightning_Ball,
    Static_Lightning_Ball,
    Lightning_Shield,
    Machine_Gun,
    Rotate_Saw_Blade,
    Static_Saw,
    Light_Gun_Drone,
    Rocket_Drone,
    Shotgun,
    Ground_Stamp,
    Magic_Burst,
    Immune_Shield,
    Moonlight_Gyro,
    Meteor,
    Holy_Light,
    Radiance,
    Toxic_Explose,
    Toxic_Swamp,
    Acid_Rain,
    Venom_Shot,
    Plague_Ward,
    Cloak,
    Pants,
    Gloves,
    Boots,
    Magic_Ring,
}

impl EEquipmentSkillImpl of Into<EEquipmentSkill, felt252> {
    fn into(self: EEquipmentSkill) -> felt252 {
        match self {
            EEquipmentSkill::Flame_Arrow => 'Flame_Arrow',
            EEquipmentSkill::Fire_Explose => 'Fire_Explose',
            EEquipmentSkill::Groundfire => 'Groundfire',
            EEquipmentSkill::Flame_Orb => 'Flame_Orb',
            EEquipmentSkill::Flame_Trail => 'Flame_Trail',
            EEquipmentSkill::Fire_Shield => 'Fire_Shield',
            EEquipmentSkill::Bouncing_Thunder => 'Bouncing_Thunder',
            EEquipmentSkill::Lightning_Explose => 'Lightning_Explose',
            EEquipmentSkill::Lightning_Strike => 'Lightning_Strike',
            EEquipmentSkill::Rotate_Lightning_Ball => 'Rotate_Lightning_Ball',
            EEquipmentSkill::Static_Lightning_Ball => 'Static_Lightning_Ball',
            EEquipmentSkill::Lightning_Shield => 'Lightning_Shield',
            EEquipmentSkill::Machine_Gun => 'Machine_Gun',
            EEquipmentSkill::Rotate_Saw_Blade => 'Rotate_Saw_Blade',
            EEquipmentSkill::Static_Saw => 'Static_Saw',
            EEquipmentSkill::Light_Gun_Drone => 'Light_Gun_Drone',
            EEquipmentSkill::Rocket_Drone => 'Rocket_Drone',
            EEquipmentSkill::Shotgun => 'Shotgun',
            EEquipmentSkill::Ground_Stamp => 'Ground_Stamp',
            EEquipmentSkill::Magic_Burst => 'Magic_Burst',
            EEquipmentSkill::Immune_Shield => 'Immune_Shield',
            EEquipmentSkill::Moonlight_Gyro => 'Moonlight_Gyro',
            EEquipmentSkill::Meteor => 'Meteor',
            EEquipmentSkill::Holy_Light => 'Holy_Light',
            EEquipmentSkill::Radiance => 'Radiance',
            EEquipmentSkill::Toxic_Explose => 'Toxic_Explose',
            EEquipmentSkill::Toxic_Swamp => 'Toxic_Swamp',
            EEquipmentSkill::Acid_Rain => 'Acid_Rain',
            EEquipmentSkill::Venom_Shot => 'Venom_Shot',
            EEquipmentSkill::Plague_Ward => 'Plague_Ward',
            EEquipmentSkill::Cloak => 'Cloak',
            EEquipmentSkill::Pants => 'Pants',
            EEquipmentSkill::Gloves => 'Gloves',
            EEquipmentSkill::Boots => 'Boots',
            EEquipmentSkill::Magic_Ring => 'Magic_Ring',
        }
    }
}
