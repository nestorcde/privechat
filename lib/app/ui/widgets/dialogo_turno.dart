


import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future dialogoTurno(String titulo, String content, bool conFuncion, String boton, Function funcion) =>Get.dialog(
                            AlertDialog(
                              title:  Text(titulo),
                              content: Text(content),
                              actions: [
                                TextButton(onPressed: Get.back, child: const Text('Cancelar')),
                                conFuncion? TextButton(onPressed: (){funcion(); Get.back();}, child:  Text(boton)):const SizedBox()
                              ],
                            )
                          );

Future dialogoOtro(TextEditingController controller, String horario, Rx<DateTime> diaEnfocado, Function funcion) =>Get.dialog(
      AlertDialog(
        title:  const Text('Registro'),
        content: const Text('Ingrese el nombre de la persona a la que desea agendar'),
        actions: [
          TextField(controller: controller,),
          TextButton(onPressed: (){
            if(controller.text.isNotEmpty){
              funcion(diaEnfocado.value,horario,controller.text); 
              Get.back();
            }else{
              Get.snackbar('Falta Nombre', 'Ingrese nombre de la persona a la que agendaar');
            }
          }, child:  const Text('OK'))
        ],
      )
    );

Future dialogoTuto(String titulo, String content, String boton, Function funcion) =>Get.dialog(
  AlertDialog(
    title:  Text(titulo),
    content: Text(content),
    actions: [
      TextButton(onPressed: (){funcion(); Get.back();}, child:  Text(boton))
    ],
  )
);