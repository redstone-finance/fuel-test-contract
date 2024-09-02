
IS_LOCAL=0

SALT=--salt 0x0000000000000000000000000000000000000000000000000000000000000006
#SALT=--default-salt

ifeq ($(IS_LOCAL), 0)
#	SIGNING_KEY= # forc-wallet account 0
	NODE_URL=--node-url https://testnet.fuel.network/v1/graphql
#	GAS_PRICE=1
else
	SIGNING_KEY=--default-signer
	NODE_URL=--target local
	GAS_PRICE=0
endif

DEMO=demo
CONTRACT=test_contract
INITIALIZER=contract_initializer
CONTRACT_ID_FILE=./$(CONTRACT)/CONTRACT_ID
CONTRACT_ID=$(shell cat $(CONTRACT_ID_FILE))

DIRS =$(CONTRACT) $(INITIALIZER)

define run_in_dirs
    for dir in $(1); do \
        ($(2) --path $$dir) || exit 1; \
    done
endef

.PHONY: contract_id get_contract_id format

format:
	# $(call run_in_dirs,$(DIRS),forc fmt)

lint:
	$(call run_in_dirs,$(DIRS),forc fmt --check)

build: format
	$(call run_in_dirs,$(DIRS),forc build)

contract: format
	forc build --path $(CONTRACT) --release

# make SIGNING_KEY=5b4 invoke
perform_deploy: format
	forc deploy --path $(CONTRACT) --terse \
	$(SALT) \
	$(NODE_URL) \
	$(SIGNING_KEY)

get_contract_id:
	forc contract-id --path $(CONTRACT) --terse --release $(SALT) | grep "Contract id:" | cut -c 20- > $(CONTRACT_ID_FILE) 

contract_id: get_contract_id
	@cat $(INITIALIZER)/src/main.sw | sed -E "s|CONTRACT_ID: b256 = 0x([0-9a-f])*,|CONTRACT_ID: b256 = $(shell cat $(CONTRACT_ID_FILE)),|g" > tmp.sw;
	@mv tmp.sw $(INITIALIZER)/src/main.sw

deploy: perform_deploy contract_id

init: format
	@forc --version
	forc run --path $(INITIALIZER) --release -r \
	$(NODE_URL) \
	--contract $(CONTRACT_ID) \
	--gas-price 1 \
	--max-fee 1000000000 \
	$(SIGNING_KEY)


deploy_and_init: deploy init

