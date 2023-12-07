use crate::types::WithProof;

struct Header {
    parent_hash: [u8; 32],
    uncle_hash: [u8; 32],
    beneficiary: [u8; 20],
    state_root: [u8; 32],
    transactions_root: [u8; 32],
    receipts_root: [u8; 32],
    logs_bloom: [u8; 32],
    difficulty: [u8; 32],
    number: [u8; 32],
    gas_limit: [u8; 32],
    gas_used: [u8; 32],
    timestamp: u64,
    extra_data: [u8; 32],
    mix_hash: [u8; 32],
    nonce: [u8; 32],
}

#[oracle(fetch_header)]
unconstrained fn fetch_header_oracle(blockHash: [u8; 32]) -> WithProof<Header> {}

unconstrained fn fetch_header(blockHash: [u8; 32]) -> Header {
    let header_with_proof = fetch_header_oracle(blockHash);
    // TODO: Assert on header proof using https://github.com/aragonzkresearch/noir-trie-proofs"
    header_with_proof.value
}