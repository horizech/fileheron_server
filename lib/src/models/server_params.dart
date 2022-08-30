import 'dart:io';

import 'package:args/args.dart';
import 'package:fileheron_server/src/constants.dart';

/// Server parameters
class ServerParams {
  /// Hostname e.g. localhost, domain.com. Default value: localhsot
  final String hostname;

  /// Port e.g. 8080, 443. Default value: 80
  final int port;

  /// Path to use for server root. Default value: public
  final String root;

  /// path to log file. Default value: null
  final String? logFile;

  /// Should list each request directory path. Default value: false
  final bool listDir;

  /// Enable SSL. Default value: false
  final bool ssl;

  /// Certificate chain. Default value: null
  final String? certificateChain;

  /// Certificate key. Default value: null
  final String? serverKey;

  /// Certificate password. Default value: null
  final String? serverKeyPassword;

  /// Constructor
  ServerParams(
      {this.hostname = kDefaultHost,
      this.port = kDefaultPort,
      this.root = kDefaultRoot,
      this.logFile = kDefaultLogFile,
      this.listDir = kDefaultListDir,
      this.ssl = kDefaultSSL,
      this.certificateChain = kDefaultCertificateChain,
      this.serverKey = kDefaultServerKey,
      this.serverKeyPassword = kDefaultServerKeyPassword});

  /// Use the args from commandline to create ServerParams directly without having to parse first.
  /// Read the documentation to learn more about how to use the commandline arguments
  factory ServerParams.fromArgs(List<String> args) {
    // Make sure the arguments are not empty
    if (args.isNotEmpty) {
      var parser = ArgParser()
        ..addOption('host', abbr: 'h', defaultsTo: kDefaultHost)
        ..addOption('port', abbr: 'p', defaultsTo: '$kDefaultPort')
        ..addOption('root', abbr: 'r', defaultsTo: kDefaultRoot)
        ..addOption('logFile', abbr: 'l', defaultsTo: kDefaultLogFile)
        ..addOption('listDir', abbr: 'd', defaultsTo: '$kDefaultListDir')
        ..addOption('ssl', abbr: 's', defaultsTo: '$kDefaultSSL')
        ..addOption('certificateChain',
            abbr: 'c', defaultsTo: kDefaultCertificateChain)
        ..addOption('serverKey', abbr: 'k', defaultsTo: kDefaultServerKey)
        ..addOption('serverKeyPassword',
            abbr: 'u', defaultsTo: kDefaultServerKeyPassword);
      var result = parser.parse(args);

      String h = result['host'];

      // For Google Cloud Run, we respect the PORT environment variable
      String pStr = result['port'] ??
          "$kDefaultPort"; // ?? Platform.environment['PORT'] ?? '80';
      int p = 0;

      try {
        p = int.tryParse(pStr) ?? kDefaultPort;
      } catch (_) {
        stdout.writeln('Could not parse port value "$pStr" into a number.');
      }

      if (p < 1) {
        stdout.writeln('Could not parse port value "$pStr" into a number.');
      }

      String r = result['root'];

      String listDirStr = result['listDir'];
      bool d = listDirStr.toLowerCase() == 'true';

      String l = result['logFile'];

      String sslStr = result['ssl'];
      bool s = sslStr.toLowerCase() == 'true';

      String c = "";
      String k = "";
      String u = "";

      // Check if SSL is enabled
      if (s) {
        c = result['certificateChain'] ?? "";
        k = result['serverKey'] ?? "";
        u = result['serverKeyPassword'] ?? "";

        if (c.isEmpty) {
          stdout.writeln('Could not find certificate chain.');
        }

        if (k.isEmpty) {
          stdout.writeln('Could not find server key.');
        }
      }

      // Generate ServerParams
      ServerParams params = ServerParams(
          hostname: h,
          port: p,
          root: r,
          logFile: l,
          listDir: d,
          ssl: s,
          certificateChain: c,
          serverKey: k,
          serverKeyPassword: u);

      return params;
    }
    return ServerParams();
  }

  /// Print all params
  void printParams() {
    stdout.writeln('Hostname: ${hostname.toString()}');
    stdout.writeln('Port: ${port.toString()}');
    stdout.writeln('Root Dir: ${root.toString()}');
    stdout.writeln('Log File: ${logFile.toString()}');
    stdout.writeln('List Dir: ${listDir.toString()}');

    stdout.writeln('SSL: ${ssl.toString()}');
    stdout.writeln('Certificate Chain: ${certificateChain.toString()}');
    stdout.writeln('Server Key: ${serverKey.toString()}');
    stdout.writeln('Server Key Password: ${serverKeyPassword.toString()}');
  }
}
