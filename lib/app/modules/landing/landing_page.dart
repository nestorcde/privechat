import 'package:get/get.dart';
import 'package:privechat/app/modules/agenda/agenda_page.dart';
import 'package:privechat/app/modules/profile/profile_page.dart';
import 'package:privechat/app/modules/usuario/usuarios_page.dart';
import 'package:flutter/material.dart';

import 'landing_controller.dart';

class LandingPage extends StatelessWidget {
  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontWeight: FontWeight.w500,
      fontSize: 12);

  final TextStyle selectedLabelStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);

  LandingPage({Key? key}) : super(key: key);

  buildBottomNavigationMenu(context, landingPageController) {
    const double sizes = 15;
    return Obx(() => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: BottomNavigationBar(
              showUnselectedLabels: true,
              showSelectedLabels: true,
              onTap: landingPageController.changeTabIndex,
              currentIndex: landingPageController.tabIndex.value,
              backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
              unselectedItemColor: Colors.white.withOpacity(0.5),
              selectedItemColor: Colors.white,
              unselectedLabelStyle: unselectedLabelStyle,
              selectedLabelStyle: selectedLabelStyle,
              items: landingPageController.usuario.admin! ||
                      landingPageController.usuario.revisado!
                  ? [
                      BottomNavigationBarItem(
                        activeIcon: const Icon(
                          Icons.calendar_today,
                          size: sizes,
                        ),
                        tooltip: 'Marca tu turno',
                        icon: Container(
                          margin: const EdgeInsets.only(bottom: 7),
                          child: const Icon(
                            Icons.calendar_today,
                            size: sizes,
                          ),
                        ),
                        label: 'Agenda',
                        backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
                      ),
                      BottomNavigationBarItem(
                        activeIcon: const Icon(
                          Icons.mail,
                          size: sizes,
                        ),
                        tooltip: 'Contacta con el administrador',
                        icon: Container(
                          margin: const EdgeInsets.only(bottom: 7),
                          child: const Icon(
                            Icons.mail,
                            size: sizes,
                          ),
                        ),
                        label: 'Contacto',
                        backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
                      ),
                      BottomNavigationBarItem(
                        activeIcon: const Icon(
                          Icons.account_circle_rounded,
                          size: sizes,
                        ),
                        tooltip: 'Revisa tu Perfil',
                        icon: Container(
                          margin: const EdgeInsets.only(bottom: 7),
                          child: const Icon(
                            Icons.account_circle_rounded,
                            size: sizes,
                          ),
                        ),
                        label: 'Perfil',
                        backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
                      ),
                    ]
                  : [
                      BottomNavigationBarItem(
                        activeIcon: const Icon(
                          Icons.mail,
                          size: sizes,
                        ),
                        tooltip: 'Contacta con el administrador',
                        icon: Container(
                          margin: const EdgeInsets.only(bottom: 7),
                          child: const Icon(
                            Icons.mail,
                            size: sizes,
                          ),
                        ),
                        label: 'Contacto',
                        backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
                      ),
                      BottomNavigationBarItem(
                        activeIcon: const Icon(
                          Icons.account_circle_rounded,
                          size: sizes,
                        ),
                        tooltip: 'Revisa tu Perfil',
                        icon: Container(
                          margin: const EdgeInsets.only(bottom: 7),
                          child: const Icon(
                            Icons.account_circle_rounded,
                            size: sizes,
                          ),
                        ),
                        label: 'Perfil',
                        backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
                      ),
                    ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final LandingController landingPageController =
        Get.find<LandingController>();
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar:
          buildBottomNavigationMenu(context, landingPageController),
      body: Obx(() => IndexedStack(
            index: landingPageController.tabIndex.value,
            children: landingPageController.usuario.admin! ||
                    landingPageController.usuario.revisado!
                ? [const AgendaPage(), const UsuariosPage(), ProfilePage()]
                : [const UsuariosPage(), ProfilePage()],
          )),
    ));
  }
}
