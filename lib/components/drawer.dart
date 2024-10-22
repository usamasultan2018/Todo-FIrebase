import 'package:firebase_todo_app/components/custom_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onLogoutTap;
  const MyDrawer(
      {Key? key, required this.onProfileTap, required this.onLogoutTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // header
          const DrawerHeader(
              child: Icon(
            Icons.person,
            color: Colors.black,
            size: 70,
          )),
          CustomListTile(
            icon: Icons.home,
            title: 'H O M E',
            onTap: () => Navigator.pop(context),
          ),
          CustomListTile(
            icon: Icons.person,
            title: 'P R O F I L E',
            onTap: onProfileTap,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: CustomListTile(
                icon: Icons.logout, title: 'L O G O U T', onTap: onLogoutTap),
          ),
          //home list tile
          // Profile list tile
        ],
      ),
    );
  }
}
