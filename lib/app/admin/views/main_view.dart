import 'package:app_public_facility_report/app/admin/views/home_view.dart';
import 'package:app_public_facility_report/app/admin/views/management/in_finished_view.dart';
import 'package:app_public_facility_report/app/admin/views/management/in_progress_view.dart';
import 'package:app_public_facility_report/app/admin/views/management/in_submitted_view.dart';
import 'package:app_public_facility_report/app/admin/views/management_account_view.dart';
import 'package:app_public_facility_report/app/admin/views/profile_view.dart';
import 'package:flutter/material.dart';

const titleIndex = {
  0: "Beranda",
  1: "Manajemen",
  2: "Manajemen Akun",
  3: "Profile",
};

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  int _currentPageIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleIndex[_currentPageIndex]!),
        centerTitle: _currentPageIndex == 2 ? false : true,
        actions:
            _currentPageIndex == 2
                ? [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/register");
                    },
                    icon: Icon(Icons.add),
                  ),
                ]
                : null,
        bottom:
            _currentPageIndex == 1
                ? TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: "Diajukan"),
                    Tab(text: "Diproses"),
                    Tab(text: "Selesai"),
                  ],
                )
                : null,
      ),
      body:
          [
            // Beranda
            const HomeView(),

            // Manajemen
            TabBarView(
              controller: _tabController,
              children: [
                const InSubmittedView(),
                const InProgressView(),
                const InFinishedView(),
              ],
            ),

            // Manajemen Akun
            const ManagementAccountView(),

            // Profile
            const ProfileView(),
          ][_currentPageIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Beranda"),
          NavigationDestination(icon: Icon(Icons.work), label: "Manajemen"),
          NavigationDestination(
            icon: Icon(Icons.group),
            label: "Manajemen akun",
          ),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
