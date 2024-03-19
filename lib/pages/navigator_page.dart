import 'package:app_news/pages/chatPage/chat_page.dart';
import 'package:app_news/pages/explorePage/explore_page.dart';
import 'package:app_news/pages/homePage/home_page.dart';
import 'package:app_news/pages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class NavigatorUserPage extends StatefulWidget {
  const NavigatorUserPage({super.key});

  @override
  State<NavigatorUserPage> createState() => _NavigatorUserPageState();
}

class _NavigatorUserPageState extends State<NavigatorUserPage> {
  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const ExplorePage(),
      const ChatPage(),
      const ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        inactiveIcon: const Icon(Icons.home_outlined),
        iconSize: 32,
        title: ("Trang Chủ"),
        textStyle: Theme.of(context).textTheme.labelSmall,
        activeColorPrimary: Theme.of(context).primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.explore),
        inactiveIcon: const Icon(Icons.explore_outlined),
        iconSize: 32,
        title: ("Khám Phá"),
        textStyle: Theme.of(context).textTheme.labelSmall,
        activeColorPrimary: Theme.of(context).primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat),
        inactiveIcon: const Icon(Icons.chat_outlined),
        iconSize: 32,
        title: ("Chat Bot"),
        textStyle: Theme.of(context).textTheme.labelSmall,
        activeColorPrimary: Theme.of(context).primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        inactiveIcon: const Icon(Icons.person_outline),
        iconSize: 32,
        title: ("Hồ Sơ"),
        textStyle: Theme.of(context).textTheme.labelSmall,
        activeColorPrimary: Theme.of(context).primaryColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: 0),
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Theme.of(context).cardColor,
      handleAndroidBackButtonPress: true,
      hideNavigationBarWhenKeyboardShows: true,
      navBarStyle: NavBarStyle.style11,
      navBarHeight: 70,
    );
  }
}
