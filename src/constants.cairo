use starknet::{get_tx_info, ContractAddress};

#[derive(Drop, Copy, Hash)]
pub struct StarknetDomain {
    pub name: felt252,
    pub version: felt252,
    pub chain_id: felt252
}

#[derive(Drop, Copy, Hash)]
pub struct ReceiveSkillParams {
    pub player: ContractAddress,
    pub salt_nonce: u64,
    pub is_new_game: bool,
    pub is_evil: bool,
}

pub const MAX_INDEX_OF_COMMON_SKILL: u16 = 20;

pub const MAX_INDEX_OF_EVIL_SKILL: u16 = 10;

pub const MAX_RECEIVE_SKILL: u16 = 3;

pub const STARKNET_DOMAIN_TYPE_HASH: felt252 =
    selector!("StarkNetDomain(name:felt,version:felt,chainId:felt)");

pub const RECEIVE_SKILL_TYPE_HASH: felt252 =
    selector!("ReceiveSkillParams(player:felt,salt_nonce:felt,is_new_game:bool,is_evil:bool)");

pub const STARKNET_DOMAIN_VERSION: felt252 = 1;

pub fn DEFAULT_DOMAIN() -> StarknetDomain {
    StarknetDomain {
        name: 'crimson-fate',
        version: STARKNET_DOMAIN_VERSION,
        chain_id: get_tx_info().unbox().chain_id
    }
}

pub fn DEFAULT_NS() -> ByteArray {
    "cf"
}

