part of 'ethereum_bloc.dart';

enum EthereumStateMetaMaskStatus { unknown, available, unavailable }

enum EthereumStateWalletConnectStatus { unknown, available, unavailable }

enum EthereumStateStatus { pristine, loading, connected }

class EthereumState extends Equatable {
  final EthereumStateMetaMaskStatus metaMaskStatus;
  final EthereumStateWalletConnectStatus walletConnectStatus;
  final EthereumStateStatus status;

  const EthereumState({
    this.metaMaskStatus = EthereumStateMetaMaskStatus.unknown,
    this.walletConnectStatus = EthereumStateWalletConnectStatus.unknown,
    this.status = EthereumStateStatus.pristine,
  });

  @override
  List<Object> get props => [metaMaskStatus, walletConnectStatus, status];

  EthereumState copyWith({
    EthereumStateMetaMaskStatus? metaMaskStatus,
    EthereumStateWalletConnectStatus? walletConnectStatus,
    EthereumStateStatus? status,
  }) {
    return EthereumState(
      metaMaskStatus: metaMaskStatus ?? this.metaMaskStatus,
      walletConnectStatus: walletConnectStatus ?? this.walletConnectStatus,
      status: status ?? this.status,
    );
  }
}
