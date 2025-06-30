import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../services/global.dart';
import '../../../utils/button_full_width.dart';
import '../../../utils/notification_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  final storage = const FlutterSecureStorage();
  Map user = GlobalConfig.user;

  @override
  bool get wantKeepAlive => true;

  void logout(context) async {
    // await storage.delete(key: 'token');
    await storage.delete(key: 'user');
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    NotificationBar.toastr('Logout berhasil', 'success');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 50),
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: user['path'] != null
                  ? FadeInImage(
                      image: NetworkImage(user['path']),
                      placeholder: const AssetImage("images/loading.gif"),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "images/blank.png",
                          fit: BoxFit.contain,
                        );
                      },
                      width: 150.0,
                      fit: BoxFit.cover,
                      height: 150.0,
                    )
                  : Image.asset(
                      'images/logo.png',
                      width: 150.0,
                      fit: BoxFit.cover,
                      height: 150.0,
                    ),
            ),
            Text(
              user['username'],
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: ButtonFullWidth(
                label: 'Keluar',
                action: () => logout(context),
                color: Colors.white,
                background: true,
                confirmation: true,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
