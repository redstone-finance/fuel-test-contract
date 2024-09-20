library;

use std::{bytes::Bytes};

pub trait FromBytesConvertible {
    fn size() -> u64;
    fn _from_be_bytes(bytes: Bytes) -> Self;
}

pub trait FromBytes {
    fn from_bytes(bytes: Bytes) -> Self;
}

impl<T> FromBytes for T
where
    T: FromBytesConvertible,
{
    fn from_bytes(bytes: Bytes) -> Self {
        assert(bytes.len() <= Self::size());

        let mut bytes = bytes;

        while (bytes.len() < Self::size()) {
            bytes.insert(0, 0u8);
        }

        Self::_from_be_bytes(bytes)
    }
}


pub struct DataPoint {}
pub struct DataPackage {}
pub struct Payload {}

pub fn make_data_package(bytes: Bytes) -> (DataPackage, u64) {
    let mut data_points = Vec::new();
    data_points.push(DataPoint::from_bytes(bytes));

    return (DataPackage {}, 0);
}

impl FromBytes for DataPoint {
    fn from_bytes(bytes: Bytes) -> Self {
        Self {
        }
    }
}

impl Payload {
    pub fn from_bytes(bytes: Bytes) -> Self {
        let mut data_packages = Vec::new();
        let (data_package, _) = make_data_package(bytes);
        data_packages.push(data_package);

        Self {}
    }
}

pub fn process_input(bytes: Bytes) -> (Vec<u256>, u64) {
    let payload = Payload::from_bytes(bytes);

    (Vec::new(), 0)
}
