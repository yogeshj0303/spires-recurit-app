import "package:flutter/material.dart";
import "../Data/programs_data.dart";
import "Bottom_nav_tabs/program_detail_test.dart";

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Programs", style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: ProgramsData.programs.length,
        itemBuilder: (context, index) {
          final program = ProgramsData.programs[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Image.asset(
                program.imageUrl,
                width: 60,
                height: 60,
              ),
              title: Text(
                program.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                program.description.split('.').first,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => Navigator.push(
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
              ),
            ),
          );
        },
      ),
    );
  }
}


