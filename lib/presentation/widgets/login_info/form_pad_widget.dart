import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final AutovalidateMode autovalidateMode;
  final bool autocorrect;
  final String? hintex;

  const LoginField({
    super.key,
    required this.label,
    required this.icon,
    required this.isPassword,
    required this.validator,
    this.keyboardType,
    this.suffixIcon,
    this.controller,
    this.autovalidateMode = AutovalidateMode.disabled, // valor por defecto
    this.autocorrect = false,
    this.hintex,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: validator,
      autovalidateMode: autovalidateMode, // ahora opcional
      autocorrect: autocorrect,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.indigoAccent.shade200),
        suffixIcon: suffixIcon,
        labelText: label,
        hintText: hintex,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
    );
  }
}
