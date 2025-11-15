import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import '../model/contact_item.dart';

abstract class ContactsRepositoryBase {
  Future<List<ContactItem>> fetchContacts();
}

class ContactsRepository implements ContactsRepositoryBase {
  @override
  Future<List<ContactItem>> fetchContacts() async {
    final list = await _fetchWithFlutterContacts();
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }
}

Future<List<ContactItem>> _fetchWithFlutterContacts() async {
  final contacts = await fc.FlutterContacts.getContacts(
    withProperties: true,
    withPhoto: false,
    withGroups: true,
    withAccounts: true,
  );

  final result = <ContactItem>[];

  for (final c in contacts) {
    final display = (c.displayName.isNotEmpty
            ? c.displayName
            : '${c.name.first} ${c.name.last}')
        .trim();

    final phones = c.phones
        .map((p) => p.number.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final emails = c.emails
        .map((e) => e.address.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    String addr = '';
    if (c.addresses.isNotEmpty) {
      final a = c.addresses.first;
      final parts = <String>[
        a.address?.trim() ?? '',
        a.city?.trim() ?? '',
        a.state?.trim() ?? '',
        a.postalCode?.trim() ?? '',
        a.country?.trim() ?? '',
      ].where((e) => e.isNotEmpty).toList();
      addr = parts.join(', ');
    }

    DateTime? birthDate;
    for (final ev in c.events) {
      final isBirthday =
          ev.label == fc.EventLabel.birthday ||
          (ev.customLabel != null && ev.customLabel!.toLowerCase() == 'birthday');

      if (isBirthday) {
        final y = ev.year ?? 1900;
        final m = ev.month ?? 1;
        final d = ev.day ?? 1;
        birthDate = DateTime(y, m, d);
        break;
      }
    }


    result.add(ContactItem(
      name: display.isEmpty ? 'Unknown' : display,
      phones: phones,
      emails: emails,
      address: addr,
      birthDate: birthDate,
    ));
  }

  return result;
}
