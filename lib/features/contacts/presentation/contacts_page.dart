import 'package:flutter/material.dart';
import '../../../core/debouncer.dart';
import '../model/contact_item.dart';
import '../data/contacts_repository.dart';
import '../../../utils/permissions.dart';
import '../widgets/contact_list_tile.dart';
import '../widgets/currency_textfield.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final _repo = ContactsRepository();
  final _controller = TextEditingController();
  final _debouncer = Debouncer(delay: Duration(milliseconds: 300));
  List<ContactItem> _all = [];
  List<ContactItem> _filtered = [];
  bool _loading = true;
  bool _granted = false;
  bool _expanded = false;
  num _amount = 0;

  @override
  void initState() {
    super.initState();
    _init();
    _controller.addListener(_onQueryChanged);
  }

  Future<void> _init() async {
    final ok = await Permissions.requestContacts();
    if (!mounted) return;
    if (ok) {
      final data = await _repo.fetchContacts();
      if (!mounted) return;
      setState(() {
        _granted = true;
        _all = data;
        _filtered = data;
        _loading = false;
        _expanded = true;
      });
    } else {
      setState(() {
        _granted = false;
        _loading = false;
      });
    }
  }

  String _primaryPhone(ContactItem c) =>
      c.phones.isNotEmpty ? c.phones.first : '';

  void _onQueryChanged() {
    final q = _controller.text.trim().toLowerCase();
    _debouncer.run(() {
      if (q.isEmpty) {
        setState(() => _filtered = _all);
      } else {
        setState(() {
          _filtered = _all
              .where((e) => e.name.toLowerCase().contains(q))
              .toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_granted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Contacts Search')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'This app needs access to your contacts. Please grant permission to continue.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: Permissions.openSettings,
                child: const Text('Open Settings'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts Search'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, <ContactItem>[]),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _expanded = false;
            FocusScope.of(context).unfocus();
          });
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Tap to search',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  textInputAction: TextInputAction.search,
                  onTap: () {
                    setState(() {
                      _expanded = true;
                      _filtered = _all;
                    });
                  },
                ),
              ),
              if (_expanded)
                Expanded(
                  child: _filtered.isEmpty
                      ? const Center(child: Text('No results'))
                      : ListView.separated(
                          itemCount: _filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = _filtered[index];
                            return ContactListTile(
                              item: item,
                              onTap: () => Navigator.pop(context, [item]),
                            );
                          },
                        ),
                )
              else
                const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      ),
      bottomSheet: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
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
                      onValue: (v) => _amount = v,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
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
    );
  }
}
