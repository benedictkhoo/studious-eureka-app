import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studious_eureka/bloc/ethereum_bloc.dart';

class MetaMaskButtonWidget extends StatelessWidget {
  const MetaMaskButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => context.read<EthereumBloc>().add(const EthereumMetaMaskSelected()),
      icon: Image.asset('assets/images/metamask-logo.png', width: 24, height: 24),
      label: const Text('MetaMask'),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: const Color.fromRGBO(246, 133, 27, 1),
        fixedSize: const Size(172, 36),
      ),
    );
  }
}
