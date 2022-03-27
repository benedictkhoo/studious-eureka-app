# Studious Eureka App

![GitHub](https://img.shields.io/github/license/benedictkhoo/studious-eureka-app?style=flat-square)

A Flutter project that showcases interactions with smart contracts.

## Table of Contents

- [Install](#install)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Install

```sh
flutter pub get
```

## Usage

1. Create an .env file in the root directory with the following properties:

```
INFURA_ID={YOUR INFURA ID}
NFT_CONTRACT={NFT CONTRACT ADDRESS}
TOKEN_CONTRACT={TOKEN CONTRACT ADDRESS}
```

2. Generate the necessary environment file:

```sh
flutter pub run build_runner build
```

3. Run the project:


```sh
flutter run
```

## Contributing

Please read the [Contributing file](CONTRIBUTING.md).

## License

[MIT](LICENSE) &copy; 2022 Benedict Khoo
