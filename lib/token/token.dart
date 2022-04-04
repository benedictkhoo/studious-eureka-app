import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final int balance;
  final int cap;
  final bool minter;
  final String name;
  final String symbol;
  final int totalSupply;

  const Token({
    required this.balance,
    required this.cap,
    required this.minter,
    required this.name,
    required this.symbol,
    required this.totalSupply,
  });

  @override
  List<Object> get props => [balance, cap, minter, name, symbol, totalSupply];
}
