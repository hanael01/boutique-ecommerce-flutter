import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/models/produit.dart';

void main() {
  final backend = Uri.parse('https://strapi-backend-13ae.onrender.com');

  test('resolves relative Strapi images against the backend origin', () {
    final produit = Produit.fromJson({
      'title': 'Produit',
      'Prix': 12.5,
      'image': {'url': '/uploads/image.png'},
    }, backendUrl: backend);

    expect(produit.title, 'Produit');
    expect(produit.price, 12.5);
    expect(
      produit.imageUrl,
      'https://strapi-backend-13ae.onrender.com/uploads/image.png',
    );
  });

  test('preserves external images and accepts image lists', () {
    final produit = Produit.fromJson({
      'images': [
        {'url': 'https://images.example.com/photo.jpg'},
      ],
    }, backendUrl: backend);

    expect(produit.imageUrl, 'https://images.example.com/photo.jpg');
  });

  test('keeps an absent image empty', () {
    final produit = Produit.fromJson({}, backendUrl: backend);
    expect(produit.imageUrl, isEmpty);
  });

  test('resolves images against a different configured backend', () {
    final produit = Produit.fromJson({
      'image': {'url': '/uploads/photo.jpg'},
    }, backendUrl: Uri.parse('http://localhost:1337'));

    expect(produit.imageUrl, 'http://localhost:1337/uploads/photo.jpg');
  });
}
