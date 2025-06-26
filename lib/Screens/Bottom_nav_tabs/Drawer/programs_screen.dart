import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spires_app/Data/programs_data.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Drawer/program_Details.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Drawer/skillup_details_screen.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/program_detail_test.dart';
import 'package:spires_app/Screens/Main_Screens/main_screen.dart';

import '../../../Constants/exports.dart';

class ProgramsScreen extends StatefulWidget {
  final bool fromBottomNav;
  const ProgramsScreen({super.key, this.fromBottomNav = false});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Programs",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: !widget.fromBottomNav,
        leading: !widget.fromBottomNav
            ? IconButton(
                onPressed: () => Get.offAll(() => const MainScreen()),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black87,
                  size: 18,
                ),
              )
            : null,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: ProgramsData.programs.length,
        itemBuilder: (context, index) {
          final program = ProgramsData.programs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                if (program.title == 'SkillUp 1.0') {
                  Get.to(() => const SkillUpDetailsScreen());
                } else {
                  Get.to(() => ProgramDetailTest(
                    imageUrl: program.imageUrl,
                    title: program.title,
                    description: program.description,
                    benefits: program.benefits,
                    howItWorks: program.howItWorks,
                    faqs: program.faqs,
                  ));
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.asset(
                          program.imageUrl,
                          height: 140,
                          width: double.infinity,
                          fit: program.fit ?? BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                              const SizedBox(width: 3),
                              Text(
                                "4.8",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Featured",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "2 Months",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          program.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          program.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Share.share('Check out this program: ${program.title}');
                                },
                                icon: Icon(
                                  Icons.share_rounded,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (program.title == 'SkillUp 1.0') {
                                    Get.to(() => const SkillUpDetailsScreen());
                                  } else {
                                    Get.to(() => ProgramDetailTest(
                                      imageUrl: program.imageUrl,
                                      title: program.title,
                                      description: program.description,
                                      benefits: program.benefits,
                                      howItWorks: program.howItWorks,
                                      faqs: program.faqs,
                                    ));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProgramCard extends StatefulWidget {
  Future<void> shareOnWhatsApp(String message) async {
    final String whatsappUrl =
        "whatsapp://send?text=${Uri.encodeFull(message)}";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  final String imageUrl;
  final String title;
  final String description;
  final String benefits;
  final String howItWorks;
  final List<Map<String,String>> faqs;
  final VoidCallback onShare;
  final BoxFit fit;

  const ProgramCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onShare,
    this.fit = BoxFit.cover,
    required this.benefits,
    required this.howItWorks,
    this.faqs=const [],
  }) : super(key: key);


  Widget _buildFAQ({required String question, required String answer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Q: $question',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Text(
          'A: $answer',
        ),
        SizedBox(height: 16.0),
      ],
    );
  }


  @override
  _ProgramCardState createState() => _ProgramCardState();
}

class _ProgramCardState extends State<ProgramCard> {
  bool isSaved = false;

  void toggleSave() {
    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProgramDetailTest(
                      imageUrl: widget.imageUrl,
                      title: widget.title,
                      description: widget.description,
                      benefits: widget.benefits,
                      faqs: widget.faqs,
                      howItWorks: widget.howItWorks,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  widget.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: widget.fit,
                ),
              ),
              ListTile(
                title: Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 18,
                      //add a title in single line
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                      color: primaryColor),
                ),
                // leading: Image.asset('assets/icons/graduation-hat.png', width: 28, height: 20),
                leading: const Icon(
                  Icons.school,
                  color: primaryColor,
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: primaryColor,
                    size: 18,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProgramDetailScreen(
                          imageUrl: widget.imageUrl,
                          title: widget.title,
                          description: widget.description,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 0.5,
                height: 0,
                indent: 16,
                endIndent: 16,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child:      Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      widget.shareOnWhatsApp(
                          "Check out this program: ${widget.title} - ${widget.description}");
                    },
                    child: Row(
                      children: [
                        Icon(Icons.share, color: Colors.black, size: 16),
                        SizedBox(width: 5),
                        Text("Share",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: toggleSave,
                    child: Row(
                      children: [
                        Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_outline,
                          color: isSaved ? primaryColor : Colors.black,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Save",
                          style: TextStyle(
                            color: isSaved ? primaryColor : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

