import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> requestContacts() async {
    final status = await Permission.contacts.status;
    if (status.isGranted) return true;
    final granted = await FlutterContacts.requestPermission();
    if (granted) return true;
    return false;
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
