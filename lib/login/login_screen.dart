import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studious_eureka/bloc/ethereum_bloc.dart';
import 'package:studious_eureka/login/meta_mask_button_widget.dart';
import 'package:studious_eureka/login/wallet_connect_button_widget.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<EthereumBloc, EthereumState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Stack(
          children: [
            BlocBuilder<EthereumBloc, EthereumState>(
              buildWhen: (previous, current) {
                return previous.metaMaskStatus != current.metaMaskStatus ||
                    previous.walletConnectStatus != current.walletConnectStatus;
              },
              builder: (context, state) {
                final ready = state.metaMaskStatus != EthereumStateMetaMaskStatus.unknown &&
                    state.walletConnectStatus != EthereumStateWalletConnectStatus.unknown;
                final metaMaskAvailable = state.metaMaskStatus == EthereumStateMetaMaskStatus.available;

                return Center(
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: (MediaQuery.of(context).size.height - kToolbarHeight) * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: !ready
                            ? [const CircularProgressIndicator()]
                            : [
                                if (metaMaskAvailable) const Flexible(child: MetaMaskButtonWidget()),
                                if (metaMaskAvailable) const Spacer(),
                                const Flexible(child: WalletConnectButtonWidget()),
                              ],
                      ),
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<EthereumBloc, EthereumState>(
              buildWhen: (previous, current) => previous.status != current.status,
              builder: (context, state) {
                return Visibility(
                  visible: state.status == EthereumStateStatus.loading,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black54),
                    child: const CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
