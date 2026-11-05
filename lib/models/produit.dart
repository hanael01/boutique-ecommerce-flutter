class Produit {
  final String documentId;
  final String title;
  final double price;
  final String imageUrl;
  final String description; // <-- Nouveau champ ajouté

  Produit({
    required this.documentId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description, // <-- Nouveau champ ajouté
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    // Récupération du prix
    var rawPrice = json['Prix'] ?? json['price'] ?? json['prix'] ?? 0;
    double parsedPrice = 0.0;
    if (rawPrice != null) {
      parsedPrice = double.tryParse(rawPrice.toString()) ?? 0.0;
    }

    // Récupération de l'image
    String imgUrl = '';
    var imgField = json['image'] ?? json['images'];
    if (imgField != null) {
      if (imgField is Map && imgField['url'] != null) {
        imgUrl = imgField['url'];
      } else if (imgField is List && imgField.isNotEmpty) {
        if (imgField[0] is Map && imgField[0]['url'] != null) {
          imgUrl = imgField[0]['url'];
        }
      }
    }

    if (imgUrl.startsWith('/')) {
      imgUrl = 'http://localhost:1337$imgUrl';
    }

    return Produit(
      documentId: json['documentId'] ?? '',
      title: json['title'] ?? 'Sans titre',
      price: parsedPrice,
      imageUrl: imgUrl,
      // On récupère la description, ou on met un texte par défaut si elle est vide
      description: json['description'] ?? 'Aucune description disponible pour ce produit.',
    );
  }
}