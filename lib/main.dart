import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'features/contacts/presentation/contact_form_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // flutter_libphonenumber initialization
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF6750A4)),
      home: const ContactFormPage(),
    );
  }
}
