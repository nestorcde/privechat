import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BotonAzul extends StatelessWidget {
  final String texto;
  final Function funcion;
  final bool? autenticando;
  const BotonAzul({ 
    Key? key, 
    required this.texto, 
    required this.funcion, 
    required this.autenticando 
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = Get.size.height;
    return ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              elevation: 2,
              shape: const StadiumBorder()
            ),
            onPressed: autenticando ?? false ? null : () => funcion(), 
            
            child: SizedBox(
              child: Center(
                child: Text(
                    texto,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15
                    ),
                  )
              ),
              width: double.infinity,
              height: height * 0.08,
            ));
  }
}