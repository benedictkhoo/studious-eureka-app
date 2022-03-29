import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:studious_eureka/env/env.dart';

enum EthereumServiceProvider { metaMask, walletConnect }

enum EthereumServiceStatus { available, unavailable, connected, disconnected }

class EthereumServiceEvent extends Equatable {
  final EthereumServiceProvider provider;
  final EthereumServiceStatus status;

  const EthereumServiceEvent({required this.provider, required this.status});

  @override
  List<Object> get props => [provider, status];
}

class EthereumService {
  static final EthereumService _instance = EthereumService._internal();
  static final _walletConnect = WalletConnectProvider.fromInfura(Env.infuraId);
  late final StreamController<EthereumServiceEvent> _streamController;

  factory EthereumService() {
    return _instance;
  }

  EthereumService._internal() {
    _streamController = StreamController<EthereumServiceEvent>.broadcast();
  }

  void start() {
    if (ethereum == null) {
      _streamController.sink.add(
        const EthereumServiceEvent(
          provider: EthereumServiceProvider.metaMask,
          status: EthereumServiceStatus.unavailable,
        ),
      );
    } else {
      _streamController.sink.add(
        const EthereumServiceEvent(
          provider: EthereumServiceProvider.metaMask,
          status: EthereumServiceStatus.available,
        ),
      );

      ethereum!.onAccountsChanged((accounts) {
        final EthereumServiceStatus status;

        if (accounts.isNotEmpty) {
          status = EthereumServiceStatus.connected;
        } else {
          status = EthereumServiceStatus.disconnected;
        }

        _streamController.sink.add(
          EthereumServiceEvent(provider: EthereumServiceProvider.metaMask, status: status),
        );
      });
    }

    _streamController.sink.add(
      const EthereumServiceEvent(
        provider: EthereumServiceProvider.walletConnect,
        status: EthereumServiceStatus.available,
      ),
    );

    _walletConnect.onAccountsChanged((accounts) {
      final EthereumServiceStatus status;

      if (accounts.isNotEmpty) {
        status = EthereumServiceStatus.connected;
      } else {
        status = EthereumServiceStatus.disconnected;
      }

      _streamController.sink.add(
        EthereumServiceEvent(provider: EthereumServiceProvider.walletConnect, status: status),
      );
    });
  }

  void close() {
    ethereum!.removeAllListeners();
    _walletConnect.removeAllListeners();
    _walletConnect.disconnect();
    _streamController.close();
  }

  Future<void> connectToMetaMask() async {
    if (ethereum != null) {
      await ethereum!.getAccounts();
    }
  }

  Future<void> connectToWalletConnect() => _walletConnect.connect();

  Future<String?> walletAddress() async {
    if (ethereum != null && ethereum!.isConnected()) {
      return (await ethereum!.getAccounts()).first;
    } else if (_walletConnect.connected) {
      return Future.value(_walletConnect.accounts.first);
    }

    return null;
  }

  Web3Provider? provider() {
    if (ethereum != null && ethereum!.isConnected()) {
      return Web3Provider.fromEthereum(ethereum!);
    } else if (_walletConnect.connected) {
      return Web3Provider.fromWalletConnect(_walletConnect);
    }

    return null;
  }

  Stream<EthereumServiceEvent> subscribe() => _streamController.stream.asBroadcastStream();
}
