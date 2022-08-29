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
  ServerParams params = ServerParams(
      hostname: "locahost",
      port: 8080,
      listDir: true,
      logFile: "log.txt",
      root: "public");
  server.initStaticServer(params);
  server.start();
}
```

## Runtime arguments Parameters

You can also use runtime arguments directly to initialize server

| Parameter              | Description               | Default Value | Possible Values |
| ---------------------- | ------------------------- | :-----------: | --------------- |
| host (-h)              | Hostname                  |   localhost   | valid address   |
| port (-p)              | Port                      |     8080      | valid port      |
| root (-r)              | Static folder             |    public     | valid folder    |
| listDir (-d)           | Show each call in console |     true      | true, false     |
| logFile (-l)           | Log file                  |     null      | log file name   |
| ssl (-s)               | SSL Mode                  |     false     | true, false     |
| certificateChain (-c)  | Certificate Chain         |     null      | valid file name |
| serverKey (-k)         | Server Key                |     null      | valid file name |
| serverKeyPassword (-u) | Server Key Password       |     null      | password        |

For example:

```dart
void main(List<String> args) {
  var server = FileHeronServer();
  ServerParams params = ServerParams(args);
  server.initStaticServer(params);
  server.start();
}
```

and the commandline arguments could be passed as follows:

```dart
fileheron --host localhost --port 8080 --root public --listDir true --logFile log.txt --ssl true --certificateChain server_chain.pem --serverKey server_key.pem --serverKeyPassword password
```

or

```dart
fileheron -h localhost -p 8080 -r public -d true -l log.txt -s true -c server_chain.pem -k server_key.pem -u password
```

## To be done

The SSL does not work at the moment. We are working on it, community is also welcome to support the project.

## Additional information

To contribute to this opensource project, open pull requests or issues in [git repo](https://github.com/horizech/fileheron_server)
