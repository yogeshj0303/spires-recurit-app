import '../../../Constants/exports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  // Add this to preserve state
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Don't forget this line
    return Scaffold(
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
            ],
          ),
        ),
      ),
    );
  }
}
