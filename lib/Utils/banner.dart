import 'package:carousel_slider/carousel_slider.dart';

import '../Constants/exports.dart';
import '../Screens/Resumes/cv_two.dart';
import '../Screens/Auth_Screens/login_screen.dart';

class BannerCarousel extends StatelessWidget {
  final Size size;
  final MyController c = Get.put(MyController());

  BannerCarousel({required this.size});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: size.height * 0.2,
        viewportFraction: 1.0,
        autoPlay: false,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
      ),
      items: [buildBanner1()].map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: banner,
            );
          },
        );
      }).toList(),
    );
  }

  Widget buildBanner1() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
      decoration: BoxDecoration(borderRadius: borderRadius),
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: size.height * 0.04,
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(defaultRadius),
                    topRight: Radius.circular(defaultRadius)),
              ),
              child: Row(
                children: [
                  c.location.value == ''
                      ? Container()
                      : const Icon(Icons.location_on, color: primaryColor),
                  const SizedBox(width: 4),
                  Obx(() => Expanded(
                      child: Text(c.location.value, style: smallLightText))),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: bannerBgColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(defaultRadius),
                  bottomRight: Radius.circular(defaultRadius),
                ),
              ),
              height: size.height * 0.16,
              width: size.width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Obx(
                        () => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        c.isGuestMode.value
                            ? Text(
                          "Sign in to access premium features",
                          style: normalWhiteText,
                          textAlign: TextAlign.left,
                        )
                            : c.isSubscribed.value || MyController.subscribed == '1'
                            ? Text(
                          "Congratulations!!!\nto unlock premium benefits",
                          style: normalWhiteText,
                          textAlign: TextAlign.left,
                        )
                            : Text(
                          "Upgrade to Premium\nto unlock more benefits",
                          style: normalWhiteText,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: defaultPadding),
                        c.isGuestMode.value
                            ? myButton(
                          onPressed: () => Get.to(() => LoginScreen()),
                          color: Colors.white24,
                          label: 'Sign In',
                          style: normalWhiteText,
                        )
                            : c.isSubscribed.value || MyController.subscribed == '1'
                            ? myButton(
                          onPressed: () => Get.to(() => ResumeScreen()),
                          color: Colors.white24,
                          label: 'Build Instant CV',
                          style: normalWhiteText,
                        )
                            : myButton(
                          onPressed: () =>
                              Get.to(() => const UpgradeNow()),
                          color: primaryColor,
                          label: 'Upgrade Now',
                          style: normalWhiteText,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(homeBanner, height: 200),
          ),
        ],
      ),
    );
  }

  // Widget buildBanner2() {
  //   // Build your second banner here
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 10 ),
  //       decoration: BoxDecoration(
  //         color: Color(0xFFF5D9F2), // Lighter pink background
  //         borderRadius: BorderRadius.circular(10.0),
  //       ),
  //       child: Row(
  //         children: [
  //           Container(
  //             padding: EdgeInsets.all(8.0),
  //             decoration: BoxDecoration(
  //               color: Color(0xFFFF914D), // Orange icon background
  //               shape: BoxShape.circle,
  //             ),
  //             child: Icon(
  //               Icons.warning_amber_rounded, // Notification bell icon
  //               color: Colors.white,
  //               size: 20.0,
  //             ),
  //           ),
  //           SizedBox(width: 10.0),
  //           Expanded(
  //             child: Obx(() {
  //               return RichText(
  //                 text: TextSpan(
  //                   children: [
  //                     TextSpan(
  //                       text: c.isGuestMode.value 
  //                         ? 'Sign in to create your profile and be discovered by recruiters.\n'
  //                         : 'Oops! Recruiters cannot see your profile right now.\n',
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         fontSize: 14.0,
  //                       ),
  //                     ),
  //                     TextSpan(
  //                       text: c.isGuestMode.value ? 'Create an account ' : 'Update your profile ',
  //                       style: TextStyle(
  //                         color: Color(0xFF6F35A5), // Purple color for "Update your profile"
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     TextSpan(
  //                       text: 'to be visible to recruiters.',
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget buildBanner3() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 10 ),
  //       decoration: BoxDecoration(
  //         color: Color(0xFFF5D9F2), // Lighter pink background
  //         borderRadius: BorderRadius.circular(10.0),
  //       ),
  //       child: Row(
  //         children: [
  //           Container(
  //             padding: EdgeInsets.all(8.0),
  //             decoration: BoxDecoration(
  //               color: Color(0xFFFF914D), // Orange icon background
  //               shape: BoxShape.circle,
  //             ),
  //             child: Icon(
  //               Icons.warning_amber_rounded, // Notification bell icon
  //               color: Colors.white,
  //               size: 20.0,
  //             ),
  //           ),
  //           SizedBox(width: 10.0),
  //           Expanded(
  //             child: Obx(() {
  //               return RichText(
  //                 text: TextSpan(
  //                   children: [
  //                     TextSpan(
  //                       text: c.isGuestMode.value 
  //                         ? 'Try premium features and improve your chances of getting hired!\n'
  //                         : 'Oops! Recruiters cannot see your profile right now.\n',
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         fontSize: 14.0,
  //                       ),
  //                     ),
  //                     TextSpan(
  //                       text: c.isGuestMode.value ? 'Sign in ' : 'Update your profile ',
  //                       style: TextStyle(
  //                         color: Color(0xFF6F35A5), // Purple color for "Update your profile"
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     TextSpan(
  //                       text: c.isGuestMode.value ? 'to access all features.' : 'to be visible to recruiters.',
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
