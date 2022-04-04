import 'package:envify/envify.dart';

part 'env.g.dart';

@Envify()
abstract class Env {
  static const infuraId = _Env.infuraId;
  static const nftContract = _Env.nftContract;
  static const tokenContract = _Env.tokenContract;
}
