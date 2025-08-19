import 'package:app4_receitas/utils/theme/custom_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBar();
}

class _CustomBottomNavigationBar extends State<CustomBottomNavigationBar> {
   
   final theme = Get.find<CustomThemeController>();

    int _currentIndex = 0;

    void _onItemTapped(int index) {
      switch(index) {
        case 0:
        setState(() => _currentIndex = 0);
        GoRouter.of(context).go("/");
        case 1:
        setState(() => _currentIndex = 0);
        GoRouter.of(context).go("/favourites");
        case 2:
        setState(() => _currentIndex = 0);
        GoRouter.of(context).go("/profile");
        case 3:
        theme.toogleTheme();
        break;
        }
    }
   @override
   Widget build(BuildContext context) {
    return BottomNavigationBar(
      items : [
        BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoritas"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        BottomNavigationBarItem(
          icon: Obx(() {
            return theme.isDark.value 
            ? const Icon(Icons.nightlight_round_outlined, size:24)
            : const Icon(Icons.wb_sunny_outlined);
          }),
           label: "Tema"
           ),
      ],
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,);
        
   }
}