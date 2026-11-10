import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'payment_screen.dart'; // <-- L'import important !

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<dynamic>> futureCart;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  void loadCart() {
    setState(() {
      futureCart = ApiService.getCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Panier')),
      body: FutureBuilder<List<dynamic>>(
        future: futureCart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Votre panier est vide'));
          }

          final cartItems = snapshot.data!;
          // On ne garde que les articles qui n'ont pas encore été payés
          final activeItems = cartItems.where((item) => item['statues'] != 'paye').toList();

          if (activeItems.isEmpty) {
             return const Center(child: Text('Tous vos articles ont été payés.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: activeItems.length,
                  itemBuilder: (context, index) {
                    final item = activeItems[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.shopping_bag, color: Colors.orange),
                        title: Text(item['titre'] ?? 'Article'),
                        subtitle: Text('${item['prix_total']} €'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await ApiService.supprimerPanier(item['documentId']);
                              if (!mounted) return;
                              loadCart();
                            } catch (error) {
                              if (!mounted) return;
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Impossible de supprimer l’article : $error')),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Bouton pour aller vers l'écran de paiement
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(cartItems: activeItems),
                        ),
                      );
                    },
                    child: const Text('Passer au paiement', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}