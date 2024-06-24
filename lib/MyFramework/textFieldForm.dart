import 'package:flutter/material.dart';

class formInput extends StatelessWidget {
  final TextInputType keyboardType;
  final String mylable;
  const formInput(
      {super.key,
      required this.mylable,
      required this.mycontroller,
      this.keyboardType = TextInputType.text});
  final TextEditingController mycontroller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: mycontroller,
      keyboardType: keyboardType,
      
      decoration: InputDecoration(
        
          labelText: mylable,
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter value ';
        }
        
        return null;
      },
    );
  }
}
