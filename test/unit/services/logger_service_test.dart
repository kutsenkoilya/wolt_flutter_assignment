import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:wolt_flutter_assignment/services/logger_service.dart';

void main() {
  group('LoggerService', () {
    late LoggerService loggerService;
    late Logger logger;

    setUp(() {
      logger = Logger('TestLogger');
      loggerService = LoggerService('TestLogger');
    });

    test('info method logs an info message', () {
      final logRecords = <LogRecord>[];
      final subscription = logger.onRecord.listen(logRecords.add);

      loggerService.info('This is an info message');

      expect(logRecords, hasLength(1));
      expect(logRecords.first.level, Level.INFO);
      expect(logRecords.first.message, 'This is an info message');

      subscription.cancel();
    });

    test('warning method logs a warning message', () {
      final logRecords = <LogRecord>[];
      final subscription = logger.onRecord.listen(logRecords.add);

      loggerService.warning('This is a warning message');

      expect(logRecords, hasLength(1));
      expect(logRecords.first.level, Level.WARNING);
      expect(logRecords.first.message, 'This is a warning message');

      subscription.cancel();
    });

    test('error method logs an error message', () {
      final logRecords = <LogRecord>[];
      final subscription = logger.onRecord.listen(logRecords.add);

      final error = Exception('Test exception');
      final stackTrace = StackTrace.current;

      loggerService.error('This is an error message', error: error, stackTrace: stackTrace);

      expect(logRecords, hasLength(1));
      expect(logRecords.first.level, Level.SEVERE);
      expect(logRecords.first.message, 'This is an error message');
      expect(logRecords.first.error, error);
      expect(logRecords.first.stackTrace, stackTrace);

      subscription.cancel();
    });
  });
}