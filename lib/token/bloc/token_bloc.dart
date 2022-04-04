import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studious_eureka/token/token.dart';
import 'package:studious_eureka/token/token_contract_repository.dart';

part 'token_event.dart';
part 'token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  TokenBloc() : super(const TokenState()) {
    on<TokenLoaded>(_onTokenLoaded);
    on<TokenRefreshed>(_onTokenRefreshed);
    on<TokenMinted>(_onTokenMinted);
  }

  Future<Token> _loadToken() async {
    final results = await Future.wait([
      TokenContractRepository().balance(),
      TokenContractRepository().cap(),
      TokenContractRepository().isMinter(),
      TokenContractRepository().name(),
      TokenContractRepository().symbol(),
      TokenContractRepository().supply(),
    ]);

    return Future.value(
      Token(
        balance: results[0] as int,
        cap: results[1] as int,
        minter: results[2] as bool,
        name: results[3] as String,
        symbol: results[4] as String,
        totalSupply: results[5] as int,
      ),
    );
  }

  Future<void> _onTokenLoaded(TokenLoaded event, Emitter<TokenState> emit) async {
    emit(state.copyWith(status: TokenStateStatus.loading));

    try {
      await TokenContractRepository().init();

      final token = await _loadToken();

      emit(state.copyWith(status: TokenStateStatus.success, token: token));
    } catch (_) {
      emit(state.copyWith(status: TokenStateStatus.failure));
    }
  }

  Future<void> _onTokenRefreshed(TokenRefreshed event, Emitter<TokenState> emit) async {
    emit(state.copyWith(status: TokenStateStatus.loading));

    try {
      final token = await _loadToken();

      emit(state.copyWith(status: TokenStateStatus.success, token: token));
    } catch (_) {
      emit(state.copyWith(status: TokenStateStatus.failure));
    }
  }

  Future<void> _onTokenMinted(TokenMinted event, Emitter<TokenState> emit) async {
    emit(state.copyWith(mintStatus: TokenStateMintStatus.loading));

    try {
      await TokenContractRepository().mint(event.value);

      emit(state.copyWith(mintStatus: TokenStateMintStatus.success));
    } catch (_) {
      emit(state.copyWith(mintStatus: TokenStateMintStatus.failure));
    }
  }
}
