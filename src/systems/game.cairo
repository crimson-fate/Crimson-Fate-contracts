use starknet::ContractAddress;

#[starknet::interface]
pub trait IGameSystem<TState> {
    fn initialize(ref self: TState, prover_address: ContractAddress);
    fn start_new_game(ref self: TState, salt_nonce: u64, key: Array<felt252>);
    fn receive_skill(ref self: TState, salt_nonce: u64, key: Array<felt252>);
    fn select_common_skill(ref self: TState, skill_index: u16);
    fn receive_angel_or_evil(ref self: TState, salt_nonce: u64, key: Array<felt252>);
    // fn select_or_ignore_evil_skill(ref self: TState, skill_index: u16);
    fn update_prover(ref self: TState, prover: ContractAddress);
}

#[starknet::interface]
pub trait AccountABI<TState> {
    fn is_valid_signature(self: @TState, hash: felt252, signature: Array<felt252>) -> felt252;

    // ISRC6CamelOnly
    fn isValidSignature(self: @TState, hash: felt252, signature: Array<felt252>) -> felt252;
}

#[dojo::contract]
pub mod GameSystem {
    use core::num::traits::Zero;
    use starknet::{get_caller_address, get_contract_address};
    use crimson_fate::utils::signature::{
        compute_message_receive_skill_hash, compute_message_receive_angel_or_evil_hash
    };
    use crimson_fate::utils::random::{
        get_random_hash, get_random_index_of_skill, get_random_skill_from_selected_skills,
        get_random_angel_or_evil, check_skill_is_selected
    };
    use crimson_fate::utils::skill::{index_to_common_skill, common_skill_to_index};
    use crimson_fate::models::signature::{UsedSignature, Prover};
    use crimson_fate::models::skill::{
        PlayerProgress, CurrentReceiveSkill, SelectSkill, CurrentAngelOrEvil, AngelOrEvil,
        SelectedSkill
    };
    use crimson_fate::constants::{
        ReceiveSkillParams, DEFAULT_NS, MAX_INDEX_OF_COMMON_SKILL, MAX_INDEX_OF_EVIL_SKILL,
        ReceiveAngelOrEvilParams
    };
    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;
    use dojo::world::{IWorldDispatcherTrait, WorldStorageTrait};
    use super::{AccountABIDispatcher, AccountABIDispatcherTrait, IGameSystem, ContractAddress};

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct ReceiveSkill {
        #[key]
        pub player: ContractAddress,
        pub skills: Span<SelectSkill>,
        pub is_evil: bool,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct ChooseSkill {
        #[key]
        pub player: ContractAddress,
        pub skill: felt252,
        pub index: u16,
        pub is_evil: bool,
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

        fn start_new_game(ref self: ContractState, salt_nonce: u64, key: Array<felt252>) {
            let mut world = self.world(@DEFAULT_NS());

            let player = get_caller_address();
            let prover: Prover = world.read_model(get_contract_address());
            let receive_skill = ReceiveSkillParams {
                player, salt_nonce: salt_nonce, is_new_game: true, is_evil: false
            };
            let msg_hash = compute_message_receive_skill_hash(@receive_skill, prover.address);

            let mut used_signature: UsedSignature = world.read_model(msg_hash);
            assert(!used_signature.is_used, 'signature already used');

            let account: AccountABIDispatcher = AccountABIDispatcher {
                contract_address: prover.address,
            };

            assert(account.is_valid_signature(msg_hash, key) == 'VALID', 'Invalid signature');
            used_signature.is_used = true;
            world.write_model(@used_signature);

            let mut player_progress: PlayerProgress = world.read_model(player);
            player_progress.skills = ArrayTrait::new();
            world.write_model(@player_progress);

            let random: felt252 = '0x14123'; //get_random_hash().into();
            let selected_range: u8 = 2;
            let mut seed = 0;
            let mut selected_count = 0;
            let mut newSkill = ArrayTrait::<SelectSkill>::new();

            let result = loop {
                if selected_count == selected_range {
                    break newSkill.clone();
                }

                let skill_index = get_random_index_of_skill(
                    random, seed, MAX_INDEX_OF_COMMON_SKILL
                );
                let skill = index_to_common_skill(skill_index);
                newSkill.append(SelectSkill { skill: skill, index: skill_index });

                seed += 1;
                selected_count += 1;
            };

            let selected_skills = CurrentReceiveSkill {
                player, skills: result.span(), is_evil: false, is_selected: false
            };

            world.write_model(@selected_skills);
            world.emit_event(@ReceiveSkill { player, skills: result.span(), is_evil: false });
        }

        fn receive_skill(ref self: ContractState, salt_nonce: u64, key: Array<felt252>) {
            let mut world = self.world(@DEFAULT_NS());

            let player = get_caller_address();
            let prover: Prover = world.read_model(get_contract_address());

            let receive_skill = ReceiveSkillParams {
                player: player, salt_nonce: salt_nonce, is_new_game: false, is_evil: false
            };
            let msg_hash = compute_message_receive_skill_hash(@receive_skill, prover.address);

            let mut used_signature: UsedSignature = world.read_model(msg_hash);
            assert(!used_signature.is_used, 'signature already used');

            let account: AccountABIDispatcher = AccountABIDispatcher {
                contract_address: prover.address,
            };

            assert(account.is_valid_signature(msg_hash, key) == 'VALID', 'Invalid signature');
            used_signature.is_used = true;
            world.write_model(@used_signature);

            let random: felt252 = '0xabc123'; //get_random_hash().into();

            let player_progress: PlayerProgress = world.read_model(player);
            let selected_skills = player_progress.skills;
            let mut newSkill = ArrayTrait::<SelectSkill>::new();
            let skill = get_random_skill_from_selected_skills(selected_skills.span(), random);
            newSkill.append(SelectSkill { skill: skill, index: common_skill_to_index(skill) });

            let selected_skills = CurrentReceiveSkill {
                player, skills: newSkill.span(), is_evil: false, is_selected: false
            };

            world.write_model(@selected_skills);
            world.emit_event(@ReceiveSkill { player, skills: newSkill.span(), is_evil: false });
        }

        fn select_common_skill(ref self: ContractState, skill_index: u16) {
            let mut world = self.world(@DEFAULT_NS());
            let player = get_caller_address();

            let mut current_receive_skill: CurrentReceiveSkill = world.read_model(player);
            assert(!current_receive_skill.is_evil, 'skill belong to evil');
            assert(!current_receive_skill.is_selected, 'skill already selected');

            let mut is_wrong_skill = true;
            for skill in current_receive_skill
                .skills {
                    if *skill.index == skill_index {
                        is_wrong_skill = false;
                        current_receive_skill.is_selected = true;
                        world.write_model(@current_receive_skill);

                        let mut player_progress: PlayerProgress = world.read_model(player);
                        player_progress
                            .skills
                            .append(SelectedSkill { skill: *skill.skill, is_evil: false });
                        world.write_model(@player_progress);
                        world
                            .emit_event(
                                @ChooseSkill {
                                    player,
                                    skill: *skill.skill,
                                    index: skill_index,
                                    is_evil: current_receive_skill.is_evil
                                }
                            );
                        break;
                    }
                };

            assert(!is_wrong_skill, 'select wrong skill');
        }

        fn receive_angel_or_evil(ref self: ContractState, salt_nonce: u64, key: Array<felt252>) {
            let mut world = self.world(@DEFAULT_NS());

            let player = get_caller_address();
            let prover: Prover = world.read_model(get_contract_address());

            let receive_angel_or_evil = ReceiveAngelOrEvilParams {
                player: player, salt_nonce: salt_nonce
            };

            let msg_hash = compute_message_receive_angel_or_evil_hash(
                @receive_angel_or_evil, prover.address
            );

            let mut used_signature: UsedSignature = world.read_model(msg_hash);
            assert(!used_signature.is_used, 'signature already used');

            let account: AccountABIDispatcher = AccountABIDispatcher {
                contract_address: prover.address,
            };

            assert(account.is_valid_signature(msg_hash, key) == 'VALID', 'Invalid signature');
            used_signature.is_used = true;
            world.write_model(@used_signature);

            let random: felt252 = '0x13775738'; //get_random_hash().into();
            let result = get_random_angel_or_evil(random, player);

            let mut is_evil = false;
            let selected_range: u8 = 2;
            let mut seed = 0;
            let mut selected_count = 0;
            let mut newSkill = ArrayTrait::<SelectSkill>::new();
            let player_progress: PlayerProgress = world.read_model(player);
            match result {
                AngelOrEvil::Angel => {
                    while selected_count < selected_range {
                        let skill_index = get_random_index_of_skill(
                            random, seed, MAX_INDEX_OF_COMMON_SKILL
                        );
                        let skill = index_to_common_skill(skill_index);
                        if (!check_skill_is_selected(player_progress.skills.span(), skill)) {
                            newSkill.append(SelectSkill { skill: skill, index: skill_index });
                            selected_count += 1;
                        }

                        seed += 1;
                    };

                    world
                        .write_model(
                            @CurrentReceiveSkill {
                                player, skills: newSkill.span(), is_evil: false, is_selected: false
                            }
                        );
                },
                AngelOrEvil::Evil => { is_evil = true; }
            };

            world.write_model(@CurrentAngelOrEvil { player, is_evil, is_ignored: false });
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
