use starknet::ContractAddress;

#[starknet::interface]
trait IGameSystem<TState> {
    fn initialize(ref self: TState, prover_address: ContractAddress);
    fn receive_skill(ref self: TState, salt_nonce: u64, key: Array<felt252>);
    fn update_prover(ref self: TState, prover: ContractAddress);
}

#[starknet::interface]
trait AccountABI<TState> {
    fn is_valid_signature(self: @TState, hash: felt252, signature: Array<felt252>) -> felt252;

    // ISRC6CamelOnly
    fn isValidSignature(self: @TState, hash: felt252, signature: Array<felt252>) -> felt252;
}

#[dojo::contract]
mod GameSystem {
    use core::num::traits::Zero;
    use starknet::{get_caller_address, get_contract_address};
    use crimson_fate::utils::signature::{compute_message_receive_skill_hash};
    use crimson_fate::utils::random::{get_random_hash, get_random_index_of_skill};
    use crimson_fate::utils::equipmentskill::select_equipment_skill;
    use crimson_fate::models::signature::{UsedSignature, Prover};
    use crimson_fate::models::equipmentskill::{CurrentReceiveSkill, SelectSkill};
    use crimson_fate::constants::{ReceiveSkillParams, DEFAULT_NS, MAX_RECEIVE_SKILL};
    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;
    use dojo::world::{IWorldDispatcherTrait, WorldStorageTrait};
    use super::{AccountABIDispatcher, AccountABIDispatcherTrait, IGameSystem, ContractAddress};

    #[derive(Drop, Serde)]
    #[dojo::event]
    struct ReceiveSkill {
        #[key]
        player: ContractAddress,
        skills: Span<SelectSkill>,
    }

    #[abi(embed_v0)]
    impl GameSystem of IGameSystem<ContractState> {
        fn initialize(ref self: ContractState, prover_address: ContractAddress) {
            let mut world = self.world(@DEFAULT_NS());

            let caller = get_caller_address();
            let selector = world.resource_selector(@"Prover");
            assert(world.dispatcher.is_owner(selector, caller), 'only owner of model');
            let mut prover: Prover = world.read_model(get_contract_address());

            assert(prover.address.is_zero(), 'prover already initialized');
            prover.address = prover_address;
            world.write_model(@prover);
        }

        fn receive_skill(ref self: ContractState, salt_nonce: u64, key: Array<felt252>) {
            let mut world = self.world(@DEFAULT_NS());

            let player = get_caller_address();
            let prover: Prover = world.read_model(get_contract_address());

            let receive_skill = ReceiveSkillParams { player: player, salt_nonce: salt_nonce };
            let msg_hash = compute_message_receive_skill_hash(@receive_skill, prover.address);

            let mut used_signature: UsedSignature = world.read_model(msg_hash);
            assert(!used_signature.is_used, 'signature already used');

            let account: AccountABIDispatcher = AccountABIDispatcher {
                contract_address: prover.address
            };

            // assert(account.is_valid_signature(msg_hash, key) == 'VALID', 'Invalid signature');
            used_signature.is_used = true;
            world.write_model(@used_signature);

            let random: felt252 = get_random_hash().into();
            let random_u256: u256 = random.into();
            let selected_range: u8 = (random_u256 % MAX_RECEIVE_SKILL.into() + 1)
                .try_into()
                .unwrap();

            let mut seed = 0;
            let mut selected_count = 0;
            let mut newSkill = ArrayTrait::<SelectSkill>::new();

            let result = loop {
                if selected_count == selected_range {
                    break newSkill.clone();
                }

                let skill_index = get_random_index_of_skill(random, seed);
                let skill = select_equipment_skill(skill_index);
                newSkill.append(SelectSkill { skill: skill, is_selected: false });

                seed += 1;
                selected_count += 1;
            };

            let selected_skills = CurrentReceiveSkill { player, skills: result.span() };

            world.write_model(@selected_skills);
            world.emit_event(@ReceiveSkill { player, skills: result.span() });
        }

        fn update_prover(ref self: ContractState, prover: ContractAddress) {
            let mut world = self.world(@DEFAULT_NS());

            let caller = get_caller_address();
            let selector = world.resource_selector(@"Prover");
            assert(world.dispatcher.is_owner(selector, caller), 'only owner of model');
            let prover = Prover { system: get_contract_address(), address: prover };
            world.write_model(@prover);
        }
    }
}
