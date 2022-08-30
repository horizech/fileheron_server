import 'dart:io';

import 'package:http_server/http_server.dart';

import '../services/log.dart';
import '../models/server_params.dart';

class StaticServer {
  late VirtualDirectory _staticFiles;
  late ServerParams _params;
  late HttpServer _server;
  LogService? logService;

  void init(ServerParams params) {
    _params = params;
    _staticFiles = VirtualDirectory(params.root);
    _staticFiles.allowDirectoryListing = true; /*1*/
    _staticFiles.directoryHandler = (dir, request) /*2*/ {
      var indexUri = Uri.file(dir.path).resolve('index.html');
      if (params.listDir) {
        stdout.writeln('Sending: $indexUri');
      }
      _staticFiles.serveFile(File(indexUri.toFilePath()), request); /*3*/
    };

    if (params.logFile != null && params.logFile!.isNotEmpty) {
      logService = LogService(_params.logFile!);
    }
  }

  Future<bool> start() async {
    try {
      if (_params.ssl) {
        if (_params.certificateChain == null ||
            _params.certificateChain!.isEmpty) {
          stdout.writeln('Could not find certificate chain.');
          return false;
        }

        if (_params.serverKey == null || _params.serverKey!.isEmpty) {
          stdout.writeln('Could not find server key.');
          return false;
        }

        var chain =
            Platform.script.resolve(_params.certificateChain!).toFilePath();
        var key = Platform.script.resolve(_params.serverKey!).toFilePath();
        var serverContext = SecurityContext()..useCertificateChain(chain);

        if (_params.serverKeyPassword != null &&
            _params.serverKeyPassword!.isNotEmpty) {
          serverContext.usePrivateKey(key, password: _params.serverKeyPassword);
        } else {
          serverContext.usePrivateKey(key);
        }

        _server = await HttpServer.bindSecure(
            _params.hostname, _params.port, serverContext);
      } else {
        _server = await HttpServer.bind(_params.hostname, _params.port);
      }
    } catch (e) {
      stdout.writeln(
          'Error occured while starting server. Make sure the parameters are valid!');
    } finally {
      stdout.writeln(
          'Serving ${_params.root} at ${_params.ssl ? "https" : "http"}://${_server.address.host}:${_server.port}');

      await _server.forEach(serveRequest);
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
      stdout.writeln('Sending: ${_params.root}${request.uri.toString()}');
    }

    if (logService != null) {
      logService!.log('Method: ${request.method} | Path: ${request.uri.path}');
    }

    await _staticFiles.serveRequest(request);
  }
}
