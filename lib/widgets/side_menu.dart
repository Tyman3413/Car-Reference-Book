import 'package:car_reference_book/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              'Гость',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: const Text(
              'example@gmail.com',
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/author.jpg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Избранное'),
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Поделиться'),
            onTap: () {
              Share.share("https://github.com/Tyman3413");
            },
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Выход'),
              onTap: () => SystemNavigator.pop())
        ],
      ),
    );
  }
}
