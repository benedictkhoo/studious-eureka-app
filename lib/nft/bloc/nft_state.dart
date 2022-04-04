part of 'nft_bloc.dart';

enum NFTStateBurnStatus { pristine, loading, success, failure }

enum NFTStateMintStatus { pristine, loading, success, failure }

enum NFTStatePauseStatus { pristine, loading, success, failure }

enum NFTStateStatus { pristine, loading, success, failure }

class NFTState extends Equatable {
  final NFTStateBurnStatus burnStatus;
  final NFTStateMintStatus mintStatus;
  final NFTStatePauseStatus pauseStatus;
  final NFTStateStatus status;
  final NFT? token;

  const NFTState({
    this.burnStatus = NFTStateBurnStatus.pristine,
    this.mintStatus = NFTStateMintStatus.pristine,
    this.pauseStatus = NFTStatePauseStatus.pristine,
    this.status = NFTStateStatus.pristine,
    this.token,
  });

  @override
  List<Object?> get props => [burnStatus, mintStatus, pauseStatus, status, token];

  NFTState copyWith({
    NFTStateBurnStatus? burnStatus,
    NFTStateMintStatus? mintStatus,
    NFTStatePauseStatus? pauseStatus,
    NFTStateStatus? status,
    NFT? token,
  }) {
    return NFTState(
      burnStatus: burnStatus ?? this.burnStatus,
      mintStatus: mintStatus ?? this.mintStatus,
      pauseStatus: pauseStatus ?? this.pauseStatus,
      status: status ?? this.status,
      token: token ?? this.token,
    );
  }
}
