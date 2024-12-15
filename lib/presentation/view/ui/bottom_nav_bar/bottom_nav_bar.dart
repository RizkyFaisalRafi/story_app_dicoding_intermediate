import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/bottomnavbar_provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomnavbarProvider>(context, listen: true);
    return Scaffold(
      body: provider.tabs[provider.bottomNavIndex],
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.favorite, title: 'Favorite'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: provider.bottomNavIndex,
        onTap: (index) => provider.bottomNavIndex = index,
      ),
    );
  }
}
