use openzeppelin::access::ownable::OwnableComponent;
use starknet::get_caller_address;

#[starknet::interface]
pub trait IPrimeIdentity<TContractState> {
    fn commit_attribute(ref self: TContractState, key: felt252, commitment: felt252);
    fn get_attribute(self: @TContractState, key: felt252) -> felt252;
}

#[starknet::contract]
mod PrimeIdentity {
    use super::{IPrimeIdentity, OwnableComponent, get_caller_address};
    // Key fix: StoragePointer* traits for Map (like Solidity interface import—unlocks .entry chaining; PathEntry for key paths)
    use starknet::storage::{Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess};

    // Embed Ownable (compile-time mixin, like Solidity 'is Ownable'—ZK-optimized, no runtime overhead)
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    #[abi(embed_v0)]
    impl OwnableCamelOnlyImpl = OwnableComponent::OwnableCamelOnlyImpl<ContractState>;
    // Internal for privates (e.g., upgrades later; like Solidity _transferOwnership—public assert_only_owner needs no prefix)
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,  // Owner state (like private _owner)
        attributes: Map<felt252, felt252>,  // Modern Map for commitments (ZK-ready nesting, like Solidity mapping[addr][attr])
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,  // Events like OwnershipTransferred
    }

    // Constructor: Deploy-only init (like Solidity constructor—account-based Starknet avoids reentrancy)
    #[constructor]
    fn constructor(ref self: ContractState) {
        let caller = get_caller_address();  // msg.sender equiv (felt252 vs. Solidity address)
        self.ownable.initializer(caller);  // Sets owner once (like Ownable _transferOwnership(msg.sender))
    }

    #[abi(embed_v0)]
    impl PrimeIdentityImpl of IPrimeIdentity<ContractState> {
        fn commit_attribute(ref self: ContractState, key: felt252, commitment: felt252) {
            self.ownable.assert_only_owner();  // Reverts non-owner (like Solidity onlyOwner modifier—panic for ZK efficiency)
            // Entry chaining: Like Solidity mapping[key] = commitment (explicit path for safety/proof size)
            self.attributes.entry(key).write(commitment);  // Write hash (off-chain: pedersen(key, secret) for privacy)
        }

        fn get_attribute(self: @ContractState, key: felt252) -> felt252 {  // View: @self immutable (like Solidity view—no change)
            // Read via entry (defaults 0 if unset, like Solidity mapping[key] default—no Option/unwrap needed)
            self.attributes.entry(key).read()
        }
    }
}