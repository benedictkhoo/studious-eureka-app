import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studious_eureka/nft/bloc/nft_bloc.dart';

class BurnDialogWidget extends StatelessWidget {
  const BurnDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
          style: TextButton.styleFrom(primary: Theme.of(context).colorScheme.error),
        ),
        TextButton(
          onPressed: () {
            final tokenId = controller.value.text;

            if (tokenId.isNotEmpty) {
              context.read<NFTBloc>().add(NFTBurned(tokenId: tokenId));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a token id.')));
            }

            Navigator.pop(context);
          },
          child: const Text('Burn'),
        ),
      ],
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Token ID'),
        keyboardType: TextInputType.number,
      ),
      title: const Text('Burn'),
    );
  }
}
