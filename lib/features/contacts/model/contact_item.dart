class ContactItem {
  final String name;
  final List<String> phones;
  final List<String> emails;
  final String address;
  final DateTime? birthDate;

  const ContactItem({
    required this.name,
    required this.phones,
    required this.emails,
    required this.address,
    this.birthDate,
  });
}
