import 'package:flutter_test/flutter_test.dart';
import 'package:speedpulse/main.dart'; // Import your main app file

void main() {
  testWidgets('Speed Test App UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SpeedPulseApp());

    // Verify that the 'Run Speed Test' button is present
    expect(find.text('Start Speed Test'), findsOneWidget);

    // Verify that the download speed is not displayed initially
    expect(find.textContaining('Mbps'), findsNothing);

    // Tap the 'Start Speed Test' button
    await tester.tap(find.text('Start Speed Test'));
    await tester.pump(); // Rebuild the widget after the tap

    // Wait for any asynchronous animations or UI updates to complete
    await tester.pumpAndSettle();

    // Ensure that the speed test has started, check if any speed is displayed
    expect(find.textContaining('Mbps'), findsOneWidget);
  });
}
