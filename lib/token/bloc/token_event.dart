part of 'token_bloc.dart';

abstract class TokenEvent extends Equatable {
  const TokenEvent();

  @override
  List<Object> get props => [];
}

class TokenLoaded extends TokenEvent {
  const TokenLoaded();
}

class TokenRefreshed extends TokenEvent {
  const TokenRefreshed();
}

class TokenMinted extends TokenEvent {
  final int value;

  const TokenMinted({required this.value});
}
