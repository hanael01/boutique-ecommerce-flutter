import 'package:flutter/material.dart';
import 'order_tracking_screen.dart';

class PaymentScreen extends StatelessWidget {
  final List<dynamic> cartItems;

  const PaymentScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (var item in cartItems) {
      var prix = item['prix_total'] ?? 0;
      total += (prix is num) ? prix.toDouble() : double.tryParse(prix.toString()) ?? 0.0;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Paiement sécurisé')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Récapitulatif de la commande', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Nombre d\'articles : ${cartItems.length}', style: const TextStyle(fontSize: 16)),
            Text('Total à payer : ${total.toStringAsFixed(2)} €', 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 30),
            const Text('Moyen de paiement', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.credit_card, size: 40, color: Colors.blue[900]),
                const SizedBox(width: 10),
                const Text('Visa / MasterCard', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 15),
            const TextField(
              decoration: InputDecoration(labelText: 'Numéro de carte', border: OutlineInputBorder(), prefixIcon: Icon(Icons.payment)),
              keyboardType: TextInputType.number,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OrderTrackingScreen(cartItems: cartItems)),
                  );
                },
                child: Text('Payer ${total.toStringAsFixed(2)} €', style: const TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}