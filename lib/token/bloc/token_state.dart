part of 'token_bloc.dart';

enum TokenStateStatus { pristine, loading, success, failure }

enum TokenStateMintStatus { pristine, loading, success, failure }

class TokenState extends Equatable {
  final TokenStateMintStatus mintStatus;
  final TokenStateStatus status;
  final Token? token;

  const TokenState({
    this.mintStatus = TokenStateMintStatus.pristine,
    this.status = TokenStateStatus.pristine,
    this.token,
  });

  @override
  List<Object?> get props => [mintStatus, status, token];

  TokenState copyWith({TokenStateMintStatus? mintStatus, TokenStateStatus? status, Token? token}) {
    return TokenState(
      mintStatus: mintStatus ?? this.mintStatus,
      status: status ?? this.status,
      token: token ?? this.token,
    );
  }
}
