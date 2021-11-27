


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