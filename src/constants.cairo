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
}

pub const MAX_INDEX_OF_SKILL: u16 = 34;

pub const MAX_RECEIVE_SKILL: u16 = 3;

pub const STARKNET_DOMAIN_TYPE_HASH: felt252 =
    selector!("StarkNetDomain(name:felt,version:felt,chainId:felt)");

pub const RECEIVE_SKILL_TYPE_HASH: felt252 =
    selector!("ReceiveSkillParams(player:ContractAddress,salt_nonce:u64)");

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

