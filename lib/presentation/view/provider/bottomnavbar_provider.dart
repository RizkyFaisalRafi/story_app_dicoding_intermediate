import 'package:flutter/material.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/favorite_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/home_page.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/ui/profile_page.dart';

class BottomnavbarProvider extends ChangeNotifier {
  int _bottomNavIndex = 0;

  final List<Widget> _tabs = [
    const HomePage(),
    const FavoritePage(),
    const ProfilePage(),
  ];

  // Getter
  List get tabs => _tabs;
  int get bottomNavIndex => _bottomNavIndex;

  // Setter for bottomNavIndex
  set bottomNavIndex(int index) {
    _bottomNavIndex = index;
    notifyListeners(); // Notify listeners of change
  }

  // Method untuk mengubah tab
  void switchToSearchTab() {
    _bottomNavIndex = 1; // Index untuk tab Search
    notifyListeners();
  }
}
