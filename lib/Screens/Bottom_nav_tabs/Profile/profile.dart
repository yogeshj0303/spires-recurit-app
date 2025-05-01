import 'package:spires_app/Screens/quiz_results_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
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
                // const SizedBox(height: defaultPadding),
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
          ),
        ),
      ),
    );
  }
}
