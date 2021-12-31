import 'package:flutter/material.dart';


class CustomInput extends StatelessWidget {

  final IconData icon;
  final String placeholder;
  final TextEditingController? textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool enabled;
  final Function? onChanged;



  const CustomInput({ 
    Key? key, 
    required this.icon, 
    required this.placeholder, 
    required this.enabled,
    this.textController, 
    this.keyboardType = TextInputType.text, 
    this.isPassword = false, 
    this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5
          )
        ]
      ),
      child: TextField(
        autocorrect: false,
        keyboardType: keyboardType,
        obscureText: isPassword,
        controller: textController,
        enabled: enabled,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: placeholder
        ),
        onChanged:(value) {
          onChanged!(value);
        },
      ),
    );
  }
}