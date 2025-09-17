#[starknet::interface]
pub trait IPrimeIdentity<TContractState> {
    fn commit_attribute(ref self: TContractState, key: felt252, commitment: felt252);
    fn get_attribute(self: @TContractState, key: felt252) -> felt252;
}

#[starknet::contract]
mod PrimeIdentity {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        owner: ContractAddress,
        attributes: LegacyMap<felt252, felt252>, // Key to commitment (hashed attribute)
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let caller = get_caller_address();
        self.owner.write(caller);
    }

    #[abi(embed_v0)]
    impl PrimeIdentityImpl of super::IPrimeIdentity<ContractState> {
        fn commit_attribute(ref self: ContractState, key: felt252, commitment: felt252) {
            // Basic access control: only owner can commit
            assert(self.owner.read() == get_caller_address(), 'Only owner');
            self.attributes.write(key, commitment);
        }

        fn get_attribute(self: @ContractState, key: felt252) -> felt252 {
            self.attributes.read(key)
        }
    }
}