contract;

use std::{
    bytes::Bytes,
    vec::Vec,
};
use redstone::process_input;

abi RedStoneCore {
    fn get_prices(feed_ids: Vec<u256>, payload: Bytes) -> (Vec<u256>, u64);
}

impl RedStoneCore for Contract {
    fn get_prices(feed_ids: Vec<u256>, payload_bytes: Bytes) -> (Vec<u256>, u64) {
        process_input(payload_bytes)
    }
}
