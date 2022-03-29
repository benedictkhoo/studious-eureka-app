import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studious_eureka/bloc/ethereum_bloc.dart';
import 'package:studious_eureka/login/login_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EthereumBloc(),
      child: MaterialApp(
        title: 'Studious Eureka',
        home: BlocBuilder<EthereumBloc, EthereumState>(
          buildWhen: (previous, current) {
            return previous.status != current.status && current.status != EthereumStateStatus.loading;
          },
          builder: (_, __) => const LoginScreen(),
        ),
      ),
    );
  }
}
