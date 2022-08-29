<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# FileHeronServer

A Simple file server

## Features

-   Allows running a local server on machine as a static or rest file server.

## Getting started

-   Import the package in pubspec.yaml file as fileheron_server to use it.

## Usage

```dart
void main(List<String> args) {
  var server = FileHeronServer();
  ServerParams params = ServerParams(args);
  server.initStaticServer(params);
  server.start();
}
```

## Additional information

To contribute to this opensource project, open pull requests or issues in [git repo](https://github.com/horizech/fileheron_server)
