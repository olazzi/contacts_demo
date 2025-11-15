import 'package:flutter/material.dart';
import '../widgets/currency_textfield.dart';

class ContactFormPage extends StatefulWidget {
  const ContactFormPage({super.key});

  @override
  State<ContactFormPage> createState() => _ContactFormPageState();
}

class _ContactFormPageState extends State<ContactFormPage> {
  num _amountWithDecimals = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Form')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Material(
              elevation: 8,
              color: Theme.of(context).colorScheme.surface,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: CurrencyTextField(
                          locale: 'en_US',
                          symbol: r'$',
                          decimalDigits: 2,
                          onValue: (v) => _amountWithDecimals = v,
                          decoration: const InputDecoration(
                            labelText: 'Amount with decimals',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: () => FocusScope.of(context).unfocus(),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
