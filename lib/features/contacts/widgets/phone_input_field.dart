import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UsPhoneFormatter extends TextInputFormatter {
  final _reDigit = RegExp(r'\d');

  String _digits(String s) => s.replaceAll(RegExp(r'\D'), '');

  String _format(String d) {
    if (d.isEmpty) return '';
    if (d.length <= 3) return '($d)';
    if (d.length <= 6) return '(${d.substring(0, 3)}) ${d.substring(3)}';
    final tail = d.length > 10 ? d.substring(6, 10) : d.substring(6);
    return '(${d.substring(0, 3)}) ${d.substring(3, 6)}-$tail';
  }

  int _digitsBeforeInFormatted(String f, int off) {
    int c = 0;
    for (int i = 0; i < off && i < f.length; i++) {
      if (_reDigit.hasMatch(f[i])) c++;
    }
    return c;
  }

  TextEditingValue _valueFor(String digits, int digitIdx) {
    final f = _format(digits);
    final map = <int>[];
    int di = 0;
    for (int i = 0; i < f.length && di < digits.length; i++) {
      if (_reDigit.hasMatch(f[i])) {
        map.add(i + 1);
        di++;
      }
    }
    int caret;
    if (digitIdx <= 0) {
      caret = f.isNotEmpty ? 1 : 0;
    } else if (digitIdx >= map.length) {
      caret = f.length;
    } else {
      caret = map[digitIdx - 1];
    }
    return TextEditingValue(
      text: f,
      selection: TextSelection.collapsed(offset: caret),
    );
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldF = oldValue.text;
    final oldD = _digits(oldF);
    final newF = newValue.text;

    final isDeletion = newF.length < oldF.length;
    final oldSel = oldValue.selection;
    final newSel = newValue.selection;

    if (isDeletion) {
      if (!oldSel.isCollapsed) {
        final start = oldSel.start.clamp(0, oldF.length);
        final end = oldSel.end.clamp(0, oldF.length);
        final leftIdx = _digitsBeforeInFormatted(oldF, start);
        final rightIdx = _digitsBeforeInFormatted(oldF, end);
        final delCount = (rightIdx - leftIdx).clamp(0, oldD.length);
        if (delCount == 0) {
          return TextEditingValue(
            text: _format(oldD),
            selection: TextSelection.collapsed(offset: start),
          );
        }
        final nextD = oldD.substring(0, leftIdx) + oldD.substring(rightIdx);
        if (nextD.isEmpty) {
          return const TextEditingValue(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        }
        return _valueFor(nextD, leftIdx);
      }

      final backspace = newSel.baseOffset <= oldSel.baseOffset;
      if (backspace) {
        if (oldF.isEmpty) {
          return const TextEditingValue(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        }
        int pos = oldSel.baseOffset.clamp(0, oldF.length);
        if (pos > 0 && !_reDigit.hasMatch(oldF[pos - 1])) {
          final same = _format(oldD);
          final caret = (pos - 1).clamp(0, same.length);
          return TextEditingValue(
            text: same,
            selection: TextSelection.collapsed(offset: caret),
          );
        }
        if (oldD.isEmpty) {
          return const TextEditingValue(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        }
        final idx = _digitsBeforeInFormatted(oldF, oldSel.baseOffset) - 1;
        if (idx < 0) return _valueFor(oldD, 0);
        final nextD = oldD.substring(0, idx) + oldD.substring(idx + 1);
        if (nextD.isEmpty) {
          return const TextEditingValue(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        }
        return _valueFor(nextD, idx);
      } else {
        if (oldF.isEmpty) {
          return const TextEditingValue(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        }
        int pos = oldSel.baseOffset.clamp(0, oldF.length);
        if (pos < oldF.length && !_reDigit.hasMatch(oldF[pos])) {
          final same = _format(oldD);
          final caret = (pos + 1).clamp(0, same.length);
          return TextEditingValue(
            text: same,
            selection: TextSelection.collapsed(offset: caret),
          );
        }
        if (oldD.isEmpty) {
          return const TextEditingValue(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        }
        final idx = _digitsBeforeInFormatted(oldF, oldSel.baseOffset);
        final nextD = (idx >= oldD.length)
            ? oldD
            : (oldD.substring(0, idx) + oldD.substring(idx + 1));
        if (nextD.isEmpty) {
          return const TextEditingValue(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        }
        return _valueFor(nextD, idx);
      }
    }

    var nd = _digits(newF);
    if (nd.length > 10) nd = nd.substring(0, 10);
    final cur = newSel.baseOffset.clamp(0, newF.length);
    final targetIdx = _digitsBeforeInFormatted(newF, cur).clamp(0, nd.length);
    if (nd.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    return _valueFor(nd, targetIdx);
  }
}

class PhoneInputField extends StatefulWidget {
  const PhoneInputField({super.key});
  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  final ccController = TextEditingController(text: '1');
  final nsnController = TextEditingController();
  final ccFocus = FocusNode();
  final nsnFocus = FocusNode();
  String _prevCc = '';

  @override
  void initState() {
    super.initState();
    ccFocus.addListener(() => setState(() {}));
    nsnFocus.addListener(() => setState(() {}));
    nsnController.addListener(() => setState(() {}));
    ccController.addListener(() {
      final cc = ccController.text;
      if (ccFocus.hasFocus && cc == '1' && _prevCc != '1') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          nsnFocus.requestFocus();
          nsnController.selection = TextSelection.collapsed(
            offset: nsnController.text.length,
          );
        });
      }
      _prevCc = cc;
    });
  }

  @override
  void dispose() {
    ccController.dispose();
    nsnController.dispose();
    ccFocus.dispose();
    nsnFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final anyFocused = ccFocus.hasFocus || nsnFocus.hasFocus;
    final borderColor = anyFocused
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).dividerColor;
    final activeColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final inactiveColor = Theme.of(context).hintColor;
    final ccEmpty = ccController.text.isEmpty;
    final plusColor = ccEmpty ? inactiveColor : activeColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      height: 48,
      child: Row(
        children: [
          Row(
            children: [
              Text('+', style: TextStyle(fontSize: 16, color: plusColor)),
              const SizedBox(width: 4),
              SizedBox(
                width: 28,
                child: TextField(
                  controller: ccController,
                  focusNode: ccFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  style: TextStyle(
                    color: ccEmpty ? inactiveColor : activeColor,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: nsnController,
              focusNode: nsnFocus,
              keyboardType: TextInputType.phone,
              inputFormatters: [UsPhoneFormatter()],
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Phone Number',
                contentPadding: EdgeInsets.zero,
                suffixIconConstraints: const BoxConstraints(
                  minHeight: 24,
                  minWidth: 24,
                ),
                suffixIcon: nsnController.text.isNotEmpty
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            nsnController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          tooltip: 'Clear',
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
