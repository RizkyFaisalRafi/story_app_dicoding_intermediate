import 'package:flutter/material.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/common/common.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.titleSetting,
        ),
      ),
    );
  }
}
