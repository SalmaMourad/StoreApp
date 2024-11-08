import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/form.dart' as r;
import 'package:stores_app/constansts%20and%20fields/constants.dart';

// ignore: must_be_immutable
class Feild extends StatefulWidget {
  Feild({
    super.key,
    required this.text,
    required this.icon,
    this.controller,
    this.fieldValidator,
    this.isPassword = false,
    this.obscureText = false,
  });

  String text;
  Icon icon;
  TextEditingController? controller;
  FormFieldValidator<String>? fieldValidator;
  final bool isPassword;
  bool obscureText = false;

  @override
  State<Feild> createState() => _FeildState();
}

class _FeildState extends State<Feild> {
//final String? Function(String?)? fieldValidator;
  String FieldValidatorr(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else {
      print("here is else");
      if (value.length < 8) {
        return 'your password must be eigth or more';
      }
    }
    return 'done';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40, right: 40),
      child: Column(
        children: [
          TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              focusColor: kprimaryColourPink,
              icon: widget.icon, // User icon on the left
              labelText: widget.text,
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFA6A5A4), width: 1.5),
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        widget.obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                    )
                  : null, // If it's not a password field, set to null
            ),
            validator: widget.fieldValidator,
          ),
        ],
      ),
    );
  }
}
