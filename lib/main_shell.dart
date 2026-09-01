import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_expenses/screens/home_page.dart';
import 'package:my_expenses/screens/settings_page.dart';
import 'package:my_expenses/screens/stats_page.dart';
import 'package:my_expenses/screens/wallet_page.dart';


class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {

  int _selectedIndex = 0;

  void onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(onNavigateToTab: onItemTapped,),
          StatsPage(),
          WalletPage(),
          SettingsPage(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: onItemTapped,
        items: [
          //home page icon
          BottomNavigationBarItem(
            icon: (_selectedIndex == 0) ?
            SvgPicture.asset("assets/images/home_selected.svg")
                : SvgPicture.asset('assets/images/home_unselected.svg'),
            label: '',
          ),

          //stats page
          BottomNavigationBarItem(
            icon: (_selectedIndex == 1) ?
            SvgPicture.asset("assets/images/stats_selected.svg")
                : SvgPicture.asset('assets/images/stats_unselected.svg'),
            label: '',
          ),

          //wallet page
          BottomNavigationBarItem(
            icon: (_selectedIndex == 2) ?
            SvgPicture.asset("assets/images/wallet_selected.svg")
                : SvgPicture.asset('assets/images/wallet unselected.svg'),
            label: '',
          ),

          //settings page
          BottomNavigationBarItem(
            icon: (_selectedIndex == 3) ?
            SvgPicture.asset("assets/images/settings_selected.svg")
                : SvgPicture.asset('assets/images/settings unselected.svg'),
            label: '',
          ),
        ],
      ),
    );
  }
}
