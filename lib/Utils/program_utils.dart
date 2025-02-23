import 'package:flutter/material.dart';
import '../Models/program_model.dart';
import '../Screens/Bottom_nav_tabs/program_detail_test.dart';

class ProgramUtils {
  static void navigateToProgram(BuildContext context, Program program) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgramDetailTest(
          imageUrl: program.imageUrl,
          title: program.title,
          description: program.description,
          benefits: program.benefits,
          faqs: program.faqs,
          howItWorks: program.howItWorks,
        ),
      ),
    );
  }
} 