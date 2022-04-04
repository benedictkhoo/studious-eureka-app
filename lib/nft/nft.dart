import 'package:equatable/equatable.dart';

class NFT extends Equatable {
  final int balance;
  final bool minter;
  final String name;
  final bool paused;
  final bool pauser;
  final String symbol;

  const NFT({
    required this.balance,
    required this.minter,
    required this.name,
    required this.paused,
    required this.pauser,
    required this.symbol,
  });

  @override
  List<Object> get props => [balance, minter, name, paused, pauser, symbol];
}
