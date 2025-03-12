use cartridge_vrf::{IVrfProviderDispatcher, IVrfProviderDispatcherTrait, Source};
use starknet::{ContractAddress, contract_address_const, get_caller_address, get_block_number};
use crimson_fate::constants::{MAX_INDEX_OF_SKILL};
use core::hash::{HashStateTrait, HashStateExTrait};
use core::pedersen::PedersenTrait;

fn get_vrf_address() -> ContractAddress {
    contract_address_const::<0x051fea4450da9d6aee758bdeba88b2f665bcbf549d2c61421aa724e9ac0ced8f>()
}

pub fn get_random_hash() -> felt252 {
    let vrf_provider = IVrfProviderDispatcher { contract_address: get_vrf_address() };
    vrf_provider.consume_random(Source::Nonce(get_caller_address()))
}

pub fn get_random_index_of_skill(random_number: felt252, seed: u16) -> u16 {
    let block_number = get_block_number();
    let mut state = PedersenTrait::new(0);
    state = state.update_with(random_number);
    state = state.update_with(seed);
    state = state.update_with(block_number);
    let hash: u256 = state.finalize().into();

    let index = (hash % MAX_INDEX_OF_SKILL.into()) + 1;
    index.try_into().unwrap()
}
