import 'package:flutter_test/flutter_test.dart';
import 'package:staff_web/main.dart';
import 'package:staff_web/pages/login.dart';

void main() {
  testWidgets('App starts on the login page', (WidgetTester tester) async {
    await tester.pumpWidget(const FitpassApp());
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
