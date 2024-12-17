import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/profile_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String?>(
                  future: profileProvider.getNameLocalUsecase.execute(),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? 'Null Woy',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    // data.usersData?.email ?? 'Null',
                    'johndoe@example.com',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
