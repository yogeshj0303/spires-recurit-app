import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Constants/exports.dart';
import '../Main_Screens/main_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fNameController = TextEditingController();

  final TextEditingController lNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> signInkey = GlobalKey<FormState>();

  final c = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => c.isRegLoading.value
            ? loading
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding * 2),
                  child: Form(
                    key: signInkey,
                    child: Column(
                      children: [
                        const SizedBox(height: 85),
                        Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Image.asset(appLogo, height: 85),
                        ),
                        Text(
                          "Create an Account",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: defaultPadding * 3),
                        CustomTextField(
                          controller: fNameController,
                          hintText: 'First Name',
                          iconData: Icons.account_circle,
                        ),
                        CustomTextField(
                          controller: lNameController,
                          hintText: 'Last Name',
                          iconData: Icons.account_circle,
                        ),
                        CustomTextField(
                          controller: emailController,
                          hintText: 'Your Email',
                          isEmail: true,
                          iconData: Icons.email,
                        ),
                        CustomTextField(
                          controller: mobileController,
                          hintText: 'Enter Mobile Number',
                          isPhone: true,
                          keyboardType: TextInputType.phone,
                          iconData: Icons.phone_android,
                        ),
                        CustomTextField(
                          controller: passController,
                          hintText: 'Enter Password',
                          isPassword: true,
                          iconData: Icons.lock,
                        ),
                        const SizedBox(height: defaultPadding * 2),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              final isValid = signInkey.currentState!.validate();
                              if (isValid) {
                                AuthUtils.getRegistered(
                                  fname: fNameController.text,
                                  lname: lNameController.text,
                                  email: emailController.text,
                                  pass: passController.text,
                                  phone: mobileController.text,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding * 2),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account ?  ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                              ),
                              TextSpan(
                                text: "Login",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.to(() => LoginScreen()),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  ElevatedButton signupButton() {
    return ElevatedButton(
      onPressed: () {
        final isValid = signInkey.currentState!.validate();
        if (isValid) {
          AuthUtils.getRegistered(
            fname: fNameController.text,
            lname: lNameController.text,
            email: emailController.text,
            pass: passController.text,
            phone: mobileController.text,
          );
        }
      },
      child: Text(
        'Sign up',
        style: normalWhiteText,
      ),
    );
  }

  ElevatedButton signupwithGoogle() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(googleIcon, width: 30),
          const SizedBox(width: 10),
          Text(
            "Sign up with Google",
            style: normalLightText,
          ),
        ],
      ),
    );
  }

  RichText alreadyHaveAc() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Already have an account ?  ",
            style: normalLightText,
          ),
          TextSpan(
            text: "Login",
            style: const TextStyle(
              fontSize: 16,
              color: primaryColor,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.to(() => LoginScreen()),
          ),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
}
