import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studious_eureka/ethereum_service.dart';

part 'ethereum_event.dart';
part 'ethereum_state.dart';

class EthereumBloc extends Bloc<EthereumEvent, EthereumState> {
  late final StreamSubscription<EthereumServiceEvent> _subscription;

  EthereumBloc() : super(const EthereumState()) {
    on<EthereumMetaMaskInitialized>(_onEthereumMetaMaskInitialized);
    on<EthereumMetaMaskSelected>(_onEthereumMetaMaskSelected);
    on<EthereumMetaMaskConnected>(_onEthereumMetaMaskConnected);
    on<EthereumMetaMaskDisconnected>(_onEthereumMetaMaskDisconnected);
    on<EthereumWalletConnectInitialized>(_onEthereumWalletConnectInitialized);
    on<EthereumWalletConnectSelected>(_onEthereumWalletConnectSelected);
    on<EthereumWalletConnectConnected>(_onEthereumWalletConnectConnected);
    on<EthereumWalletConnectDisconnected>(_onEthereumWalletConnectDisconnected);

    _subscription = EthereumService().subscribe().listen((event) {
      switch (event.status) {
        case EthereumServiceStatus.available:
        case EthereumServiceStatus.unavailable:
          final available = event.status == EthereumServiceStatus.available;

          if (event.provider == EthereumServiceProvider.metaMask) {
            add(EthereumMetaMaskInitialized(available: available));
          } else {
            add(EthereumWalletConnectInitialized(available: available));
          }
          break;
        case EthereumServiceStatus.connected:
          if (event.provider == EthereumServiceProvider.metaMask) {
            add(const EthereumMetaMaskConnected());
          } else {
            add(const EthereumWalletConnectConnected());
          }
          break;
        case EthereumServiceStatus.disconnected:
          if (event.provider == EthereumServiceProvider.metaMask) {
            add(const EthereumMetaMaskDisconnected());
          } else {
            add(const EthereumWalletConnectDisconnected());
          }
          break;
        default:
          break;
      }
    });

    EthereumService().start();
  }

  @override
  Future<void> close() {
    _subscription.cancel();

    return super.close();
  }

  void _onEthereumMetaMaskInitialized(EthereumMetaMaskInitialized event, Emitter<EthereumState> emit) {
    emit(
      state.copyWith(
        metaMaskStatus:
            event.available ? EthereumStateMetaMaskStatus.available : EthereumStateMetaMaskStatus.unavailable,
      ),
    );
  }

  Future<void> _onEthereumMetaMaskSelected(EthereumMetaMaskSelected event, Emitter<EthereumState> emit) async {
    emit(state.copyWith(status: EthereumStateStatus.loading));

    await EthereumService().connectToMetaMask();
  }

  void _onEthereumMetaMaskConnected(EthereumMetaMaskConnected event, Emitter<EthereumState> emit) {
    emit(state.copyWith(status: EthereumStateStatus.connected));
  }

  void _onEthereumMetaMaskDisconnected(EthereumMetaMaskDisconnected event, Emitter<EthereumState> emit) {
    emit(state.copyWith(status: EthereumStateStatus.pristine));
  }

  void _onEthereumWalletConnectInitialized(EthereumWalletConnectInitialized event, Emitter<EthereumState> emit) {
    emit(
      state.copyWith(
        walletConnectStatus:
            event.available ? EthereumStateWalletConnectStatus.available : EthereumStateWalletConnectStatus.unavailable,
      ),
    );
  }

  Future<void> _onEthereumWalletConnectSelected(
      EthereumWalletConnectSelected event, Emitter<EthereumState> emit) async {
    emit(state.copyWith(status: EthereumStateStatus.loading));

    await EthereumService().connectToWalletConnect();
  }

  void _onEthereumWalletConnectConnected(EthereumWalletConnectConnected event, Emitter<EthereumState> emit) {
    emit(state.copyWith(status: EthereumStateStatus.connected));
  }

  void _onEthereumWalletConnectDisconnected(EthereumWalletConnectDisconnected event, Emitter<EthereumState> emit) {
    emit(state.copyWith(status: EthereumStateStatus.pristine));
  }
}
