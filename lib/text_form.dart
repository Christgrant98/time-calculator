import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextForm extends StatelessWidget {
  final String hintText;
  final void Function(int)? onChanged;

  const TextForm({
    Key? key,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      keyboardType: TextInputType.number,
      onChanged:
          onChanged != null ? (value) => onChanged!(int.parse(value)) : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        } else {
          return null;
        }
      },
    );
  }
}
