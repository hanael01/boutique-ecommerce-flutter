# 🛒 Application E-Commerce Flutter

Ce projet est une application e-commerce Flutter connectée à un backend headless Strapi v5.
Le parcours de paiement est une simulation : aucun paiement réel ni commande payée n'est créé.

## 🚀 Fonctionnalités implémentées
- **Boutique Strapi** ;
- **Application** : Liste des produits avec image, nom et leurs prix.
- **Détail** : Écran détail, gestion du chargement.
- **Panier** : Panier d'achat fonctionnel.
- **Architecture propre** : Modèle, service et écrans séparés.

---

## 💻 Commandes de lancement

Le backend Strapi hébergé sur Render est utilisé par défaut. Depuis la racine du projet :

    flutter pub get
    flutter run -d chrome

Pour utiliser un autre backend, indiquez son adresse sans `/api` :

    flutter run -d chrome --dart-define=STRAPI_URL=http://localhost:1337

Sur un appareil Android, `localhost` désigne l'appareil lui-même ; utilisez une adresse accessible depuis celui-ci. Le backend doit autoriser les requêtes de l'origine Flutter Web via CORS.

---

## 📸 Captures d'écran du Tunnel d'Achat

### 1. Catalogue des produits
![Catalogue](catalog.png)

### 2. Fiche Détail d'un produit
![Détail Produit](fiche_detail.png)

### 3. Panier d'achat
![Panier](Panier_achats.png)

### 4. Écran de Paiement
![Paiement](ecran_de_payement.png)

### 5. Confirmation de Commande
![Commande Validée](confirmation_commande.png)
