contract;

mod prices_abi;

use std::{
    alloc::alloc_bytes,
    auth::msg_sender,
    bytes::Bytes,
    constants::ZERO_U256,
    hash::*,
    inputs::input_count,
    logging::log,
    storage::{
        storage_api::{
            read,
            write,
        },
        storage_vec::*,
    },
    vec::Vec,
};
use prices_abi::Prices;

storage {
    owner: Option<Identity> = Option::None,
    signer_count_threshold: u64 = 1,
    signers: StorageVec<b256> = StorageVec {},
    prices: StorageMap<u256, u256> = StorageMap {},
    timestamp: u64 = 0,
}

impl Prices for Contract {
    #[storage(read, write)]
    fn init(signers: Vec<b256>, signer_count_threshold: u64) {
        let storage_owner = storage.owner.read();
        assert(storage_owner.is_none() || (storage_owner.unwrap() == msg_sender().unwrap()));
        storage.owner.write(Option::Some(msg_sender().unwrap()));
        storage.signer_count_threshold.write(signer_count_threshold);
        let mut i = 0;
        while (i < signers.len()) {
            storage.signers.push(signers.get(i).unwrap());
            i += 1;
        }
    }

    #[storage(read)]
    fn get_prices(feed_ids: Vec<u256>, payload: Bytes) -> Vec<u256> {
        let (prices, _) = get_prices(feed_ids, payload);

        prices
    }

    #[storage(read)]
    fn read_timestamp() -> u64 {
        storage.timestamp.read()
    }

    #[storage(read)]
    fn read_prices(feed_ids: Vec<u256>) -> Vec<u256> {
        let mut result = Vec::new();
        let mut i = 0;
        while (i < feed_ids.len()) {
            let feed_id = feed_ids.get(i).unwrap();
            let price = storage.prices.get(feed_id).try_read().unwrap_or(ZERO_U256);
            result.push(price);
            i += 1;
        }

        result
    }

    #[storage(read, write)]
    fn write_prices(feed_ids: Vec<u256>, payload: Bytes) -> Vec<u256> {
        let (aggregated_values, block_timestamp) = get_prices(feed_ids, payload);
        let mut i = 0;
        while (i < feed_ids.len()) {
            let feed_id = feed_ids.get(i).unwrap();
            let price = aggregated_values.get(i).unwrap();
            storage.prices.insert(feed_id, price);
            i += 1;
        }
        storage.timestamp.write(block_timestamp);

        aggregated_values
    }
}

#[storage(read)]
fn get_prices(feed_ids: Vec<u256>, payload_bytes: Bytes) -> (Vec<u256>, u64) {
    let mut signers: Vec<b256> = Vec::new();
    let mut i = 0;
    while (i < storage.signers.len()) {
        signers.push(storage.signers.get(i).unwrap().read());
        i += 1;
    }
    (Vec::new(), 0u64)
}
