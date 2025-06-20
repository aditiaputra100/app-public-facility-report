import 'package:app_public_facility_report/app/user/viewmodels/report_view_model.dart';
import 'package:app_public_facility_report/app/user/viewmodels/user_view_model.dart';
import 'package:app_public_facility_report/app/user/views/home/home_page_view.dart';
import 'package:app_public_facility_report/app/user/views/home/profile_page_view.dart';
import 'package:app_public_facility_report/app/user/views/home/report_page_view.dart';
import 'package:app_public_facility_report/app/user/views/status_report/in_finished_report.dart';
import 'package:app_public_facility_report/app/user/views/status_report/in_progress_report.dart';
import 'package:app_public_facility_report/app/user/views/status_report/in_submitted_report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const titleIndex = {1: "Lapor", 2: "Status", 3: "Profil"};

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  int _currentPageIndex = 0;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final uvm = Provider.of<UserViewModel>(context, listen: false);
      final rvm = Provider.of<ReportViewModel>(context, listen: false);

      final user = uvm.user;

      if (user != null) {
        await rvm.getReportCurrent(user);
        await rvm.getReportCurrentUser(user);

        String? error = rvm.error;

        if (error != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(rvm.error!),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }

        // error = rvm.error;

        // if (error != null && mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(rvm.error!),
        //       behavior: SnackBarBehavior.floating,
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        // }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _currentPageIndex == 0
              ? null
              : AppBar(
                title: Text(titleIndex[_currentPageIndex]!),
                centerTitle: true,
                bottom:
                    _currentPageIndex == 2
                        ? TabBar(
                          controller: _tabController,
                          tabs: const [
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
            HomePageView(),

            // Laporan
            ReportPageView(),

            // Status
            TabBarView(
              controller: _tabController,
              children: const [
                InSubmittedReport(),
                InProgressReport(),
                InFinishedReport(),
              ],
            ),

            // Profil
            ProfilePageView(),
          ][_currentPageIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        height: 64,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.edit), label: 'Lapor'),
          NavigationDestination(
            icon: Icon(Icons.confirmation_num),
            label: 'Status',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
