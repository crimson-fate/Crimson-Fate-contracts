use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct ValorProgressCounter {
    #[key]
    pub player: ContractAddress,
    pub counter: u128,
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct ValorProgress {
    #[key]
    pub player: ContractAddress,
    #[key]
    pub id: u128,
    pub start_timestamp: u64,
    pub is_claimed: bool,
    pub duration: u64,
}
