import 'package:fileheron_server/fileheron_server.dart';
import 'package:fileheron_server/src/models/server_params.dart';

void main(List<String> args) {
  var server = FileHeronServer();
  ServerParams params = ServerParams(args);
  server.initStaticServer(params);
  server.start();
}
