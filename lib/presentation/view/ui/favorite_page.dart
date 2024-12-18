import 'package:flutter/material.dart';

import '../../design_system/common/common.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.tittleFavorite,
        ),
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.tittleComingSoon,
        ),
      ),
    );
  }
}
