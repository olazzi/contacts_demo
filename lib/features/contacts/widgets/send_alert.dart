import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:contacts_demo/features/contacts/presentation/contact_form_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SendAlert {
  static Future<void> send(BuildContext context, ContactAlertModel data) async {
    final rawPhone = data.phone;
    final digits = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid phone number')));
      return;
    }

    final message =
        'Hi ${data.name}, you are listed as my ${data.role} in my estate plan.\n'
        'I am using this link to keep everything organized:\n\n'
        '${data.link}';

    final encodedBody = Uri.encodeComponent(message);
    final uri = Uri.parse('sms:$digits?body=$encodedBody');

    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open messaging app')),
      );
    }
  }
}
