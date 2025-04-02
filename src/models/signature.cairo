use starknet::ContractAddress;

#[derive(Drop, Serde, Debug)]
#[dojo::model]
pub struct UsedSignature {
    #[key]
    pub msg_hash: felt252,
    pub is_used: bool,
}

#[derive(Drop, Serde, Debug)]
#[dojo::model]
pub struct Prover {
    #[key]
    pub system: ContractAddress,
    pub address: ContractAddress,
}
