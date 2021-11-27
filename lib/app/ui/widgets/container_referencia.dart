

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget containerReferencia(Color color, String texto) => Container(
  alignment: Alignment.center,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: color
  ),
  height: 20,
  width: Get.width * 0.28,
  child: Text(texto, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
  
);