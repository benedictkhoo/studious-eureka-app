import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studious_eureka/token/bloc/token_bloc.dart';

class MintDialogWidget extends StatelessWidget {
  const MintDialogWidget({Key? key}) : super(key: key);

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
            final value = int.tryParse(controller.value.text) ?? 0;

            if (value > 0) {
              context.read<TokenBloc>().add(TokenMinted(value: value));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a value greater than 0')),
              );
            }

            Navigator.pop(context);
          },
          child: const Text('Mint'),
        ),
      ],
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Value'),
        keyboardType: TextInputType.number,
      ),
      title: const Text('Mint'),
    );
  }
}
