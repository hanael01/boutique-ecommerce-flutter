import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  final List<dynamic> cartItems;

  const OrderTrackingScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi de commande'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.deepPurple,
                size: 88,
              ),
              const SizedBox(height: 20),
              const Text(
                'Simulation terminée',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Aucun paiement réel n’a été effectué. '
                'Votre panier (${cartItems.length} article(s)) n’a pas été modifié.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Retour au catalogue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
