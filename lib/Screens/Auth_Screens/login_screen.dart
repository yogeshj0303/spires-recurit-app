import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Constants/exports.dart';
import '../Main_Screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final loginKey = GlobalKey<FormState>();
    final c = Get.put(MyController());


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Obx(
        () => c.isLoginLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,  // Responsive padding
                    vertical: size.height * 0.02,
                  ),
                  child: Form(
                    key: loginKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.06),
                        // Logo section with animation
                        TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 800),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Hero(
                                tag: 'app_logo',
                                child: Image.asset(
                                  appLogo, 
                                  height: size.height * 0.15,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: size.height * 0.04),
                        // Welcome text section
                        Text(
                          "Welcome Back",
                          style: xLargeColorText.copyWith(
                            fontSize: size.width * 0.07,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "Good to see you again,",
                          textAlign: TextAlign.center,
                          style: normalLightText.copyWith(
                            fontSize: size.width * 0.04,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        // Email field
                        TextFormField(
                          controller: emailController,
                          style: TextStyle(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Your Email',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(
                                Icons.email_outlined,
                                color: primaryColor.withOpacity(0.7),
                                size: size.width * 0.06,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: primaryColor, width: 1.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.red[300]!, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.red[300]!, width: 1.5),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                              vertical: size.height * 0.02,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                        // Password field with same styling as email field
                        TextFormField(
                          controller: passController,
                          obscureText: true,
                          style: TextStyle(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(
                                Icons.lock_outline,
                                color: primaryColor.withOpacity(0.7),
                                size: size.width * 0.06,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: primaryColor, width: 1.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.red[300]!, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.red[300]!, width: 1.5),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                              vertical: size.height * 0.02,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                        forgetPass(),
                        SizedBox(height: size.height * 0.04),
                        // Login button
                        Container(
                          width: double.infinity,
                          height: size.height * 0.065,
                          child: loginButton(),
                        ),
                        SizedBox(height: size.height * 0.02),
                        // Continue as Guest button
                        continueAsGuestButton(),
                        const Spacer(),
                        donthaveAccount(),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget forgetPass() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.to(() => ForgetPassword()),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          "Forgot Password?",
          style: normalColorText.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return ElevatedButton(
      onPressed: () async {
        final isValid = loginKey.currentState!.validate();
        if (isValid) {
          // Set guest mode to false when logging in
          c.isGuestMode.value = false;
          
          // Clear guest mode in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_guest_mode', false);
          
          // Clear any existing olympiad user ID
          await prefs.remove('olympiad_user_id');
          
          // Set user type for main login
          await prefs.setString('user_type', 'user');
          
          // Regular login flow
          AuthUtils.getLogin(
              email: emailController.text, pass: passController.text);
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        // padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        "Login",
        style: normalWhiteText.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget continueAsGuestButton() {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () async {
          // Set guest mode
          c.isGuestMode.value = true;
          
          // Save guest mode state to SharedPreferences and clear any existing login credentials
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_guest_mode', true);
          await prefs.remove('email');
          await prefs.remove('pass');
          
          // Navigate to main screen
          Get.offAll(() => MainScreen());
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          "Continue as Guest",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget donthaveAccount() {
    return TextButton(
      onPressed: () => Get.to(() => SignUpScreen()),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don't have an account? ",
              style: normalLightText.copyWith(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            TextSpan(
              text: "Sign Up",
              style: TextStyle(
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationThickness: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
