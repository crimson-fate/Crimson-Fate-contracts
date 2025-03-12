use core::pedersen::PedersenTrait;
use core::hash::{HashStateTrait, HashStateExTrait};
use starknet::ContractAddress;
use crimson_fate::constants::{
    StarknetDomain, STARKNET_DOMAIN_TYPE_HASH, ReceiveSkillParams, RECEIVE_SKILL_TYPE_HASH,
    DEFAULT_DOMAIN
};


pub fn hash_domain(domain: @StarknetDomain) -> felt252 {
    let mut state = PedersenTrait::new(0);
    state = state.update_with(STARKNET_DOMAIN_TYPE_HASH);
    state = state.update_with(*domain);
    state = state.update_with(4);
    state.finalize()
}

pub fn hash_receive_skill(receive_skill: @ReceiveSkillParams) -> felt252 {
    let mut state = PedersenTrait::new(0);
    state = state.update_with(RECEIVE_SKILL_TYPE_HASH);
    state = state.update_with(*receive_skill);
    state = state.update_with(3);
    state.finalize()
}

pub fn compute_message_receive_skill_hash(
    data: @ReceiveSkillParams, prover: ContractAddress
) -> felt252 {
    let domain = DEFAULT_DOMAIN();
    let mut state = PedersenTrait::new(0);
    state = state.update_with('StarkNet Message');
    state = state.update_with(hash_domain(@domain));
    state = state.update_with(prover);
    state = state.update_with(hash_receive_skill(data));
    state = state.update_with(4);
    state.finalize()
}
