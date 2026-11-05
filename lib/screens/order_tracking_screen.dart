import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderTrackingScreen extends StatefulWidget {
  final List<dynamic> cartItems;

  const OrderTrackingScreen({super.key, required this.cartItems});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  bool isProcessing = true;

  @override
  void initState() {
    super.initState();
    _processOrder();
  }

  Future<void> _processOrder() async {
    for (var item in widget.cartItems) {
      final documentId = item['documentId'];
      if (documentId != null) {
        try {
          await http.put(
            Uri.parse('http://localhost:1337/api/paniers/$documentId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'data': {'statues': 'paye'}}),
          );
        } catch (e) {
          debugPrint('Erreur : $e');
        }
      }
    }
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suivi de commande'), automaticallyImplyLeading: false),
      body: Center(
        child: isProcessing
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Validation de votre paiement...', style: TextStyle(fontSize: 18)),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 100),
                  const SizedBox(height: 20),
                  const Text('Paiement accepté !', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Votre commande est en cours de préparation.', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    child: const Text('Retour au catalogue'),
                  ),
                ],
              ),
      ),
    );
  }
}