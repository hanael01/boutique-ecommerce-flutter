import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'order_tracking_screen.dart';

class PaymentScreen extends StatefulWidget {
  final List<dynamic> cartItems;

  const PaymentScreen({super.key, required this.cartItems});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  double get _total {
    return widget.cartItems.fold<double>(0, (total, item) {
      final price = item['prix_total'] ?? 0;
      return total +
          (price is num ? price.toDouble() : double.tryParse('$price') ?? 0);
    });
  }

  void _submitPayment() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderTrackingScreen(cartItems: widget.cartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiement')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Récapitulatif de la commande',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Nombre d’articles : ${widget.cartItems.length}'),
              const SizedBox(height: 4),
              Text(
                'Total : ${_total.toStringAsFixed(2)} €',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Carte bancaire',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('cardholder-name'),
                decoration: const InputDecoration(
                  labelText: 'Nom du titulaire',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Saisissez le nom du titulaire.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('card-number'),
                decoration: const InputDecoration(
                  labelText: 'Numéro de carte',
                  hintText: '1234 5678 9012 3456',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.creditCardNumber],
                inputFormatters: [_CardNumberFormatter()],
                textInputAction: TextInputAction.next,
                validator: _validateCardNumber,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('card-expiry'),
                      decoration: const InputDecoration(
                        labelText: 'Expiration',
                        hintText: 'MM/AA',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [_CardExpiryFormatter()],
                      textInputAction: TextInputAction.next,
                      validator: _validateExpiry,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      key: const Key('card-cvc'),
                      decoration: const InputDecoration(
                        labelText: 'Code de sécurité',
                        hintText: 'CVC',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      autofillHints: const [
                        AutofillHints.creditCardSecurityCode,
                      ],
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          value == null || !RegExp(r'^\d{3,4}$').hasMatch(value)
                          ? 'Entrez 3 ou 4 chiffres.'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.deepOrange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mode démonstration : aucun paiement réel ne sera effectué. '
                        'N’utilisez pas les données d’une vraie carte.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  key: const Key('confirm-payment'),
                  onPressed: _submitPayment,
                  child: Text(
                    'Continuer (${_total.toStringAsFixed(2)} €)',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateCardNumber(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length < 12 || digits.length > 19) {
      return 'Entrez un numéro de carte valide.';
    }

    var sum = 0;
    var doubleDigit = false;
    for (var index = digits.length - 1; index >= 0; index--) {
      var digit = int.parse(digits[index]);
      if (doubleDigit) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      doubleDigit = !doubleDigit;
    }
    return sum % 10 == 0 ? null : 'Vérifiez le numéro de carte.';
  }

  String? _validateExpiry(String? value) {
    final match = RegExp(r'^(0[1-9]|1[0-2])/(\d{2})$')
        .firstMatch(value?.trim() ?? '');
    if (match == null) return 'Utilisez le format MM/AA.';

    final month = int.parse(match.group(1)!);
    final year =
        (DateTime.now().year ~/ 100) * 100 + int.parse(match.group(2)!);
    final now = DateTime.now();
    if (year < now.year || (year == now.year && month < now.month)) {
      return 'Cette carte est expirée.';
    }
    return null;
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limitedDigits = digits.substring(
      0,
      digits.length > 19 ? 19 : digits.length,
    );
    final groups = <String>[];
    for (var index = 0; index < limitedDigits.length; index += 4) {
      groups.add(
        limitedDigits.substring(
          index,
          index + 4 > limitedDigits.length ? limitedDigits.length : index + 4,
        ),
      );
    }
    final text = groups.join(' ');
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limitedDigits = digits.substring(
      0,
      digits.length > 4 ? 4 : digits.length,
    );
    final text = limitedDigits.length > 2
        ? '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2)}'
        : limitedDigits;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
