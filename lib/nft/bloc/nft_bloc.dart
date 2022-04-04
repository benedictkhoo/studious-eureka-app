import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studious_eureka/nft/nft.dart';
import 'package:studious_eureka/nft/nft_contract_repository.dart';

part 'nft_event.dart';
part 'nft_state.dart';

class NFTBloc extends Bloc<NFTEvent, NFTState> {
  NFTBloc() : super(const NFTState()) {
    on<NFTLoaded>(_onNFTLoaded);
    on<NFTRefreshed>(_onNFTRefreshed);
    on<NFTResumed>(_onNFTResumed);
    on<NFTPaused>(_onNFTPaused);
    on<NFTMinted>(_onNFTMinted);
    on<NFTBurned>(_onNFTBurned);
  }

  Future<NFT> _loadNFT() async {
    final results = await Future.wait([
      NFTContractRepository().balance(),
      NFTContractRepository().isMinter(),
      NFTContractRepository().name(),
      NFTContractRepository().isPaused(),
      NFTContractRepository().isPauser(),
      NFTContractRepository().symbol(),
    ]);

    return NFT(
      balance: results[0] as int,
      minter: results[1] as bool,
      name: results[2] as String,
      paused: results[3] as bool,
      pauser: results[4] as bool,
      symbol: results[5] as String,
    );
  }

  Future<void> _onNFTLoaded(NFTLoaded event, Emitter<NFTState> emit) async {
    emit(state.copyWith(status: NFTStateStatus.loading));

    try {
      await NFTContractRepository().init();

      final token = await _loadNFT();

      emit(state.copyWith(status: NFTStateStatus.success, token: token));
    } catch (_) {
      emit(state.copyWith(status: NFTStateStatus.failure));
    }
  }

  Future<void> _onNFTRefreshed(NFTRefreshed event, Emitter<NFTState> emit) async {
    emit(state.copyWith(status: NFTStateStatus.loading));

    try {
      final token = await _loadNFT();

      emit(state.copyWith(status: NFTStateStatus.success, token: token));
    } catch (_) {
      emit(state.copyWith(status: NFTStateStatus.failure));
    }
  }

  Future<void> _onNFTResumed(NFTResumed event, Emitter<NFTState> emit) async {
    emit(state.copyWith(pauseStatus: NFTStatePauseStatus.loading));

    try {
      await NFTContractRepository().resume();

      emit(state.copyWith(pauseStatus: NFTStatePauseStatus.success));
    } catch (_) {
      emit(state.copyWith(pauseStatus: NFTStatePauseStatus.failure));
    }
  }

  Future<void> _onNFTPaused(NFTPaused event, Emitter<NFTState> emit) async {
    emit(state.copyWith(pauseStatus: NFTStatePauseStatus.loading));

    try {
      await NFTContractRepository().pause();

      emit(state.copyWith(pauseStatus: NFTStatePauseStatus.success));
    } catch (_) {
      emit(state.copyWith(pauseStatus: NFTStatePauseStatus.failure));
    }
  }

  Future<void> _onNFTMinted(NFTMinted event, Emitter<NFTState> emit) async {
    emit(state.copyWith(mintStatus: NFTStateMintStatus.loading));

    try {
      await NFTContractRepository().mint();

      emit(state.copyWith(mintStatus: NFTStateMintStatus.success));
    } catch (_) {
      emit(state.copyWith(mintStatus: NFTStateMintStatus.failure));
    }
  }

  Future<void> _onNFTBurned(NFTBurned event, Emitter<NFTState> emit) async {
    emit(state.copyWith(burnStatus: NFTStateBurnStatus.loading));

    try {
      await NFTContractRepository().burn(event.tokenId);

      emit(state.copyWith(burnStatus: NFTStateBurnStatus.success));
    } catch (_) {
      emit(state.copyWith(burnStatus: NFTStateBurnStatus.failure));
    }
  }
}
