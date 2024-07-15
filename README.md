# fuel-test-contract

1. Change the `IS_LOCAL` value in the [Makefile](Makefile) to `1` for local node or for `0` for an external node.
1. Change the `SALT` value in the [Makefile](Makefile) if needed
1. Define the `SIGNING_KEY` env variable
1. Run 
```shell
make deploy
``` 
and then 
```shell
`make init`
```
or
```shell
make deploy_and_init
```

Change or remove [fuel-toolchain.toml](fuel-toolchain.toml)

## The result for an external node is:

```
error: provider: io error: warning: the fuel node version to which this provider is connected has a semver incompatible version from the one the SDK was developed against. Connected node version: 0.31.0, supported version: 0.28.0. Response errors; InsufficientMaxFee { max_fee_from_policies: 0, max_fee_from_gas_price: 326087 }
```
