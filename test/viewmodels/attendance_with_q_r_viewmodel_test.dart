import 'package:flutter_test/flutter_test.dart';
import 'package:quizapp/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('AttendanceWithQRViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
