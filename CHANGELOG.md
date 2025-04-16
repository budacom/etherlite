# Changelog

## [0.8.0](https://github.com/budacom/etherlite/compare/v0.7.0...v0.8.0) (2025-04-16)


### Features

* **Account:** adds support for block parameter to call ([88fe3c0](https://github.com/budacom/etherlite/commit/88fe3c0b54c5415fb9432037ad62c42bb4f299d4))
* add block hash to events ([921d0e8](https://github.com/budacom/etherlite/commit/921d0e8db5ad87eb20f393b90449f4093b1246cf))
* add block hash to events ([63820ac](https://github.com/budacom/etherlite/commit/63820ac0e7ecf44f28b0b3587ba1422b21c846ed))
* add block_hash property to Transaction ([38fcf5b](https://github.com/budacom/etherlite/commit/38fcf5b94cbd5c62e79db6686ea30c05a8a96a86))
* add build_raw_transaction method to Account::PrivateKey ([08b459a](https://github.com/budacom/etherlite/commit/08b459ad15911c141537a89880010c4c0f5c0c32))
* add next_nonce methods to accounts ([16235d6](https://github.com/budacom/etherlite/commit/16235d61b1b834542b977476add4e2e30659dfa4))
* add nonce parameter to PrivateKey.send_transaction ([0815ccb](https://github.com/budacom/etherlite/commit/0815ccb4dc850fe41db21eccd26e645a46fd855d))
* add support for 'stateMutability' on JSON abi definition ([e491a07](https://github.com/budacom/etherlite/commit/e491a0797876e63b3f8f139be24c763aa50bd073))
* **Api::Node:** adds account_from_pk method ([ff48d52](https://github.com/budacom/etherlite/commit/ff48d52942de8afc3800e4c8423e3a459b7f8d6a))
* **api/node:** adds load_transaction, load_account and load_address methods ([e1e2534](https://github.com/budacom/etherlite/commit/e1e2534233795aa65ac72ab5e4dc913bf00a379d))
* **Configuration:** adds option to disable NonceManager's cache ([2bc532d](https://github.com/budacom/etherlite/commit/2bc532d8e7894e2a61551163151cae1cc4083671))
* **Connection:** adds 'error' response support and specs ([a58bf09](https://github.com/budacom/etherlite/commit/a58bf090f5b9fd4b2f6446c01625f00eb317e258))
* **Connection:** adds chain ID configuration ([3009fa9](https://github.com/budacom/etherlite/commit/3009fa978fe38209008ae4c7e87aa93ed456f8ac))
* **Connection:** adds https support ([82cfc4c](https://github.com/budacom/etherlite/commit/82cfc4ce1e5f37d8fc12fa67502b79974ec3f3ab))
* **Contract::Base:** improves contract instantiation by extracting the connection from account if given ([547ed17](https://github.com/budacom/etherlite/commit/547ed178291fecd6c96ae9420db48e30dc98f974))
* **contract:** adds deploy method ([f6e4aa7](https://github.com/budacom/etherlite/commit/f6e4aa722be5068777955a7ea10ac804dbb46a81))
* **Contract:** adds support for contract arguments on deploy ([301a197](https://github.com/budacom/etherlite/commit/301a19733fffc0f0ff1f10d8c75c2fec98895b51))
* **Contract:** adds support for manifest 'bytecode' property ([cfdf676](https://github.com/budacom/etherlite/commit/cfdf676ea630b4861b161e91ca91f2ca510c0195))
* **Etherlite:** adds :bytecode option to Contract.deploy ([1e53161](https://github.com/budacom/etherlite/commit/1e531614320d0bacb8197217594e92c57d2b7b47))
* **Events:** improves event data decoding and adds specs ([91dba7c](https://github.com/budacom/etherlite/commit/91dba7c4d03368178d980482708e5a65fe4ec317))
* **Function:** adds return value decoding ([10dac58](https://github.com/budacom/etherlite/commit/10dac58ff45d03a7a20185104c75d64004039e48))
* **Node:** add get_logs method ([b73326c](https://github.com/budacom/etherlite/commit/b73326c097d400b9d861b1d4a5859f86e9ae0ee3))
* **PrivateKey.send_transaction:** allow replacing last transaction ([22494f2](https://github.com/budacom/etherlite/commit/22494f2b48486c25fc95ef2c0ad352fe306c9e1e))
* **ruby:** add support for ruby &gt; 3 ([582acdb](https://github.com/budacom/etherlite/commit/582acdbad57dfb23f188302c65ba0f2bcdfee116))
* **spec:** adds adds contract construction integration spec ([ca780dd](https://github.com/budacom/etherlite/commit/ca780dd1fb656aed471092164c7714176a382acc))
* **String:** implements encode and decode ([a31a806](https://github.com/budacom/etherlite/commit/a31a806bb849871369087e4e0074dbac6f43ff3b))
* **Transaction:** adds logs and events properties ([3867a9d](https://github.com/budacom/etherlite/commit/3867a9df467c08f00c61a605d60ca0849eaba929))
* **Transaction:** adds refresh and receipt related properties ([7a51dec](https://github.com/budacom/etherlite/commit/7a51decbe65d527e9e12408366df7debdd6a0091))
* **Transaction:** adds succeeded?, removed? and confirmations methods ([58541c5](https://github.com/budacom/etherlite/commit/58541c5da046a6df3123a4a19680e517baee6d16))
* **Transaction:** adds value, gas and gas_price getters ([e51892b](https://github.com/budacom/etherlite/commit/e51892bdf4396bbc46c17261f644a15b0e9a0748))
* **types/Bytes:** implements encode method ([20b8fdf](https://github.com/budacom/etherlite/commit/20b8fdf6e1b8e92f5b6e440f58eea6b11f033034))
* **Utils:** implements hex_to_int method ([ae60f2c](https://github.com/budacom/etherlite/commit/ae60f2ca67339efc604bbc6b7cd5b9c86d0dd3dd))


### Bug Fixes

* **Account::PrivateKey:** fixes send_transaction when deploying contracts ([b8102df](https://github.com/budacom/etherlite/commit/b8102dfdba56ea87cc38cb30c14c4f74f20763bb))
* **account:** fixes typo ([5dc8bf4](https://github.com/budacom/etherlite/commit/5dc8bf4ac71e8f872df519e2edff8adb17c9424c))
* **client:** fixes client not accepting the connection argument ([fb9b392](https://github.com/budacom/etherlite/commit/fb9b39200ff455a9e7b643a4839ad44b1673b24f))
* **connection:** fixes support for empty path ([f784a88](https://github.com/budacom/etherlite/commit/f784a88eaf30092de92ac6ff9aaaf9ea2c1cb884))
* **contract:** fixes use of old command ([856a86b](https://github.com/budacom/etherlite/commit/856a86b883abbc50db72559541f4d24b992236ab))
* **DecodeLogInputs:** fixes topic decoding not removing leading '0x' ([b4981ec](https://github.com/budacom/etherlite/commit/b4981ec3a399db9d3fd0cb5da36040a1474ba813))
* fixes anonymous accounts support ([65fb09f](https://github.com/budacom/etherlite/commit/65fb09fbdf23e7f9b063212e455aff915ceab35d))
* fixes option processing on Etherlite.connect method ([77d4533](https://github.com/budacom/etherlite/commit/77d453377e839a81da4ec42691c910ce14931111))
* **gemspec:** removes push host restriction ([b14a4fe](https://github.com/budacom/etherlite/commit/b14a4fec1cad168b9cf957f27b4f469b7858cc25))
* **PkAccount:** adds nonce generation ([2a9a938](https://github.com/budacom/etherlite/commit/2a9a93803b1fa4e5b10532916a542ebca5e0b493))
* **Transaction:** fix removed? method always returning false ([cdca56c](https://github.com/budacom/etherlite/commit/cdca56c6a590a764802cd96a213451cee3445852))
* **Transaction:** fixes case quere eth_get_transaction_receipt returns nil ([37bebb8](https://github.com/budacom/etherlite/commit/37bebb8a8bbf011e037b22fbecd5d5c2911ac110))
* **Types::Address:** fixes encode trying to call to_raw_hex on normalized strings ([0e0ef7a](https://github.com/budacom/etherlite/commit/0e0ef7ac6dcfbd44076d093eaf2437529ba42186))

## [0.7.0](https://github.com/budacom/etherlite/compare/v0.6.0...v0.7.0) (2025-04-16)


### Features

* **ruby:** add support for ruby &gt; 3 ([582acdb](https://github.com/budacom/etherlite/commit/582acdbad57dfb23f188302c65ba0f2bcdfee116))
