part of 'nft_bloc.dart';

abstract class NFTEvent extends Equatable {
  const NFTEvent();

  @override
  List<Object> get props => [];
}

class NFTLoaded extends NFTEvent {
  const NFTLoaded();
}

class NFTRefreshed extends NFTEvent {
  const NFTRefreshed();
}

class NFTPaused extends NFTEvent {
  const NFTPaused();
}

class NFTResumed extends NFTEvent {
  const NFTResumed();
}

class NFTMinted extends NFTEvent {
  const NFTMinted();
}

class NFTBurned extends NFTEvent {
  final String tokenId;

  const NFTBurned({required this.tokenId});

  @override
  List<Object> get props => [tokenId];
}
