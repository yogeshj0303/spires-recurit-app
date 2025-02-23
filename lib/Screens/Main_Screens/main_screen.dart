import 'package:flutter/cupertino.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Drawer/programs_screen.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Nearby%20Jobs/map_jobs.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Profile/profile.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Jobs/jobs.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Internship/internship.dart';
import 'package:spires_app/Screens/live_openings_screen.dart';
import 'package:spires_app/Screens/membership_drive_screen.dart';

import '../../Constants/exports.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageStorageBucket bucket = PageStorageBucket();
  final MyController controller = Get.put(MyController());

  static final List<BottomNavigationBarItem> _navigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.house_fill),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.school),
      label: 'Programs',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.card_membership),
      label: 'Membership',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.work_outline),
      label: 'LiveOpenings',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      label: 'Profile',
    ),
  ];

  static final List<Widget> _screens = [
    const Home(),
    const ProgramsScreen(fromBottomNav: true),
    const MembershipDriveScreen(),
     LiveOpeningsScreen(showLeading: false),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedIndex.value = 0;
    });
    _initializeServices();
  }

  void _initializeServices() {
    JobsUtils.allJobs();
    InternshipUtils.allInternship();
    LocationServices.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedIndex.value != 0) {
          controller.selectedIndex.value = 0;
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => BottomNavigationBar(
        backgroundColor: Colors.white,
        items: _navigationItems,
        currentIndex: controller.selectedIndex.value,
        onTap: (index) => controller.selectedIndex.value = index,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedLabelStyle: const TextStyle(height: 1.8),
        unselectedLabelStyle: const TextStyle(height: 1.8),
        iconSize: 22,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
      ),
    );
  }
}
