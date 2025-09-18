//! PrimeIdentity tests - like Foundry's test/Prime.t.sol: Deploy, owner commit/read, revert non-owner
//! Run with `snforge test` (like `forge test`)

use snforge_std::{declare, invoke, ContractClassTrait, System};
use snforge_std::assert::assert_eq;  // Macro trait for eq! (like Foundry's assert lib—scoped for felt252 compares)
use super::PrimeIdentity::PrimeIdentityABITrait;  // ABI trait for typed calls (like Solidity IPrime for contract.func())

#[test]
#[available_gas(2000000)]  // Gas cap like Foundry's --gas-report (ZK equiv: Proof computation limit)
fn test_deploy_and_commit() {
    // Declare class (like vm.deployCode—compiles src/lib.cairo to Sierra class)
    let contract_class = declare("PrimeIdentity");
    let mut system = System::new();  // Test env like Foundry's vm (sims account abstraction, no real chain)
    let calldata = array![];  // No args (initializer handles owner, like proxy init vs. Solidity constructor)
    let (address, _) = system.deploy(@contract_class, @calldata, 0);  // Deploy (felt252 addr/salt like uint160/deployCode salt)

    let _owner = get_caller_address();  // Deployer as owner (like tx.origin; prefix _ for unused)
    let key: felt252 = 12345_u32.into();  // Attr key (off-chain hash, like bytes32)
    let commitment: felt252 = 67890_u32.into();  // Mock Pedersen hash

    // Invoke via ABI trait (like contract.commit(key, commitment)—typed selector + span calldata)
    let mut calldata = array![key, commitment];
    invoke(@address, PrimeIdentityABITrait::commit_attribute_selector(), &calldata);

    // Read back (view call, like contract.get(key)—returns span<felt252>)
    let mut calldata = array![key];
    let (retdata, _) = invoke(@address, PrimeIdentityABITrait::get_attribute_selector(), &calldata);
    assert_eq!(retdata[0], commitment, "Commit should match read");  // Eq! like Foundry assertEq (unpacks span[0])
}

#[test]
#[should_panic(expected: "Caller is not the owner")]  // Exact OZ revert string (like vm.expectRevert("Only owner")—no tuple)
#[available_gas(2000000)]
fn test_non_owner_revert() {
    let contract_class = declare("PrimeIdentity");
    let mut system = System::new();
    let calldata = array![];
    let (address, _) = system.deploy(@contract_class, @calldata, 0);

    let _non_owner = 99999_u32.into();  // Mock caller (snforge sims default deployer; full prank via system env if needed)

    let key: felt252 = 12345_u32.into();
    let commitment: felt252 = 67890_u32.into();
    let mut calldata = array![key, commitment];
    // Invoke triggers onlyOwner panic (like prank non-owner → revert; snforge catches)
    invoke(@address, PrimeIdentityABITrait::commit_attribute_selector(), &calldata);
}