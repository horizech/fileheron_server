import 'dart:io';

import '../helpers/get_it.dart';
import '../models/server_params.dart';
import '../services/log.dart';

class RestServer {
  late HttpServer _server;
  late ServerParams _params;

  void init(ServerParams params) {
    _params = params;
  }

  void start() async {
    try {
      _server = await HttpServer.bind(_params.hostname, _params.port);
    } catch (e) {
      print(
          'Error occured while starting server. Make sure the parameters are valid!');
      // 64: command line usage error
      exitCode = 64;
      exit(exitCode);
    } finally {
      print(
          'Serving ${_params.root} at http://${_server.address.host}:${_server.port}');
      await for (HttpRequest request in _server) {
        serveRequest(request);
      }
    }
  }

  void stop() {
    _server.close();
  }

  void serveRequest(HttpRequest request) async {
    if (_params.listDir) {
      print('Serving | Method: ${request.method} | Path: ${request.uri.path}');
    }

    getIt
        .get<LogService>()
        .log('Method: ${request.method} | Path: ${request.uri.path}');

    var response = request.response;
    response.write('Hello, world!');
    // response.statusCode = HttpStatus.ok;
    await response.close();
  }
}
