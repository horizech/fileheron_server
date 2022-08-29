import 'dart:io';

import 'package:args/args.dart';
import 'package:fileheron_server/src/constants.dart';

class ServerParams {
  final String hostname;
  final int port;
  final String root;
  final String? logFile;
  final bool listDir;
  final bool ssl;
  final String? certificateChain;
  final String? serverKey;
  final String? serverKeyPassword;

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

  factory ServerParams.fromArgs(List<String> args) {
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
          "$kDefaultPort"; // ?? Platform.environment['PORT'] ?? '8080';
      int p = 0;

      try {
        p = int.tryParse(pStr) ?? kDefaultPort;
      } catch (_) {
        stdout.writeln('Could not parse port value "$pStr" into a number.');
        exitCode = 64;
        exit(exitCode);
      }

      if (p < 1) {
        stdout.writeln('Could not parse port value "$pStr" into a number.');
        // 64: command line usage error
        exitCode = 64;
        exit(exitCode);
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

      if (s) {
        c = result['certificateChain'] ?? "";
        k = result['serverKey'] ?? "";
        u = result['serverKeyPassword'] ?? "";

        if (c.isEmpty) {
          stdout.writeln('Could not find certificate chain.');
          // 64: command line usage error
          exitCode = 64;
          exit(exitCode);
        }

        if (k.isEmpty) {
          stdout.writeln('Could not find server key.');
          // 64: command line usage error
          exitCode = 64;
          exit(exitCode);
        }
      }

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

  void printParams() {
    print('Hostname: ${hostname.toString()}');
    print('Port: ${port.toString()}');
    print('Root Dir: ${root.toString()}');
    print('Log File: ${logFile.toString()}');
    print('List Dir: ${listDir.toString()}');

    print('SSL: ${ssl.toString()}');
    print('Certificate Chain: ${certificateChain.toString()}');
    print('Server Key: ${serverKey.toString()}');
    print('Server Key Password: ${serverKeyPassword.toString()}');
  }
}
