import 'package:flutter_test/flutter_test.dart';
import 'package:ujian/main.dart';

void main() {
  testWidgets('Synonym Quiz App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SynonymQuizApp());
    expect(find.text('Synonym Quiz'), findsOneWidget);
  });
}
