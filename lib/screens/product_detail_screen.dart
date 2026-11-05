import 'package:flutter/material.dart';
import '../models/produit.dart';
import '../services/api_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final Produit produit;

  const ProductDetailScreen({super.key, required this.produit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(produit.title),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Grande Image en haut
          SizedBox(
            height: 300,
            width: double.infinity,
            child: produit.imageUrl.isNotEmpty
                ? Image.network(produit.imageUrl, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100))
                : const Icon(Icons.shopping_bag, size: 100),
          ),
          // Contenu du détail
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          produit.title,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '${produit.price.toStringAsFixed(2)} €',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        produit.description,
                        style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                      ),
                    ),
                  ),
                  // Bouton d'ajout au panier
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Ajouter au panier', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        await ApiService.ajouterAuPanier(produit.title, produit.price);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('"${produit.title}" ajouté avec succès !'), backgroundColor: Colors.green),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}