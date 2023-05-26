import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseCrash {
  FirebaseCrash._();
  static FirebaseCrash instant = FirebaseCrash._();

  sendFatalCrashError({
    required String message,
    dynamic exception,
    StackTrace? stack,
    String? log,
  }) async {
    await FirebaseCrashlytics.instance.recordError(exception, stack,
        reason: message,
        // Pass in 'fatal' argument
        fatal: true);
    if (log != null && log.isNotEmpty == true) {
      FirebaseCrashlytics.instance.log(log);
    }
  }

  sendNonFatalError({
    required String message,
    dynamic exception,
    StackTrace? stack,
    String? log,
  }) async {
    await FirebaseCrashlytics.instance
        .recordError(exception, stack, reason: message);
    if (log != null && log.isNotEmpty == true) {
      FirebaseCrashlytics.instance.log(log);
    }
  }
}
