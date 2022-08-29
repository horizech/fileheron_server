import 'package:get_it/get_it.dart';
import '../services/log.dart';

final getIt = GetIt.instance;

void setupGetIt(String logFile) {
  getIt.registerSingleton<LogService>(LogService(logFile));
}
