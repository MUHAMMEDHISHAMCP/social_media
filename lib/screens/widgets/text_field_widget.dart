import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextInputWidget extends StatelessWidget {
   TextInputWidget({super.key,required this.hintText,required this.controller,this.isObsure = false,this.validator,this.icon});

String hintText;
bool isObsure;
TextEditingController controller;
String? Function(String?)? validator;
Widget? icon;


  @override
  Widget build(BuildContext context) {
    return   TextFormField(
      controller: controller,
                          decoration:  InputDecoration(
                            filled: true,
                            hintText: hintText,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                            contentPadding: const EdgeInsets.all(10),
                            border: const OutlineInputBorder(),
                            suffixIcon: icon
                          
                          ),
                        obscureText: isObsure,
                        validator: validator,
                        
                        );
  }
}