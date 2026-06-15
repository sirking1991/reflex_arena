import 'package:flutter_test/flutter_test.dart';
import 'package:reflex_arena/main.dart';
import 'package:reflex_arena/widgets/player_zone.dart';
import 'package:reflex_arena/widgets/central_target.dart';

void main() {
  testWidgets('Reflex Arena smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ReflexArenaApp());

    // Verify we are on the MenuScreen (shows CHOOSE GAME MODE)
    expect(find.text('CHOOSE GAME MODE'), findsOneWidget);

    // Tap on Classic mode card to enter GameScreen
    await tester.tap(find.text('CLASSIC REFLEX'));
    await tester.pumpAndSettle();

    // Verify player zones are rendered
    expect(find.byType(PlayerZone), findsNWidgets(2));
    
    // Verify central target is rendered
    expect(find.byType(CentralTarget), findsOneWidget);

    // Verify initial scores are 0
    expect(find.text('0'), findsNWidgets(2));
  });
}
