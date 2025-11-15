import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyTextField extends StatefulWidget {
  final String locale;
  final String symbol;
  final int decimalDigits;
  final ValueChanged<num>? onValue;
  final TextStyle? style;
  final InputDecoration? decoration;
  final num? initialValue;
  final bool enabled;

  const CurrencyTextField({
    super.key,
    this.locale = 'en_US',
    this.symbol = r'$',
    this.decimalDigits = 2,
    this.onValue,
    this.style,
    this.decoration,
    this.initialValue,
    this.enabled = true,
  });

  @override
  State<CurrencyTextField> createState() => _CurrencyTextFieldState();
}

class _CurrencyTextFieldState extends State<CurrencyTextField> {
  late final TextEditingController _controller;
  late final NumberFormat _fmt;
  String _lastFormatted = '';
  num _value = 0;

  @override
  void initState() {
    super.initState();
    _fmt = NumberFormat.currency(
      locale: widget.locale,
      symbol: widget.symbol,
      decimalDigits: widget.decimalDigits,
    );
    _controller = TextEditingController();
    if (widget.initialValue != null) {
      _value = widget.initialValue!;
      final t = _fmt.format(_value);
      _controller.text = t;
      _lastFormatted = t;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String _) {
    final digits = _controller.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) {
      _value = 0;
      _apply('');
      widget.onValue?.call(_value);
      return;
    }
    final scale = pow(10, widget.decimalDigits);
    _value = num.parse(digits) / scale;
    final formatted = _fmt.format(_value);
    if (formatted == _lastFormatted) return;
    _apply(formatted);
    widget.onValue?.call(_value);
  }

  void _apply(String text) {
    _lastFormatted = text;
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
      composing: TextRange.empty,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))],
      onChanged: _handleChanged,
      decoration:
          widget.decoration ??
          InputDecoration(
            prefixText: widget.symbol,
            hintText: _fmt.format(0).replaceAll(RegExp(r'\d'), '0'),
          ),
      style: widget.style,
    );
  }
}
