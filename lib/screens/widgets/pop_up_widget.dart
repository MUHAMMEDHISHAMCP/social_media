import 'package:flutter/material.dart';

class AddPopup extends StatefulWidget {
  AddPopup({Key? key, required this.imageUrl}) : super(key: key);
  String? imageUrl;

  @override
  State<AddPopup> createState() => _AddPopupState();
}

class _AddPopupState extends State<AddPopup> {
  @override
  Widget build(BuildContext context) {
//     return
    return Padding(
      padding: const EdgeInsets.all(56),
      child: CircleAvatar(
        backgroundImage: NetworkImage(widget.imageUrl!),
      ),
    );
  }
}
