import 'package:flutter/material.dart';
import '../Constants/exports.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms and Conditions',
          style: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spires Recruit Terms of Use',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSectionTitle('Introduction'),
            _buildParagraph('These Terms of Use apply when you use our Talent Acquisition Platform and services operated by Spires Recruit.'),
            
            const SizedBox(height: 16),
            _buildSectionTitle('Platform Purpose'),
            _buildSubSection('Our Platform Helps:', [
              'Manage job opportunities via the Candidate Portal',
              'Assist customers in finding their next hires',
              'Provide tools for tracking and managing applications'
            ]),
            
            const SizedBox(height: 16),
            _buildSectionTitle('Personal Account'),
            _buildParagraph('You can create a personal account (Candidate Portal) to track your job applications. Registration requires an email address and password.'),
            _buildSubSection('Account Responsibilities:', [
              'Provide complete and accurate information',
              'Maintain confidentiality of account credentials',
              'Immediately report unauthorized usage',
              'Not share account credentials with others'
            ]),
            
            const SizedBox(height: 16),
            _buildSectionTitle('Prohibited Actions'),
            _buildSubSection('You Agree Not To:', [
              'Violate any applicable laws',
              'Use offensive usernames',
              'Access another user\'s account',
              'Upload illegal or infringing content',
              'Engage in spam or unsolicited messaging',
              'Harvest user information without consent'
            ]),
            
            const SizedBox(height: 16),
            _buildSectionTitle('Intellectual Property'),
            _buildParagraph('All platform intellectual property rights, including software, technologies, and designs, are the exclusive property of Spires Recruit.'),
            
            const SizedBox(height: 16),
            _buildSectionTitle('Termination'),
            _buildParagraph('You can terminate your Candidate Profile at any time. Spires Recruit may suspend services if you violate these Terms of Use.'),
            
            const SizedBox(height: 16),
            _buildSectionTitle('Changes to Terms'),
            _buildParagraph('We reserve the right to modify these Terms of Use. Significant changes will be notified via email or site notice.'),
            
            const SizedBox(height: 16),
            _buildSectionTitle('Contact Information'),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: primaryColor,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontFamily: fontFamily,
        ),
      ),
    );
  }

  Widget _buildSubSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
            ),
          ),
        ),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactRow('Support Email', 'support@spiresrecruit.com'),
        _buildContactRow('Info Email', 'info@spiresrecruit.com'),
      ],
    );
  }

  Widget _buildContactRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            fontFamily: fontFamily,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
} 