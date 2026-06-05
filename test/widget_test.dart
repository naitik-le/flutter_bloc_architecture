import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc_architecture/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Verify that the App widget can be instantiated.
    expect(const App(), isNotNull);
  });
}
