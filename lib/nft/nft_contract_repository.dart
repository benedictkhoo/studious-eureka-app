import 'package:flutter_web3/flutter_web3.dart';
import 'package:studious_eureka/env/env.dart';
import 'package:studious_eureka/ethereum_service.dart';

const _abi = '''
[
    {
      "inputs": [],
      "name": "MINTER_ROLE",
      "outputs": [
        {
          "internalType": "bytes32",
          "name": "",
          "type": "bytes32"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "PAUSER_ROLE",
      "outputs": [
        {
          "internalType": "bytes32",
          "name": "",
          "type": "bytes32"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        }
      ],
      "name": "balanceOf",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "tokenId",
          "type": "uint256"
        }
      ],
      "name": "burn",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "bytes32",
          "name": "role",
          "type": "bytes32"
        },
        {
          "internalType": "address",
          "name": "account",
          "type": "address"
        }
      ],
      "name": "hasRole",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "name",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },    
    {
      "inputs": [],
      "name": "paused",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "symbol",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "pause",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "unpause",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "to",
          "type": "address"
        }
      ],
      "name": "safeMint",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]
''';

class NFTContractRepository {
  static final NFTContractRepository _instance = NFTContractRepository._internal();
  static late final Contract _contract;
  static late final String _minterRole;
  static late final String _pauserRole;
  static late final String _name;
  static late final String _symbol;

  factory NFTContractRepository() {
    return _instance;
  }

  NFTContractRepository._internal() {
    _contract = Contract(Env.nftContract, _abi, EthereumService().provider()!.getSigner());
  }

  Future<void> init() async {
    final results = await Future.wait([
      _contract.call<String>('MINTER_ROLE'),
      _contract.call<String>('PAUSER_ROLE'),
      _contract.call<String>('name'),
      _contract.call<String>('symbol'),
    ]);

    _minterRole = results[0];
    _pauserRole = results[1];
    _name = results[2];
    _symbol = results[3];
  }

  Future<bool> isMinter() async {
    return _contract.call<bool>('hasRole', [_minterRole, await EthereumService().walletAddress()]);
  }

  Future<bool> isPauser() async {
    return _contract.call<bool>('hasRole', [_pauserRole, await EthereumService().walletAddress()]);
  }

  Future<bool> isPaused() async => _contract.call<bool>('paused');

  Future<String> symbol() => Future.value(_symbol);

  Future<String> name() => Future.value(_name);

  Future<int> balance() async {
    final balance = await _contract.call<BigInt>('balanceOf', [await EthereumService().walletAddress()]);

    return balance.toInt();
  }

  Future<void> burn(String tokenId) async => _contract.call<void>('burn', [tokenId]);

  Future<void> mint() async => _contract.call<void>('safeMint', [await EthereumService().walletAddress()]);

  Future<void> pause() async => _contract.call<void>('pause');

  Future<void> resume() async => _contract.call<void>('unpause');
}
