import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatefulWidget {
  String hintText = '';
  bool hasPreIcon = false;
  Icon? preIcon;
  double? fontSize;
  TextEditingController? ctr;

  MyTextField(
      {Key? key,
      required this.hintText,
      required this.fontSize,
      this.preIcon,
      required this.hasPreIcon,
      required this.ctr})
      : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: widget.ctr,
        onTap: () {},
        cursorColor: Colors.yellow,
        decoration: InputDecoration(
            // helperText: widget.hintText,
            filled: true,
            fillColor: Colors.white,
            suffixIconColor: Colors.black,
            suffixIcon: widget.hasPreIcon ? widget.preIcon : null,
            hintStyle: GoogleFonts.alef(
              textStyle: TextStyle(
                  fontSize: widget.fontSize,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w500),
            ),
            hintText: widget.hintText,
            labelText: widget.hintText,
            labelStyle: const TextStyle(color: Colors.black),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 0.1,
                color: Colors.grey,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(
                width: 0.1,
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            )));
  }
}
