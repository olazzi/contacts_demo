import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactForm extends StatelessWidget {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController phone;
  final TextEditingController email;
  final TextEditingController address;
  final TextEditingController dob;
  final VoidCallback onSearch;
  final VoidCallback onAdd;

  const ContactForm({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.address,
    required this.dob,
    required this.onSearch,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.all(12), child: TextField(controller: firstName, decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()))),
        Padding(padding: const EdgeInsets.all(12), child: TextField(controller: lastName, decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()))),
        Padding(padding: const EdgeInsets.all(12), child: TextField(controller: phone,inputFormatters:[FilteringTextInputFormatter.digitsOnly], keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()))),
        Padding(padding: const EdgeInsets.all(12), child: TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()))),
        Padding(padding: const EdgeInsets.all(12), child: TextField(controller: address, decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()))),
        Padding(padding: const EdgeInsets.all(12), child: TextField(controller: dob, decoration: const InputDecoration(labelText: 'Birth Date (YYYY-MM-DD)', border: OutlineInputBorder()))),
   Padding(
  padding: const EdgeInsets.all(12),
  child: Row(
    children: [
      Expanded(
        child: FilledButton(
          onPressed: onSearch,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.search),
              SizedBox(width: 6),
              Text('Search'),
            ],
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: FilledButton.tonal(
          onPressed: onAdd,
          child: const Text('Add'),
        ),
      ),
    ],
  ),
),

      ],
    );
  }
}
