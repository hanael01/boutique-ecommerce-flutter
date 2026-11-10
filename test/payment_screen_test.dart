import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/screens/payment_screen.dart';

void main() {
  testWidgets('requires valid card details before continuing', (tester) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: PaymentScreen(cartItems: [])),
    );

    await tester.tap(find.byKey(const Key('confirm-payment')));
    await tester.pumpAndSettle();

    expect(find.text('Saisissez le nom du titulaire.'), findsOneWidget);
    expect(find.text('Entrez un numéro de carte valide.'), findsOneWidget);
    expect(find.text('Utilisez le format MM/AA.'), findsOneWidget);
    expect(find.text('Entrez 3 ou 4 chiffres.'), findsOneWidget);
    expect(find.text('Simulation terminée'), findsNothing);
  });

  testWidgets('valid card details continue to the disclosed simulation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: PaymentScreen(
          cartItems: [
            {'titre': 'Article de démonstration', 'prix_total': 12.5},
          ],
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('cardholder-name')),
      'Test Client',
    );
    await tester.enterText(
      find.byKey(const Key('card-number')),
      '4242424242424242',
    );
    await tester.enterText(find.byKey(const Key('card-expiry')), '1299');
    await tester.enterText(find.byKey(const Key('card-cvc')), '123');
    await tester.ensureVisible(find.byKey(const Key('confirm-payment')));
    await tester.tap(find.byKey(const Key('confirm-payment')));
    await tester.pumpAndSettle();

    expect(find.text('Simulation terminée'), findsOneWidget);
    expect(
      find.textContaining('Aucun paiement réel n’a été effectué.'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Votre panier (1 article(s)) n’a pas été modifié.'),
      findsOneWidget,
    );
  });
}
