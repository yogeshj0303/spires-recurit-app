import 'package:flutter/material.dart';
import 'package:spires_app/Data/skillup_programs_data.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/program_detail_test.dart';
import '../../../Constants/exports.dart';
import 'package:intl/intl.dart';

class SkillUpDetailsScreen extends StatefulWidget {
  const SkillUpDetailsScreen({super.key});

  @override
  State<SkillUpDetailsScreen> createState() => _SkillUpDetailsScreenState();
}

class _SkillUpDetailsScreenState extends State<SkillUpDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: const Text(
          "SkillUp 1.0 Programs",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        'assets/icons/1.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "SkillUp 1.0",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Choose from 6 specialized programs",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // Programs list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: SkillUpProgramsData.skillUpPrograms.length,
              itemBuilder: (context, index) {
                final program = SkillUpProgramsData.skillUpPrograms[index];
                // Duration and price logic
                List<String> durations;
                Map<String, int> priceMap;
                switch (index) {
                  case 0: // Basic Computer
                    durations = ['45 days', '3 months'];
                    priceMap = {'45 days': 4500, '3 months': 7000};
                    break;
                  case 1: // Digital Marketing
                    durations = ['45 days', '3 months'];
                    priceMap = {'45 days': 7000, '3 months': 13000};
                    break;
                  case 2: // Video Editing
                    durations = ['45 days', '3 months'];
                    priceMap = {'45 days': 5000, '3 months': 8500};
                    break;
                  case 3: // Graphic Designing
                    durations = ['45 days'];
                    priceMap = {'45 days': 10000};
                    break;
                  case 4: // Web Development
                    durations = ['45 days', '3 months'];
                    priceMap = {'45 days': 7000, '3 months': 13000};
                    break;
                  case 5: // Tally
                    durations = ['45 days', '3 months'];
                    priceMap = {'45 days': 3000, '3 months': 5000};
                    break;
                  default:
                    durations = ['45 days'];
                    priceMap = {'45 days': 0};
                }
                String selectedDuration = durations.first;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      final price = priceMap[selectedDuration]!;
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Banner/Image section
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Container(
                                height: 180,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: Image.asset(
                                  program.imageUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    program.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    program.description,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'Price:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.5,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green[50],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '₹${NumberFormat('#,##0').format(price)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.5,
                                            color: Colors.green[800],
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[300]!),
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white,
                                        ),
                                        child: DropdownButton<String>(
                                          value: selectedDuration,
                                          underline: SizedBox(),
                                          borderRadius: BorderRadius.circular(10),
                                          isDense: true,
                                          icon: Icon(Icons.keyboard_arrow_down, size: 20),
                                          items: durations.map((d) => DropdownMenuItem(
                                            value: d,
                                            child: Text(d, style: TextStyle(fontSize: 13)),
                                          )).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              selectedDuration = val!;
                                            });
                                          },
                                          dropdownColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepOrange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 11),
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Pay Now for ${program.title}')),
                                        );
                                      },
                                      child: const Text(
                                        'Pay Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.5,
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
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 