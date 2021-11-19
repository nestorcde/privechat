import 'package:flutter/material.dart';


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
                      fontSize: 18
                    ),
                  )
              ),
              width: double.infinity,
              height: 55,
            ));
  }
}