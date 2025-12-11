import 'package:contacts_demo/features/contacts/widgets/phone_input_field.dart';
import 'package:flutter/material.dart';
import '../widgets/currency_textfield.dart';
import '../widgets/send_alert.dart';

class ContactAlertModel {
  final String phone;
  final String name;
  final String role;
  final String link;

  ContactAlertModel({
    required this.phone,
    required this.name,
    required this.role,
    required this.link,
  });
}

class ContactFormPage extends StatefulWidget {
  const ContactFormPage({super.key});

  @override
  State<ContactFormPage> createState() => _ContactFormPageState();
}

class _ContactFormPageState extends State<ContactFormPage> {
  final TextEditingController nameCtrl = TextEditingController(
    text: "John Doe",
  );
  final TextEditingController roleCtrl = TextEditingController(
    text: "Executor",
  );
  final TextEditingController linkCtrl = TextEditingController(
    text: "https://example.com/plan",
  );
  final TextEditingController phoneCtrl = TextEditingController();

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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: PhoneInputField(
                              onChanged: (v) => phoneCtrl.text = v,
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: () {
                              final data = ContactAlertModel(
                                phone: phoneCtrl.text,
                                name: nameCtrl.text,
                                role: roleCtrl.text,
                                link: linkCtrl.text,
                              );
                              SendAlert.send(context, data);
                            },
                            child: const Text('Send Alert'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: roleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: linkCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Link',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.url,
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
