import 'package:spires_app/Constants/exports.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Main_Screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MyController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Logo with subtle animation
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Image.asset(appLogo, height: 70),
                  );
                },
              ),
              const SizedBox(height: 35),
              // Main illustration
              Hero(
                tag: 'welcome_image',
                child: Image.asset(wlcmBgImg, height: 240),
              ),
              const SizedBox(height: 40),
              // Heading with gradient text
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFFFF6B00),
                    Color(0xFFFF8500),
                    primaryColor,
                  ],
                ).createShader(bounds),
                child: Text(
                  'Find Your Dream Job Here!',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                "Explore thousands of job opportunities with all the information you need.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(flex: 1),
              // Login button
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF6B00),
                      Color(0xFFFF8500),
                      primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B00).withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Get.to(
                    () => LoginScreen(),
                    transition: Transition.rightToLeft,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Register button
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFF6B00),
                    width: 1.8,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () => Get.to(() => SignUpScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Register',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF6B00),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 16),
              // // Continue as Guest button
              // TextButton(
              //   onPressed: () async {
              //     c.isGuestMode.value = true;
                  
              //     // Save guest mode state to SharedPreferences and clear any existing login credentials
              //     final prefs = await SharedPreferences.getInstance();
              //     await prefs.setBool('is_guest_mode', true);
              //     await prefs.remove('email');
              //     await prefs.remove('pass');
                  
              //     Get.offAll(() => MainScreen());
              //   },
              //   child: Text(
              //     'Continue as Guest',
              //     style: GoogleFonts.poppins(
              //       fontSize: 15,
              //       fontWeight: FontWeight.w500,
              //       color: Colors.grey[700],
              //       letterSpacing: 0.2,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
