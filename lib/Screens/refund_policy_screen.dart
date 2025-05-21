import 'package:flutter/material.dart';
import '../Constants/exports.dart';

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Refund Policy',
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
              'Refund Policy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSectionTitle('Registration Fee Policy'),
            _buildSubSection('Key Points:', [
              'Registration fee is a one-time, non-refundable payment',
              'Covers processing and administrative costs',
              'Cannot be refunded under any circumstances',
              'Applies to cancellation or non-participation'
            ]),
            
            const SizedBox(height: 16),
            _buildSectionTitle('Cancellation Policy'),
            _buildParagraph('The registration fee is non-refundable in case of cancellation or withdrawal after submission. Please ensure you are certain about your participation before making the payment.'),
            
            const SizedBox(height: 16),
            _buildSectionTitle('Important Notes'),
            _buildParagraph('By paying the registration fee, you acknowledge and accept that this fee is non-refundable, regardless of the situation.'),
            
            const SizedBox(height: 16),
            _buildSectionTitle('Service Issues'),
            _buildParagraph('In case of any service issues, the registration fee will not be refunded, but corrective actions will be taken where applicable.'),
            
            const SizedBox(height: 16),
            _buildSectionTitle('Contact Support'),
            _buildParagraph('If you have any questions or concerns, please contact our support team prior to making the payment.'),
            
            const SizedBox(height: 16),
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