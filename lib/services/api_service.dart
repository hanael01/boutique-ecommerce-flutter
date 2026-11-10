import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/produit.dart';
import 'strapi_config.dart';

class ApiService {
  static Uri _endpoint(String path) => StrapiConfig.api.resolve(path);

  static void _checkResponse(http.Response response, String action) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('$action (HTTP ${response.statusCode})');
    }
  }

  // 1. Récupérer les produits
  static Future<List<Produit>> getProducts() async {
    final response = await http.get(_endpoint('produits?populate=*'));
    _checkResponse(response, 'Erreur lors du chargement des produits');
    final data = json.decode(response.body);
    final List<dynamic> rawList = data['data'];
    return rawList
        .map((item) => Produit.fromJson(item, backendUrl: StrapiConfig.origin))
        .toList();
  }

  // 2. Ajouter au panier (POST)
  static Future<void> ajouterAuPanier(String titre, double prix) async {
    final response = await http.post(
      _endpoint('paniers'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'data': {
          'titre': titre,
          'qte': 1,
          'statues': 'en_cours',
          'prix_total': prix,
        },
      }),
    );
    _checkResponse(response, 'Erreur lors de l’ajout au panier');
  }

  // 3. Récupérer le panier
  static Future<List<dynamic>> getCartItems() async {
    final response = await http.get(_endpoint('paniers'));
    _checkResponse(response, 'Erreur lors du chargement du panier');
    final data = json.decode(response.body);
    return data['data'];
  }

  // 4. Supprimer du panier (DELETE avec documentId)
  static Future<void> supprimerPanier(String documentId) async {
    final response = await http.delete(_endpoint('paniers/$documentId'));
    _checkResponse(response, 'Erreur lors de la suppression du panier');
  }
}
