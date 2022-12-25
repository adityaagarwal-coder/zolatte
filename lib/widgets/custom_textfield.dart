import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;

  final TextInputType? inputType;

  const CustomTextField(
      {Key? key, this.hintText, this.controller, this.inputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(width: 1 ?? 1),
        borderRadius: BorderRadius.all(Radius.circular(11 ?? 5.0)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            contentPadding: const EdgeInsets.only(left: 11)),
      ),
    );
  }
}

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required this.hintText,
    this.inputFormatters,
    this.validator,
    this.controller,
    this.enabled,
  }) : super(key: key);
  final String hintText;
  final TextEditingController? controller;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        inputFormatters: inputFormatters,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: 4,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          labelText: hintText,
          labelStyle: const TextStyle(
            fontFamily: 'NeueMontreal',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff777777),
            letterSpacing: 0,
            wordSpacing: 0,
          ),
        ),
        enabled: enabled,
      ),
    );
  }
}
