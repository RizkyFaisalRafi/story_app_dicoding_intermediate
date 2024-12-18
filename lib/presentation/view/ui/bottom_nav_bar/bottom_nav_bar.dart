import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/bottomnavbar_provider.dart';

import '../../../design_system/common/common.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomnavbarProvider>(context, listen: true);
    return Scaffold(
      body: provider.tabs[provider.bottomNavIndex],
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(
            icon: Icons.home,
            title: AppLocalizations.of(context)!.tittleHome,
          ),
          TabItem(
            icon: Icons.favorite,
            title: AppLocalizations.of(context)!.tittleFavorite,
          ),
          TabItem(
            icon: Icons.person,
            title: AppLocalizations.of(context)!.tittleProfile,
          ),
        ],
        initialActiveIndex: provider.bottomNavIndex,
        onTap: (index) => provider.bottomNavIndex = index,
      ),
    );
  }
}
