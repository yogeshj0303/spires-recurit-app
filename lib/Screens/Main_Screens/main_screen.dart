import 'package:flutter/cupertino.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Drawer/programs_screen.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Nearby%20Jobs/map_jobs.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Profile/profile.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Jobs/jobs.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Internship/internship.dart';

import '../../Constants/exports.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageStorageBucket bucket = PageStorageBucket();
  final MyController controller = Get.put(MyController());

  static const List<NavigationDestination> _navigationDestinations = [
    NavigationDestination(
      icon: Icon(Icons.dashboard, color: Colors.black38, size: 24),
      selectedIcon: Icon(Icons.dashboard, color: primaryColor, size: 26),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.school, color: Colors.black38, size: 24),
      selectedIcon: Icon(Icons.school, color: primaryColor, size: 26),
      label: 'Programs',
    ),
    NavigationDestination(
      icon: Icon(Icons.work_history, color: Colors.black38, size: 24),
      selectedIcon: Icon(Icons.work_history, color: primaryColor, size: 26),
      label: 'Nearby',
    ),
    NavigationDestination(
      icon: Icon(Icons.account_circle_outlined, color: Colors.black38, size: 24),
      selectedIcon: Icon(Icons.account_circle_outlined, color: primaryColor, size: 26),
      label: 'Account',
    ),
  ];

  static final List<Widget> _screens = [
    const Home(),
    const ProgramsScreen(fromBottomNav: true),
    NearMapJobs(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    controller.selectedIndex.value = 0;
    _initializeServices();
  }

  void _initializeServices() {
    JobsUtils.allJobs();
    InternshipUtils.allInternship();
    LocationServices.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: PageStorage(
        bucket: bucket,
        child: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            xsmallLightText.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: NavigationBar(
          height: 60,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          elevation: 2,
          indicatorColor: primaryColor.withOpacity(0.05),
          backgroundColor: whiteColor,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: _navigationDestinations,
        ),
      ),
    );
  }
}
