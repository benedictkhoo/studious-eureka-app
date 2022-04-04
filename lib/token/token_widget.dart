import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:studious_eureka/token/bloc/token_bloc.dart';
import 'package:studious_eureka/token/mint_dialog_widget.dart';

class TokenWidget extends StatelessWidget {
  const TokenWidget({Key? key}) : super(key: key);

  List<Widget> _renderContent(BuildContext context, TokenState state) {
    return [
      ListTile(
        title: Text(
          '${state.token!.name} (${state.token!.symbol})',
          style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Balance: ${NumberFormat.currency(symbol: '', decimalDigits: 0).format(state.token!.balance)}',
          style: Theme.of(context).textTheme.subtitle1!,
        ),
        trailing: IconButton(
          onPressed: () => context.read<TokenBloc>().add(const TokenRefreshed()),
          icon: const Icon(Icons.refresh),
        ),
      ),
      ListTile(
        title: const Text('Total Supply'),
        subtitle: Text(
          NumberFormat.currency(symbol: '', decimalDigits: 0).format(state.token!.totalSupply),
        ),
      ),
      ListTile(
        title: const Text('Cap'),
        subtitle: Text(
          NumberFormat.currency(symbol: '', decimalDigits: 0).format(state.token!.cap),
        ),
      ),
      if (state.token!.minter)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BlocBuilder<TokenBloc, TokenState>(
              buildWhen: (previous, current) => previous.mintStatus != current.mintStatus,
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.mintStatus == TokenStateMintStatus.loading
                      ? null
                      : () => showDialog(context: context, builder: (_) => const MintDialogWidget()),
                  child: const Text('Mint'),
                );
              },
            )
          ],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TokenBloc()..add(const TokenLoaded()),
      child: BlocConsumer<TokenBloc, TokenState>(
        listenWhen: (previous, current) => previous.mintStatus != current.mintStatus,
        listener: (context, state) {
          if (state.mintStatus == TokenStateMintStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to mint. Please try again.')),
            );
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        },
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Card(
            child: Column(
              children: [
                if (state.status == TokenStateStatus.pristine || state.status == TokenStateStatus.loading)
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade400,
                    child: const ListTile(
                      title: Text('Name (NAM)'),
                      subtitle: Text('Balance'),
                    ),
                  ),
                if (state.status == TokenStateStatus.success) ..._renderContent(context, state),
                if (state.status == TokenStateStatus.failure)
                  const ListTile(
                    title: Text('Failed to load token 😢'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
