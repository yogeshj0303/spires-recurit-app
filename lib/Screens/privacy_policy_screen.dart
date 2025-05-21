import 'package:flutter/material.dart';
import '../Constants/exports.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
              'Welcome to spiresrecruit.com',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('1. What Personal Data does Spires collect?'),
            _buildParagraph('Spires collects Personal Data directly from you as well as from other available sources to the extent relevant and permitted by applicable local law. Spires endeavors only to collect Personal Data that are necessary for the purpose(s) for which they are collected and to retain such data for no longer than necessary for such purpose(s).'),
            _buildSubSection('Information you provide:', [
              'Your name, street address, telephone number and email address',
              'Competences, skills, experience and education',
              'Preferences for employment and contact',
              'User identity details'
            ]),
            
            const SizedBox(height: 16),
            _buildSectionTitle('2. What we will do with your Personal Data?'),
            _buildParagraph('Spires will collect, use, store and otherwise process your Personal Data for recruitment or resourcing activities.'),
            _buildSubSection('Processing purposes include:', [
              'Communicating with you about recruitment activities',
              'Managing recruitment and resourcing activities',
              'Conducting interviews and assessments',
              'Evaluating and selecting applicants'
            ]),
            
            const SizedBox(height: 16),
            _buildSectionTitle('3. Who has access to your data?'),
            _buildParagraph('Access to your Personal Data is strictly controlled and limited to persons with a clear need to know.'),
            
            const SizedBox(height: 16),
            _buildSectionTitle('4. Transfer of your Personal Data'),
            _buildParagraph('Spires will not sell, lease, rent or otherwise disclose your Personal Data except with your consent or to authorized third parties.'),
            
            const SizedBox(height: 16),
            _buildSectionTitle('5. Data Protection and Security'),
            _buildParagraph('We take privacy and security seriously, implementing appropriate measures to protect your personal information.'),
            
            const SizedBox(height: 16),
            _buildSectionTitle('6. Your Rights'),
            _buildSubSection('You have the right to:', [
              'Access your personal data',
              'Request correction or deletion',
              'Data portability',
              'Object to processing',
              'Withdraw consent',
              'Lodge a complaint'
            ]),
            
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
        _buildContactRow('Address', '93, Bajrang Colony, Jhansi, Uttar Pradesh 284128'),
        _buildContactRow('Email', 'support@spiresrecruit.com'),
        _buildContactRow('Info Email', 'info@spiresrecruit.com'),
        _buildContactRow('Support No', '+91 7753900943'),
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