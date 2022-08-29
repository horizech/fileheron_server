import 'package:fileheron_server/fileheron_server.dart';

void main(List<String> args) {
  var server = FileHeronServer();
  ServerParams params = ServerParams.fromArgs(args);
  server.initStaticServer(params);
  server.start();
}
