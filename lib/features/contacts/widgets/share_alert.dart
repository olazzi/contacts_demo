import 'package:share_plus/share_plus.dart';

import 'package:contacts_demo/features/contacts/presentation/contact_form_page.dart';

class ShareAlert {
  static Future<void> share(ContactAlertModel data) async {
    final message =
        'Hi ${data.name}, you are listed as my ${data.role} in my estate plan.\n'
        'I am using this link to keep everything organized:\n\n'
        '${data.link}';

    await SharePlus.instance.share(ShareParams(text: message));
  }
}
