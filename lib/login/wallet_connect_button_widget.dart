import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studious_eureka/bloc/ethereum_bloc.dart';

class WalletConnectButtonWidget extends StatelessWidget {
  const WalletConnectButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => context.read<EthereumBloc>().add(const EthereumWalletConnectSelected()),
      icon: Image.asset('assets/images/walletconnect-logo.png', width: 39, height: 24),
      label: const Text('WalletConnect'),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.blue,
        fixedSize: const Size(172, 36),
      ),
    );
  }
}
