import 'dart:io';

import '../models/server_params.dart';
import '../services/log.dart';

class RestServer {
  late HttpServer _server;
  late ServerParams _params;
  LogService? logService;

  void init(ServerParams params) {
    _params = params;
    if (params.logFile != null && params.logFile!.isNotEmpty) {
      logService = LogService(_params.logFile!);
    }
  }

  Future<bool> start() async {
    try {
      _server = await HttpServer.bind(_params.hostname, _params.port);
    } catch (e) {
      stdout.writeln(
          'Error occured while starting server. Make sure the parameters are valid!');
      return false;
    } finally {
      stdout.writeln(
          'Serving ${_params.root} at http://${_server.address.host}:${_server.port}');
      await for (HttpRequest request in _server) {
        serveRequest(request);
      }
    }
    return true;
  }

  Future<bool> stop() async {
    try {
      await _server.close(force: true);
      return true;
    } catch (_) {
      return false;
    }
  }

  void serveRequest(HttpRequest request) async {
    if (_params.listDir) {
      stdout.writeln(
          'Serving | Method: ${request.method} | Path: ${request.uri.path}');
    }

    if (logService != null) {
      logService!.log('Method: ${request.method} | Path: ${request.uri.path}');
    }

    var response = request.response;
    response.write('Hello, world!');
    // response.statusCode = HttpStatus.ok;
    await response.close();
  }
}
