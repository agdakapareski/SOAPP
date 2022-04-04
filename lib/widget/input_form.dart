import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final Widget? suffix;
  final TextCapitalization? textCapitalization;
  final Function(String)? onChanged;
  final bool? readonly;
  final String? labelText;
  final String? Function(String?)? validator;

  const InputForm({
    Key? key,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.prefix,
    this.suffix,
    this.textCapitalization,
    this.onChanged,
    this.readonly,
    this.labelText,
    this.validator,
  }) : super(key: key);

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  // ukuran font hint
  final double hintFontSize = 13;

  // warna abu-abu
  final MaterialColor abuAbu = Colors.grey;

  // warna hitam
  final Color hitam = Colors.black;

  // border input form
  final OutlineInputBorder inputBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(0),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      readOnly: widget.readonly ?? false,
      style: TextStyle(fontSize: hintFontSize),
      onChanged: widget.onChanged,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: abuAbu),
        focusedBorder: inputBorder,
        suffix: widget.suffix,
        prefix: widget.prefix,
        border: inputBorder,
        labelText: widget.labelText,
      ),
    );
  }
}
