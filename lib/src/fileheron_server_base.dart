/// Checks if you are awesome. Spoiler: you are.
import 'dart:io';

import 'package:fileheron_server/src/constants.dart';

import 'helpers/get_it.dart';
import 'models/server_params.dart';
import 'servers/rest.dart';
import 'servers/static.dart';

class FileHeronServer {
  final StaticServer _staticServer = StaticServer();
  final RestServer _restServer = RestServer();

  late ServerParams _params;
  ServerParams get params => _params;

  // For future, we might have static as well as rest type server
  var _serverType = kDefaultServerType;
  String get serverType => _serverType;

  void initStaticServer(ServerParams params) {
    _params = params;
    setupGetIt(_params.logFile);
    _serverType = 'static';
    _staticServer.init(_params);
  }

  void initRestServer(ServerParams params) {
    _params = params;
    setupGetIt(_params.logFile);
    _serverType = 'rest';
    _restServer.init(_params);
  }

  void start() {
    if (_serverType == 'static') {
      _staticServer.start();
    } else if (_serverType == 'rest') {
      _restServer.start();
    } else {
      print('No other Server type supported yet!');
      exit(1);
    }
  }
}
