import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Nearby%20Jobs/nearby_jobs_screen.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/program_detail_test.dart';
import 'package:spires_app/Screens/counsellors_screen.dart';
import 'package:spires_app/Screens/quiz_listing.dart';
import '../../../Constants/exports.dart';
import '../../../Utils/share_utils.dart';
import '../../Resumes/cv_two.dart';
import 'help_centre.dart';
import '../../../Data/programs_data.dart';

class MyDrawer extends StatefulWidget {
  final Size size;

  const MyDrawer({super.key, required this.size});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  File? image;

  pickImageFrom(ImageSource source) async {
    XFile? pickedImg = await ImagePicker().pickImage(source: source);
    if (pickedImg != null) {
      image = File(pickedImg.path);
      Get.back();
      ProfileUtils.updateDP(imagePath: image!.path);
    } else {
      Fluttertoast.showToast(msg: 'No Files selected');
    }
  }

  final c = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              Obx(() => c.isGuestMode.value 
                ? _buildGuestHeader()
                : _buildUserHeader()),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView(
                  children: [
                    ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(
                        'LEARNING & DEVELOPMENT',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          fontFamily: fontFamily,
                        ),
                      ),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: ProgramsData.programs.length,
                          itemBuilder: (context, index) {
                            final program = ProgramsData.programs[index];
                            final iconMap = {
                              'SkillUp 1.0': 'skills',
                              'Resume Workshop': 'curriculum-vitae',
                              'Interview Preparation': 'question',
                              'Coding Clubs': 'coding',
                              'Basic Computer': 'computer_icon',
                              'Digital Marketing': 'digitalocean',
                              'Graphic Designing': 'graphic-eq',
                              'Website Development': 'coding-website',
                              'Quiz': 'Quiz',
                            };

                            return ListTile(
                              dense: true,
                              onTap: () => Get.to(() => ProgramDetailTest(
                                    imageUrl: program.imageUrl,
                                    title: program.title,
                                    description: program.description,
                                    benefits: program.benefits,
                                    faqs: program.faqs,
                                    howItWorks: program.howItWorks,
                                  )),
                              leading: Image.asset(
                                'assets/icons/${iconMap[program.title]}.png',
                                color: primaryColor,
                                height: 20,
                                width: 20,
                              ),
                              title: Text(
                                program.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: fontFamily,
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          dense: true,
                          onTap: () => Get.to(() => const Jobs()),
                          leading: Icon(Icons.work_outlined,
                              color: primaryColor, size: 20),
                          title: Text(
                            'Jobs',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () => Get.to(() => const Internship()),
                          leading: Icon(Icons.workspace_premium,
                              color: primaryColor, size: 20),
                          title: Text(
                            'Internships',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () => Get.to(() => NearbyJobsScreen()),
                          leading: Icon(Icons.location_on,
                              color: primaryColor, size: 20),
                          title: Text(
                            'Nearby Jobs',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () => Get.to(() => QuizListScreen()),
                          leading: Icon(Icons.quiz_outlined,
                              color: primaryColor, size: 20),
                          title: Text(
                            'Quiz',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () => Get.to(() => const CounsellorsScreen()),
                          leading: Icon(
                            Icons.psychology_outlined,
                            color: primaryColor,
                            size: 20,
                          ),
                          title: Text(
                            'Career Counsellors',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(() => c.isGuestMode.value 
                      ? _buildGuestOptions()
                      : _buildUserOptions()),
                    ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(
                        'SUPPORT & LEGAL',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          fontFamily: fontFamily,
                        ),
                      ),
                      children: [
                        ListTile(
                          dense: true,
                          onTap: () => Get.to(() => const HelpCentre()),
                          leading: const Icon(Icons.help_outline,
                              color: primaryColor, size: 20),
                          title: Text(
                            'Help Center',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () => openPrivacyPolicy(),
                          leading: const Icon(Icons.privacy_tip_outlined,
                              color: primaryColor, size: 20),
                          title: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () => openTermOfUse(),
                          leading: const Icon(Icons.description_outlined,
                              color: primaryColor, size: 20),
                          title: Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () => openRefundPolicy(),
                          leading: const Icon(Icons.currency_exchange,
                              color: primaryColor, size: 20),
                          title: Text(
                            'Refund Policy',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      dense: true,
                      onTap: () => ShareUtils.shareAppLink(context,
                          'https://play.google.com/store/apps/details?id=com.atc.spires_app&hl=en-IN'),
                      leading: const Icon(Icons.share_outlined,
                          color: primaryColor, size: 20),
                      title: Text(
                        'Share App',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontFamily: fontFamily,
                        ),
                      ),
                    ),
                    Obx(() => c.isGuestMode.value 
                      ? _buildSignInOption()
                      : _buildLogoutOption()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '$appName\nUnit of Act T Connect (P) Ltd.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildGuestHeader() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      height: 100,
      width: widget.size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(profileBanner), fit: BoxFit.cover),
          color: bannerBgColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(width: widget.size.width * 0.04),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guest Mode',
                  style: TextStyle(
                    fontSize: 16,
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.to(() => LoginScreen(), transition: Transition.rightToLeft);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUserHeader() {
    return GestureDetector(
      onTap: () {
        Get.back(); // Close drawer first
        c.selectedIndex.value =
            4; // Use the existing controller instance
      },
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        height: 100,
        width: widget.size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(profileBanner), fit: BoxFit.cover),
            color: bannerBgColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  profilePic(),
                  if (c.isSubscribed.value ||
                      MyController.subscribed == '1')
                    Container(
                      height: 24,
                      margin: const EdgeInsets.only(top: 4),
                      child: myButton(
                        onPressed: () => Get.to(() => ResumeScreen()),
                        label: 'Build Instant CV',
                        color: Colors.white12,
                        style: smallWhiteText,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: widget.size.width * 0.04),
            Expanded(
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${MyController.userFirstName} ${MyController.userLastName}',
                            style: TextStyle(
                              fontSize: 14,
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                        if (c.isSubscribed.value ||
                            MyController.subscribed == '1')
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.workspace_premium,
                              color: whiteColor,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      MyController.userEmail,
                      style: TextStyle(
                        fontSize: 12,
                        color: whiteColor,
                        fontFamily: fontFamily,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      MyController.userPhone,
                      style: TextStyle(
                        fontSize: 12,
                        color: whiteColor,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGuestOptions() {
    return ListTile(
      dense: true,
      onTap: () {
        Get.back();
        Get.to(() => SignUpScreen(), transition: Transition.rightToLeft);
      },
      leading: const Icon(
        Icons.person_add_outlined,
        color: primaryColor,
        size: 20,
      ),
      title: Text(
        'Create Account',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
  
  Widget _buildUserOptions() {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        'ACCOUNT SETTINGS',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontFamily: fontFamily,
        ),
      ),
      children: [
        ListTile(
          dense: true,
          onTap: () => Get.to(() => const UpdatePassword()),
          leading: const Icon(Icons.lock_outline,
              color: primaryColor, size: 20),
          title: Text(
            'Change Password',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontFamily: fontFamily,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSignInOption() {
    return ListTile(
      dense: true,
      onTap: () {
        Get.back();
        Get.to(() => LoginScreen(), transition: Transition.rightToLeft);
      },
      leading: const Icon(
        Icons.login,
        color: primaryColor,
        size: 20,
      ),
      title: Text(
        'Sign In',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
  
  Widget _buildLogoutOption() {
    return ListTile(
      dense: true,
      onTap: () => logoutfn(),
      leading: const Icon(
        Icons.logout,
        color: primaryColor,
        size: 20,
      ),
      title: Text(
        'Logout',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
      ),
    );
  }

  Widget buildItem(String title, IconData iconData, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: primaryColor,
            child: Icon(
              iconData,
              color: whiteColor,
            ),
          ),
          const SizedBox(height: 3),
          Text(title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontFamily: fontFamily,
              )),
        ],
      ),
    );
  }

  ListTile buildTile(
      {required void Function() onTap,
      required IconData iconData,
      required String title}) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      onTap: onTap,
      visualDensity: VisualDensity.compact,
      dense: true,
      tileColor: whiteColor,
      leading: Icon(
        iconData,
        color: primaryColor,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
      ),
    );
  }

  profilePic() {
    return Obx(() => c.isDpLoading.value
        ? loadingProfileDP()
        : c.profileImg.value == ''
            ? Stack(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        profileImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: whiteColor, width: 1),
                      ),
                      child: InkWell(
                        onTap: () => showImagePickerDialog(),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 12,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        imageUrl: c.profileImg.value.isURL
                            ? c.profileImg.value
                            : '$imgPath/${c.profileImg.value}',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: whiteColor, width: 1),
                      ),
                      child: InkWell(
                        onTap: () => showImagePickerDialog(),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  loadingProfileDP() {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: FileImage(image!),
          opacity: 0.3,
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  showImagePickerDialog() {
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Profile Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: fontFamily,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                onTap: () => pickImageFrom(ImageSource.gallery),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                onTap: () => pickImageFrom(ImageSource.camera),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                title: Text(
                  'Take a Photo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}

Future<void> openRefundPolicy() async {
  final Uri url = Uri.parse('https://spiresrecruit.com/refund-policy');
  if (!await canLaunchUrl(url)) {
    throw Exception('Could not launch $url');
  } else {
    await launchUrl(url);
  }
}

Future<void> openTermOfUse() async {
  final Uri url = Uri.parse('https://spiresrecruit.com/terms-of-use');
  if (!await canLaunchUrl(url)) {
    throw Exception('Could not launch $url');
  } else {
    await launchUrl(url);
  }
}

Future<void> openPrivacyPolicy() async {
  final Uri url = Uri.parse('https://spiresrecruit.com/privacy-policy');
  if (!await canLaunchUrl(url)) {
    throw Exception('Could not launch $url');
  } else {
    await launchUrl(url);
  }
}
