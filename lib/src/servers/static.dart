import 'dart:io';

import 'package:http_server/http_server.dart';

import '../helpers/get_it.dart';
import '../services/log.dart';
import '../models/server_params.dart';

class StaticServer {
  late VirtualDirectory _staticFiles;
  late ServerParams _params;
  late HttpServer _server;

  void init(ServerParams params) {
    _params = params;
    _staticFiles = VirtualDirectory(params.root);
    _staticFiles.allowDirectoryListing = true; /*1*/
    _staticFiles.directoryHandler = (dir, request) /*2*/ {
      var indexUri = Uri.file(dir.path).resolve('index.html');
      if (params.listDir) {
        print('Sending: $indexUri');
      }
      _staticFiles.serveFile(File(indexUri.toFilePath()), request); /*3*/
    };
  }

  void start() async {
    try {
      if (_params.ssl) {
        var serverContext = SecurityContext();
        if (_params.certificateChain == null ||
            _params.certificateChain!.isEmpty) {
          stdout.writeln('Could not find certificate chain.');
          // 64: command line usage error
          exitCode = 64;
          exit(exitCode);
        }

        if ((_params.serverKeyPassword == null ||
                _params.serverKeyPassword!.isEmpty) &&
            (_params.serverKey == null || _params.serverKey!.isEmpty)) {
          stdout.writeln('Could not find server key or password.');
          // 64: command line usage error
          exitCode = 64;
          exit(exitCode);
        }

        serverContext.useCertificateChain(_params.certificateChain!);
        if (_params.serverKeyPassword != null &&
            _params.serverKeyPassword!.isNotEmpty) {
          serverContext.usePrivateKey(_params.serverKey!,
              password: _params.serverKeyPassword);
        } else {
          serverContext.usePrivateKey(_params.serverKey!);
        }
        _server = await HttpServer.bindSecure(
            _params.hostname, _params.port, serverContext);
      } else {
        _server = await HttpServer.bind(_params.hostname, _params.port);
      }
    } catch (e) {
      print(
          'Error occured while starting server. Make sure the parameters are valid!');
      // 64: command line usage error
      exitCode = 64;
      exit(exitCode);
    } finally {
      print(
          'Serving ${_params.root} at ${_params.ssl ? "https" : "http"}://${_server.address.host}:${_server.port}');

      // await _server.forEach(serveRequest); /*4*/
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
      print('Sending: ${_params.root}${request.uri.toString()}');
    }

    getIt
        .get<LogService>()
        .log('Address: ${_params.root}${request.uri.toString()}');

    await _staticFiles.serveRequest(request);
  }
}
