import 'package:flutter/material.dart';
import '../model/contact_item.dart';

class ContactListTile extends StatelessWidget {
  final ContactItem item;
  final VoidCallback? onTap;

  const ContactListTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final initial = item.name.isNotEmpty
        ? item.name.characters.first.toUpperCase()
        : '?';
    final phone = item.phones.isNotEmpty ? item.phones.first : 'No phone';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blueGrey,
              child: Text(
                initial,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 16,
                        color: phone == 'No phone' ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: phone == 'No phone'
                                ? Colors.red
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.chevron_right), SizedBox(height: 4)],
            ),
          ],
        ),
      ),
    );
  }
}
