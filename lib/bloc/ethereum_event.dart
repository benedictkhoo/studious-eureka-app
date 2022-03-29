part of 'ethereum_bloc.dart';

abstract class EthereumEvent extends Equatable {
  const EthereumEvent();

  @override
  List<Object> get props => [];
}

class EthereumMetaMaskInitialized extends EthereumEvent {
  final bool available;

  const EthereumMetaMaskInitialized({required this.available});
}

class EthereumMetaMaskSelected extends EthereumEvent {
  const EthereumMetaMaskSelected();
}

class EthereumMetaMaskConnected extends EthereumEvent {
  const EthereumMetaMaskConnected();
}

class EthereumMetaMaskDisconnected extends EthereumEvent {
  const EthereumMetaMaskDisconnected();
}

class EthereumWalletConnectInitialized extends EthereumEvent {
  final bool available;

  const EthereumWalletConnectInitialized({required this.available});
}

class EthereumWalletConnectSelected extends EthereumEvent {
  const EthereumWalletConnectSelected();
}

class EthereumWalletConnectConnected extends EthereumEvent {
  const EthereumWalletConnectConnected();
}

class EthereumWalletConnectDisconnected extends EthereumEvent {
  const EthereumWalletConnectDisconnected();
}
