use cartridge_vrf::{IVrfProviderDispatcher, IVrfProviderDispatcherTrait, Source};
use starknet::{ContractAddress, contract_address_const, get_caller_address, get_block_number};
use core::hash::{HashStateTrait, HashStateExTrait};
use core::pedersen::PedersenTrait;
use crimson_fate::models::skill::{AngelOrEvil, SelectedSkill};

fn get_vrf_address() -> ContractAddress {
    contract_address_const::<0x051fea4450da9d6aee758bdeba88b2f665bcbf549d2c61421aa724e9ac0ced8f>()
}

pub fn get_random_hash() -> felt252 {
    let vrf_provider = IVrfProviderDispatcher { contract_address: get_vrf_address() };
    vrf_provider.consume_random(Source::Nonce(get_caller_address()))
}

pub fn get_random_index_of_skill(random_number: felt252, seed: u16, max_index: u16) -> u16 {
    let block_number = get_block_number();
    let mut state = PedersenTrait::new(0);
    state = state.update_with(random_number);
    state = state.update_with(seed);
    state = state.update_with(block_number);
    let hash: u256 = state.finalize().into();

    let index = (hash % max_index.into());
    index.try_into().unwrap()
}

pub fn get_random_skill_from_selected_skills(
    selected_skills: Span<SelectedSkill>, random_number: felt252
) -> felt252 {
    let mut can_receive_skill = ArrayTrait::new();
    let mut i: u32 = 0;
    while i < selected_skills.len() {
        let skill = *selected_skills.at(i).skill;
        let mut count: u8 = 1;
        let mut j = i + 1;
        while j < selected_skills.len() {
            if *selected_skills.at(j).skill == skill {
                count += 1;
            }
            j += 1;
        };

        if count <= 2 {
            can_receive_skill.append(skill);
        }
        i += 1;
    };

    let block_number = get_block_number();
    let mut state = PedersenTrait::new(0);
    state = state.update_with(random_number);
    state = state.update_with(can_receive_skill.len());
    state = state.update_with(block_number);
    let hash: u256 = state.finalize().into();
    let index = (hash % can_receive_skill.len().into());
    *can_receive_skill.at(index.try_into().unwrap())
}

pub fn check_skill_is_selected(selected_skills: Span<SelectedSkill>, skill: felt252) -> bool {
    let mut i: u32 = 0;
    let mut result = false;
    while i < selected_skills.len() {
        if *selected_skills.at(i).skill == skill {
            result = true;
            break;
        }
        i += 1;
    };
    result
}

pub fn get_random_angel_or_evil(random_number: felt252, player: ContractAddress) -> AngelOrEvil {
    let block_number = get_block_number();
    let mut state = PedersenTrait::new(0);
    state = state.update_with(random_number);
    state = state.update_with(player);
    state = state.update_with(block_number);
    let hash: u256 = state.finalize().into();
    let index = (hash % 2);
    if index == 0 {
        AngelOrEvil::Angel
    } else {
        AngelOrEvil::Evil
    }
}

