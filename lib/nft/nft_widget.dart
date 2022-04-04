import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:studious_eureka/nft/bloc/nft_bloc.dart';
import 'package:studious_eureka/nft/burn_dialog_widget.dart';

class NFTWidget extends StatelessWidget {
  const NFTWidget({Key? key}) : super(key: key);

  List<Widget> _renderContent(BuildContext context, NFTState state) {
    return [
      ListTile(
        title: Text(
          '${state.token!.name} (${state.token!.symbol})',
          style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'You have ${state.token!.balance}',
          style: Theme.of(context).textTheme.subtitle1!,
        ),
        trailing: IconButton(
          onPressed: () => context.read<NFTBloc>().add(const NFTRefreshed()),
          icon: const Icon(Icons.refresh),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (state.token!.minter)
            BlocBuilder<NFTBloc, NFTState>(
              buildWhen: (previous, current) => previous.mintStatus != current.mintStatus,
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.mintStatus == NFTStateMintStatus.loading
                      ? null
                      : () => context.read<NFTBloc>().add(const NFTMinted()),
                  child: const Text('Mint'),
                );
              },
            ),
          BlocBuilder<NFTBloc, NFTState>(
            buildWhen: (previous, current) => previous.burnStatus != current.burnStatus,
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.burnStatus == NFTStateBurnStatus.loading
                    ? null
                    : () => showDialog(context: context, builder: (_) => const BurnDialogWidget()),
                child: const Text('Burn'),
              );
            },
          ),
          if (state.token!.pauser)
            BlocBuilder<NFTBloc, NFTState>(
              buildWhen: (previous, current) => previous.pauseStatus != current.pauseStatus,
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.pauseStatus == NFTStatePauseStatus.loading
                      ? null
                      : () => context.read<NFTBloc>().add(state.token!.paused ? const NFTResumed() : const NFTPaused()),
                  child: Text(state.token!.paused ? 'Resume' : 'Pause'),
                );
              },
            ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NFTBloc()..add(const NFTLoaded()),
      child: BlocConsumer<NFTBloc, NFTState>(
        listenWhen: (previous, current) => previous.mintStatus != current.mintStatus,
        listener: (context, state) {
          if (state.mintStatus == NFTStateMintStatus.failure) {
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
                if (state.status == NFTStateStatus.pristine || state.status == NFTStateStatus.loading)
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade400,
                    child: const ListTile(
                      title: Text('Name (NFT)'),
                      subtitle: Text('Quantity'),
                    ),
                  ),
                if (state.status == NFTStateStatus.success) ..._renderContent(context, state),
                if (state.status == NFTStateStatus.failure)
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
