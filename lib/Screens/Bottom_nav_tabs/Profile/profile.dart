import 'package:spires_app/Screens/quiz/quiz_results_screen.dart';

import '../../../Constants/exports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  // Add this to preserve state
  @override
  bool get wantKeepAlive => true;
  
  final c = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    // Cache the guest mode value before build to avoid changes during build
    final isGuestMode = c.isGuestMode.value;
    
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          // Use a simpler approach that doesn't rely on Obx during build
          child: isGuestMode 
            ? _buildGuestModeView()
            : _buildNormalProfileView(),
        ),
      ),
    );
  }
  
  Widget _buildGuestModeView() {
    return Center(
      key: const PageStorageKey<String>('profile_guest_view'),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_circle_outlined,
                size: 60,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Guest Mode",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "You're currently browsing as a guest. Sign in or create an account to access your profile, apply for jobs, and save your progress.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => LoginScreen(), transition: Transition.rightToLeft);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.to(() => SignUpScreen(), transition: Transition.rightToLeft);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNormalProfileView() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      key: const PageStorageKey<String>('profile_normal_view'),
      child: Column(
        children: [
          const ProfileCard(),
          const SizedBox(height: defaultPadding),
          ProgressCard(),
          AboutMeCard(),
          WorkExp(),
          Education(),
          Skills(),
          CvCard(),
          // Add Quiz Results Button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuizResultsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.quiz_rounded, color: Colors.white),
                label: const Text(
                  'View Quiz Results',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
