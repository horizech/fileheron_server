import 'dart:io';

import 'package:fileheron_server/src/constants.dart';

import 'models/server_params.dart';
import 'servers/rest.dart';
import 'servers/static.dart';

/// FileHeron Local server
class FileHeronServer {
  /// Static server
  final StaticServer _staticServer = StaticServer();

  /// Rest server (not much useful at the moment)
  final RestServer _restServer = RestServer();

  /// Server parameters
  late ServerParams _params;

  /// Get server parameters
  ServerParams get params => _params;

  /// Server type (Static or Rest)
  var _serverType = kDefaultServerType;

  /// Get server type  (Static or Rest)
  String get serverType => _serverType;

  /// Initialize Static server using server parameters
  void initStaticServer(ServerParams params) {
    _params = params;
    _serverType = 'static';
    _staticServer.init(_params);
  }

  /// Initialize Rest server using server parameters
  void initRestServer(ServerParams params) {
    _params = params;
    _serverType = 'rest';
    _restServer.init(_params);
  }

  /// Start server
  void start() {
    if (_serverType == 'static') {
      _staticServer.start();
    } else if (_serverType == 'rest') {
      _restServer.start();
    } else {
      stdout.writeln('No other Server type supported yet!');
    }
  }

  /// Stop running server
  void stop() {
    if (_serverType == 'static') {
      _staticServer.stop();
    } else if (_serverType == 'rest') {
      _restServer.stop();
    } else {
      stdout.writeln('No other Server type supported yet!');
    }
  }
}
