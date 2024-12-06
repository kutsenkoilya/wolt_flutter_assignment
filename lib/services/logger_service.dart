import 'package:logging/logging.dart';

class LoggerService {
  final Logger _logger;

  LoggerService(String name) : _logger = Logger(name);

  void log(Level level, String message, {Object? error, StackTrace? stackTrace}) {
    _logger.log(level, message, error, stackTrace);
  }

  void info(String message) => log(Level.INFO, message);
  void warning(String message) => log(Level.WARNING, message);
  void error(String message, {Object? error, StackTrace? stackTrace}) =>
      log(Level.SEVERE, message, error: error, stackTrace: stackTrace);
}