use dep::std::test::OracleMock;

struct Bytes32 {
    value: [u8; 32]
}

struct Uint256 {
    hi: Field,
    lo: Field
}

impl Uint256 {
    fn eq(self, other: Uint256) -> bool {
        ((self.hi == other.hi) as u8 & (self.lo == other.lo) as u8) != 0
    }
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

unconstrained fn fetch_account(address: Address, slots: Bytes32, blockHash: Bytes32) -> Account {
    let account = fetch_account_oracle();
    // TODO: Assert on account proof using https://github.com/aragonzkresearch/noir-trie-proofs"
    account
}

#[test]
unconstrained fn test_fetch_account() {
    let account: Account = Account {
        balance: Uint256 { hi: 0, lo: 0},
        codeHash: Bytes32 { value: [0; 32] },
        nonce: 0,
        storageHash: Bytes32 { value: [0; 32] },
        accountProof: [Bytes32 { value: [0; 32] }; 64]
    };

    OracleMock::mock("fetch_account").returns(account);

    let address = Address {value: 0 };
    let blockHash = Bytes32 { value: [0; 32] };
    let slot = Bytes32 { value: [0; 32] };
    
    let value = fetch_account(address, blockHash, slot);

    assert(value.balance.eq(Uint256 { hi: 0, lo: 0}));
}


// eth_getBalance,
// eth_getTransactionCount,
// eth_getStorageAt,
// eth_getCode
