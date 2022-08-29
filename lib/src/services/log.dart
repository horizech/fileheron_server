import 'dart:io';

class LogService {
  final String? _logFile;
  LogService(this._logFile) {
    _init();
  }

  void _init() async {
    if (_logFile != null) {
      var logFile = File(_logFile!);
      var logFileExists = await logFile.exists();

      if (!logFileExists) {
        logFile.createSync();
      }
    }
  }

  void log(String data) {
    if (_logFile != null) {
      var logFile = File(_logFile!);
      logFile.writeAsStringSync(
          'DateTime: ${(DateTime.now()).toString()} | $data\n',
          mode: FileMode.append);
    }
  }
}
