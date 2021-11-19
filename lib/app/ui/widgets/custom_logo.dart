import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {

  final String imagePath;
  final String textLabel;


  const CustomLogo({ 
    Key? key, 
    required this.imagePath, 
    required this.textLabel 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        margin: EdgeInsets.only(top: 50),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Image(image: AssetImage(imagePath)),
            SizedBox(height: 20,),
            Text(textLabel, style: TextStyle(fontSize: 30))
          ],
        ),
      ),
    );
  }
}