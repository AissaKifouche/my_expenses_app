import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/screens/home_page.dart';
import 'package:my_expenses/screens/settings_page.dart';
import 'package:my_expenses/screens/stats_page.dart';
import 'package:my_expenses/screens/wallet_page.dart';
import 'package:provider/provider.dart';
import './database/app_database.dart';


class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late final AppData appData;
  late final Future<void> initialization;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    final database = context.read<AppDatabase>();
    
    appData = AppData(database);
    initialization = appData.initialize();
  }

  void onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Failed to initialize the application",
                    ),
                    SizedBox(height: 8.h,),
                    Text('${snapshot.error}'),
                    SizedBox(height: 16.h,),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          initialization = appData.initialize();
                        });
                      },
                      child: Text("Retry"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              HomePage(appData: appData,),
              StatsPage(appData: appData,),
              WalletPage(appData: appData,),
              SettingsPage(appData: appData,),
            ],
          ),

          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: _selectedIndex,
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
      );
  }
}
