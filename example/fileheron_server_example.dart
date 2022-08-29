import 'package:fileheron_server/fileheron_server.dart';

/// Simple example using parameters
void exampleUsingParameters() {
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

// Simple example using args. Please see arguments Parameters in Readme to learn more
void exampleUsingArgs(List<String> args) {
  var server = FileHeronServer();
  ServerParams params = ServerParams.fromArgs(args);
  server.initStaticServer(params);
  server.start();
}
