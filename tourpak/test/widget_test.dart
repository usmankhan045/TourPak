import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tourpak/main.dart';

void main() {
  testWidgets('TourPakApp renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: TourPakApp()),
    );
    await tester.pumpAndSettle();
    // App should render without crashing
    expect(find.byType(TourPakApp), findsOneWidget);
  });
}
