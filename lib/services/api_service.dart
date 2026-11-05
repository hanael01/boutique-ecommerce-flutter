import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produit.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:1337/api';

  // 1. Récupérer les produits
  static Future<List<Produit>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/produits?populate=*'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List rawList = data['data'];
      return rawList.map((item) => Produit.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }

  // 2. Ajouter au panier (POST)
  static Future<void> ajouterAuPanier(String titre, double prix) async {
    await http.post(
      Uri.parse('$baseUrl/paniers'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'data': {
          'titre': titre,
          'qte': 1,
          'statues': 'en_cours',
          'prix_total': prix,
        }
      }),
    );
  }

  // 3. Récupérer le panier
  static Future<List<dynamic>> getCartItems() async {
    final response = await http.get(Uri.parse('$baseUrl/paniers'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    }
    return [];
  }

  // 4. Supprimer du panier (DELETE avec documentId)
  static Future<void> supprimerPanier(String documentId) async {
    await http.delete(Uri.parse('$baseUrl/paniers/$documentId'));
  }
}