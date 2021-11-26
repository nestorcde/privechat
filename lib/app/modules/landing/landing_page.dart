import 'package:get/get.dart';
import 'package:privechat/app/modules/agenda/agenda_page.dart';
import 'package:privechat/app/modules/usuario/usuarios_page.dart';
import 'package:flutter/material.dart';

import 'landing_controller.dart';

class LandingPage extends StatelessWidget {
  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontWeight: FontWeight.w500,
      fontSize: 12);

  final TextStyle selectedLabelStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);

  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
          height: 54,
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: landingPageController.changeTabIndex,
            currentIndex: landingPageController.tabIndex.value,
            backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedItemColor: Colors.white,
            unselectedLabelStyle: unselectedLabelStyle,
            selectedLabelStyle: selectedLabelStyle,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 7),
                  child: Icon(
                    Icons.account_circle,
                    size: 20.0,
                  ),
                ),
                label: 'Usuarios',
                backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  child: const Icon(
                    Icons.calendar_today,
                    size: 20.0,
                  ),
                ),
                label: 'Agenda',
                backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
              ),
              // BottomNavigationBarItem(
              //   icon: Container(
              //     margin: const EdgeInsets.only(bottom: 7),
              //     child: const Icon(
              //       Icons.location_history,
              //       size: 20.0,
              //     ),
              //   ),
              //   label: 'Places',
              //   backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
              // ),
              // BottomNavigationBarItem(
              //   icon: Container(
              //     margin: const EdgeInsets.only(bottom: 7),
              //     child: const Icon(
              //       Icons.settings,
              //       size: 20.0,
              //     ),
              //   ),
              //   label: 'Settings',
              //   backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
              // ),
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    final LandingController landingPageController = Get.find<LandingController>();
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar:
          buildBottomNavigationMenu(context, landingPageController),
      body: Obx(() => IndexedStack(
            index: landingPageController.tabIndex.value,
            children: [
              const UsuariosPage(),
              const AgendaPage()
            ],
          )),
    ));
  }
}