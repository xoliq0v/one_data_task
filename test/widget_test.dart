import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:one_data_task/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the start tracking button, verify tracking starts',
            (WidgetTester tester) async {
          app.main();
          await tester.pumpAndSettle();

          expect(find.text('Start Tracking'), findsOneWidget);

          await tester.tap(find.text('Start Tracking'));
          await tester.pumpAndSettle();

          expect(find.text('Stop Tracking'), findsOneWidget);

        });
  });
}