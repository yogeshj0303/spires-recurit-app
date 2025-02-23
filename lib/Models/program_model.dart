import 'package:spires_app/Constants/exports.dart';

class Program {
  final String imageUrl;
  final String title;
  final String description;
  final String benefits;
  final List<Map<String, String>> faqs;
  final String howItWorks;
  final BoxFit? fit;

  const Program({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.benefits,
    required this.faqs,
    required this.howItWorks,
    this.fit,
  });
} 