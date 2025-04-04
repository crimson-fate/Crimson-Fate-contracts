use starknet::ContractAddress;

#[derive(Drop, Serde, Debug)]
#[dojo::model]
pub struct PlayerProgress {
    #[key]
    pub player: ContractAddress,
    pub skills: Array<SelectedSkill>,
}

#[derive(Drop, Copy, Serde, Introspect, Debug)]
pub struct SelectedSkill {
    pub skill: felt252,
    pub is_evil: bool,
}

#[derive(Drop, Copy, Serde, Debug)]
#[dojo::model]
pub struct CurrentReceiveSkill {
    #[key]
    pub player: ContractAddress,
    pub skills: Span<SelectSkill>,
    pub is_evil: bool,
    pub is_selected: bool,
}

#[derive(Drop, Copy, Serde, Debug)]
#[dojo::model]
pub struct CurrentAngelOrEvil {
    #[key]
    pub player: ContractAddress,
    pub is_evil: bool,
    pub is_ignored: bool,
    pub is_accepted: bool,
}

#[derive(Drop, Copy, Serde, Introspect, Debug)]
pub struct SelectSkill {
    pub skill: felt252,
    pub index: u16,
}

#[derive(Drop, Copy, Serde, PartialEq, Introspect, Debug)]
pub enum CommonSkill {
    Fire_Explose,
    Groundfire,
    Flame_Trail,
    Fire_Shield,
    Bouncing_Thunder,
    Lightning_Explose,
    Static_Lightning_Ball,
    Lightning_Shield,
    Machine_Gun,
    Rotate_Saw_Blade,
    Static_Saw,
    Shotgun,
    Ground_Stamp,
    Immune_Shield,
    Moonlight_Gyro,
    Meteor,
    Radiance,
    Toxic_Swamp,
    Venom_Shot,
    Plague_Ward,
}

#[derive(Drop, Copy, Serde, PartialEq, Introspect, Debug)]
pub enum EvilSkill {
    Flame_Arrow,
    Flame_Orb,
    Lightning_Strike,
    Rotate_Lightning_Ball,
    Light_Gun_Drone,
    Rocket_Drone,
    Magic_Burst,
    Holy_Light,
    Toxic_Explose,
    Acid_Rain,
}

#[derive(Drop, Copy, Serde, PartialEq, Introspect, Debug)]
pub enum AngelOrEvil {
    Angel,
    Evil
}

impl CommonSkillImpl of Into<CommonSkill, felt252> {
    fn into(self: CommonSkill) -> felt252 {
        match self {
            CommonSkill::Fire_Explose => 'Fire_Explose',
            CommonSkill::Groundfire => 'Groundfire',
            CommonSkill::Flame_Trail => 'Flame_Trail',
            CommonSkill::Fire_Shield => 'Fire_Shield',
            CommonSkill::Bouncing_Thunder => 'Bouncing_Thunder',
            CommonSkill::Lightning_Explose => 'Lightning_Explose',
            CommonSkill::Static_Lightning_Ball => 'Static_Lightning_Ball',
            CommonSkill::Lightning_Shield => 'Lightning_Shield',
            CommonSkill::Machine_Gun => 'Machine_Gun',
            CommonSkill::Rotate_Saw_Blade => 'Rotate_Saw_Blade',
            CommonSkill::Static_Saw => 'Static_Saw',
            CommonSkill::Shotgun => 'Shotgun',
            CommonSkill::Ground_Stamp => 'Ground_Stamp',
            CommonSkill::Immune_Shield => 'Immune_Shield',
            CommonSkill::Moonlight_Gyro => 'Moonlight_Gyro',
            CommonSkill::Meteor => 'Meteor',
            CommonSkill::Radiance => 'Radiance',
            CommonSkill::Toxic_Swamp => 'Toxic_Swamp',
            CommonSkill::Venom_Shot => 'Venom_Shot',
            CommonSkill::Plague_Ward => 'Plague_Ward'
        }
    }
}

impl EvilSkillImpl of Into<EvilSkill, felt252> {
    fn into(self: EvilSkill) -> felt252 {
        match self {
            EvilSkill::Flame_Arrow => 'Flame_Arrow',
            EvilSkill::Flame_Orb => 'Flame_Orb',
            EvilSkill::Lightning_Strike => 'Lightning_Strike',
            EvilSkill::Rotate_Lightning_Ball => 'Rotate_Lightning_Ball',
            EvilSkill::Light_Gun_Drone => 'Light_Gun_Drone',
            EvilSkill::Rocket_Drone => 'Rocket_Drone',
            EvilSkill::Magic_Burst => 'Magic_Burst',
            EvilSkill::Holy_Light => 'Holy_Light',
            EvilSkill::Toxic_Explose => 'Toxic_Explose',
            EvilSkill::Acid_Rain => 'Acid_Rain',
        }
    }
}
