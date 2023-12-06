use dep::std::test::OracleMock;

struct Bytes32 {
    value: [u8; 32]
}

struct Uint256 {
    hi: Field,
    lo: Field
}

struct Address {
    value: Field
}

struct Account {
    balance: Uint256,
    codeHash: Bytes32,
    nonce: Field,
    storageHash: Bytes32,
    accountProof: [Bytes32; 64]
    // storageProof: ARRAY - Array of storage-entries as requested. Each entry is a object with these properties:
        // key: QUANTITY - the requested storage key
        // value: QUANTITY - the storage value
        // proof: ARRAY - Array of rlp-serialized MerkleTree-Nodes, starting with the storageHash-Node, following the path of the SHA3 (key) as path.
}

#[oracle(fetch_account)]
unconstrained fn fetch_account_oracle() -> Account {}


fn fetch_account(address: Address, slots: Bytes32, blockHash: Bytes32) -> Account {
    let account = fetch_account_oracle();
    //TODO: Assert on account proof
    account
}


fn main(x: Field, y: pub Field) {
    assert(x != y);
}

#[test]
fn test_main() {
    OracleMock::mock("fetch_account").returns(Account {
        balance: Uint256 {0, 0},
        codeHash: Bytes32 {0},
        nonce: 0,
        storageHash: Bytes32 {0},
        accountProof: [Bytes32 {0}; 64]
    });

    // let address = {0};
    // let blockHash = {0};
    // let slot = {0};
    // let value = fetch_account(address, blockHash, slot);

    // assert(value.balance == {0, 0});
}


// eth_getBalance,
// eth_getTransactionCount,
// eth_getStorageAt,
// eth_getCode
