import 'dart:math';

import 'package:flutter_web3/flutter_web3.dart';
import 'package:studious_eureka/env/env.dart';
import 'package:studious_eureka/ethereum_service.dart';

const _abi = '''[
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
      "inputs": [
        {
          "internalType": "address",
          "name": "account",
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
      "inputs": [],
      "name": "cap",
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
      "inputs": [],
      "name": "decimals",
      "outputs": [
        {
          "internalType": "uint8",
          "name": "",
          "type": "uint8"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
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
      "name": "totalSupply",
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
          "internalType": "address",
          "name": "to",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "mint",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]''';

class TokenContractRepository {
  static final TokenContractRepository _instance = TokenContractRepository._internal();
  static late final Contract _contract;
  static late final BigInt _precision;
  static late final int _cap;
  static late final String _minterRole;
  static late final String _name;
  static late final String _symbol;

  factory TokenContractRepository() {
    return _instance;
  }

  TokenContractRepository._internal() {
    _contract = Contract(Env.tokenContract, _abi, EthereumService().provider()!.getSigner());
  }

  Future<void> init() async {
    final results = await Future.wait([
      _contract.call<int>('decimals'),
      _contract.call<BigInt>('cap'),
      _contract.call<String>('MINTER_ROLE'),
      _contract.call<String>('name'),
      _contract.call<String>('symbol'),
    ]);

    _precision = BigInt.from(pow(10, results[0] as int));
    _cap = BigInt.from((results[1] as BigInt) / _precision).toInt();
    _minterRole = results[2] as String;
    _name = results[3] as String;
    _symbol = results[4] as String;
  }

  Future<bool> isMinter() async {
    return _contract.call<bool>('hasRole', [_minterRole, await EthereumService().walletAddress()]);
  }

  Future<String> symbol() => Future.value(_symbol);

  Future<String> name() => Future.value(_name);

  Future<int> cap() => Future.value(_cap);

  Future<int> supply() async {
    final supply = await _contract.call<BigInt>('totalSupply');

    return (supply / _precision).ceil();
  }

  Future<int> balance() async {
    final balance = await _contract.call<BigInt>('balanceOf', [await EthereumService().walletAddress()]);

    return (balance / _precision).ceil();
  }

  Future<void> mint(int value) async {
    return _contract.call<void>('mint', [
      await EthereumService().walletAddress(),
      BigInt.from(value * pow(10, 18)).toBigNumber,
    ]);
  }
}
