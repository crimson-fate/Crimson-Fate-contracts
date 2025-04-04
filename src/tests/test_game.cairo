#[cfg(test)]
mod tests {
    use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
    use dojo::world::WorldStorageTrait;
    use dojo_cairo_test::WorldStorageTestTrait;
    use dojo_cairo_test::{
        spawn_test_world, NamespaceDef, TestResource, ContractDefTrait, ContractDef
    };

    use crimson_fate::systems::game::{GameSystem};

    use crimson_fate::models::skill::{CurrentReceiveSkill, m_CurrentReceiveSkill, SelectedSkill};
    use crimson_fate::models::signature::{UsedSignature, m_UsedSignature, Prover, m_Prover};
    use crimson_fate::utils::random::get_random_skill_from_selected_skills;

    fn namespace_def() -> NamespaceDef {
        NamespaceDef {
            namespace: "cf", resources: [
                TestResource::Model(m_CurrentReceiveSkill::TEST_CLASS_HASH),
                TestResource::Model(m_UsedSignature::TEST_CLASS_HASH),
                TestResource::Model(m_Prover::TEST_CLASS_HASH),
                TestResource::Event(GameSystem::e_ReceiveSkill::TEST_CLASS_HASH),
                TestResource::Contract(GameSystem::TEST_CLASS_HASH)
            ].span()
        }
    }

    fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"cf", @"GameSystem")
                .with_writer_of([dojo::utils::bytearray_hash(@"cf")].span())
        ].span()
    }

    // #[test]
    fn test_world_test_set() {
        // Initialize test environment
        let caller = starknet::contract_address_const::<'caller'>();
        let ndef = namespace_def();

        // Register the resources.
        let mut world = spawn_test_world([ndef].span());

        // Ensures permissions and initializations are synced.
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"GameSystem").unwrap();

        // Test initial position
        let mut prover: Prover = world.read_model(contract_address);
        assert(prover.address != caller, 'initial game wrong');

        // Test write_model_test
        prover.address = caller;

        world.write_model_test(@prover);

        let mut prover: Prover = world.read_model(contract_address);
        assert(prover.address == caller, 'write_value_from_id failed');

        // Test model deletion
        world.erase_model(@prover);
        let prover: Prover = world.read_model(contract_address);
        assert(prover.address != caller, 'erase_model failed');
    }

    #[test]
    fn test_get_random_skill_from_selected_skills() {
        let selected_skills = array![
            SelectedSkill { skill: '0x41123', is_evil: false },
            SelectedSkill { skill: '0x41123', is_evil: false },
            SelectedSkill { skill: '0x41123', is_evil: false }
        ];
        let new_skill = get_random_skill_from_selected_skills(selected_skills.span(), '0x123');
        println!("{}", new_skill);
    }
}
