import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Labels extends StatelessWidget {
  final String texto1;
  final String texto2;
  final String ruta;
  const Labels({ 
    Key? key, 
    required this.ruta, 
    required this.texto1, 
    required this.texto2 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children : [
        Text(texto1, style: const TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),),
        const SizedBox(height: 10,),
        GestureDetector(
          onTap: (){
            Get.offAndToNamed(ruta);
          },
          child: Text(texto2, 
                  style: TextStyle(
                    color: Colors.blue[600], 
                    fontSize: 15, 
                    fontWeight: FontWeight.bold)
                  )
        )
      ],
    );
  }
}