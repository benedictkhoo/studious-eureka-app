import 'package:flutter/material.dart';
import 'package:studious_eureka/nft/nft_widget.dart';
import 'package:studious_eureka/token/token_widget.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: GridView.extent(
        maxCrossAxisExtent: 400,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        padding: const EdgeInsets.all(16),
        children: const [
          TokenWidget(),
          NFTWidget(),
        ],
      ),
    );
  }
}
