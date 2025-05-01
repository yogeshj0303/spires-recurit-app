import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spires_app/Constants/exports.dart';

class CounsellorsScreen extends StatelessWidget {
  const CounsellorsScreen({Key? key}) : super(key: key);

  // #region Constants
  static const String _defaultImageUrl =
      'https://www.spiresrecruit.com/uploads/counsellors/default_profile.jpg';
  static const List<String> _counsellorImages = [
    'https://www.spiresrecruit.com/uploads/counsellors/counsellor1.jpg',
    'https://www.spiresrecruit.com/uploads/counsellors/counsellor2.jpg',
    'https://www.spiresrecruit.com/uploads/counsellors/counsellor3.jpg',
    'https://www.spiresrecruit.com/uploads/counsellors/counsellor4.jpg',
    'https://www.spiresrecruit.com/uploads/counsellors/counsellor5.jpg',
    'https://www.spiresrecruit.com/uploads/counsellors/counsellor6.jpg',
  ];
  // #endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  // #region AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Colors.grey[800],
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Career Counsellors',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'Find your perfect mentor',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            children: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: Colors.grey[800],
                  ),
                ),
                onPressed: () {
                  // Implement search
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 20,
                    color: primaryColor,
                  ),
                ),
                onPressed: () => _showChatForm(context),
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.grey[200],
        ),
      ),
    );
  }
  // #endregion

  // #region Body Components
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(),
          _buildFilterSection(),
          _buildCounsellorsGrid(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 16), // Reduced margins
      padding: const EdgeInsets.all(16), // Reduced padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.9),
            primaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '20+ Expert Counsellors',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12), // Reduced spacing
          const Text(
            'Find Your Perfect\nCareer Path',
            style: TextStyle(
              fontSize: 24, // Reduced font size
              height: 1.2,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4), // Reduced spacing
          Text(
            'Get personalized guidance from industry experts',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expertise',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildFilterChip('All', isSelected: true),
                _buildFilterChip('Career Development'),
                _buildFilterChip('Study Abroad'),
                _buildFilterChip('Professional Growth'),
                _buildFilterChip('Industry Expert'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounsellorsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12), // Consistent padding
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.58, // Adjusted for more compact cards
          crossAxisSpacing: 8, // Reduced spacing
          mainAxisSpacing: 8, // Reduced spacing
        ),
        itemCount: _counsellorImages.length,
        itemBuilder: (context, index) => AnimatedContainer(
          duration: Duration(milliseconds: 200 + (index * 100)),
          curve: Curves.easeInOut,
          child: _buildCounsellorCard(
            name: "Dr. Sarah Johnson",
            imageUrl: _counsellorImages[index],
            expertise: "Career Development",
            experience: "${10 + index}+ years",
            rating: 4.5 + (index * 0.1),
            reviewCount: 50 + (index * 10),
            specializations: ["Career Guidance", "Study Abroad"],
          ),
        ),
      ),
    );
  }
  // #endregion

  // #region Card Components
  Widget _buildCounsellorCard({
    required String name,
    required String imageUrl,
    required String expertise,
    required String experience,
    required double rating,
    required int reviewCount,
    required List<String> specializations,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardImageSection(imageUrl, experience),
            _buildCardContentSection(
              name: name,
              expertise: expertise,
              rating: rating,
              reviewCount: reviewCount,
              specializations: specializations,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImageSection(String imageUrl, String experience) {
    return Stack(
      children: [
        Hero(
          tag: 'counsellor_$imageUrl',
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: 120, // Reduced height
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildImagePlaceholder(),
            errorWidget: (context, url, error) => _buildImageError(),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: _buildExperienceBadge(experience),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: Colors.grey[100],
      child: Icon(Icons.person, size: 40, color: Colors.grey[400]),
    );
  }

  Widget _buildExperienceBadge(String experience) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            size: 14,
            color: primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            experience,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContentSection({
    required String name,
    required String expertise,
    required double rating,
    required int reviewCount,
    required List<String> specializations,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNameAndRating(name, rating, reviewCount),
            const SizedBox(height: 4), // Reduced spacing
            _buildSpecializations(specializations),
            const SizedBox(height: 12), // Reduced spacing
            _buildBookButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameAndRating(String name, double rating, int reviewCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              size: 16,
              color: Colors.amber[700],
            ),
            const SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' ($reviewCount)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecializations(List<String> specializations) {
    return Wrap(
      spacing: 2, // Reduced spacing
      runSpacing: 2, // Reduced spacing
      children: specializations
          .map((spec) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2), // Reduced padding
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  spec,
                  style: TextStyle(
                    fontSize: 10,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      height: 32, // Fixed compact height
      child: ElevatedButton.icon(
        onPressed: () async {
          final url = "https://wa.me/+919329143659";
          try {
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch WhatsApp';
            }
          } catch (e) {
            // Handle error
          }
        },
        icon: Image.asset(
          'assets/icons/whatsapp.png',
          width: 20,
          height: 20,
          // color: Colors.white,
        ),
        label: const Text(
          'Connect',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade300,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 0), // Removed padding
          minimumSize: const Size.fromHeight(32), // Fixed height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
  // #endregion

  // #endregion

  // #region Helper Methods
  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        onSelected: (bool selected) {
          // Implement filter logic
        },
        backgroundColor:
            isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
        side:
            BorderSide(color: isSelected ? primaryColor : Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: TextStyle(
          color: isSelected ? primaryColor : Colors.grey[800],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showChatForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String email = '';
    String phone = '';
    String message = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Modern Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Attractive Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.headset_mic_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Talk to Our Counsellors',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'We usually respond within an hour',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      _buildEnhancedFormField(
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        icon: Icons.person_outline_rounded,
                        onChanged: (value) => name = value,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 20),
                      _buildEnhancedFormField(
                        label: 'Email Address',
                        hint: 'Enter your email',
                        icon: Icons.email_outlined,
                        onChanged: (value) => email = value,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Email is required' : null,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      _buildEnhancedFormField(
                        label: 'Phone Number',
                        hint: 'Enter your phone number',
                        icon: Icons.phone_outlined,
                        onChanged: (value) => phone = value,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Phone is required' : null,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      _buildEnhancedFormField(
                        label: 'Message',
                        hint: 'How can we help you?',
                        icon: Icons.message_outlined,
                        onChanged: (value) => message = value,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Message is required'
                            : null,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Enhanced Submit Button
            Container(
              padding: EdgeInsets.fromLTRB(
                  20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    // TODO: Implement form submission
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Send Message',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.send_rounded, size: 20, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedFormField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: onChanged,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                icon,
                size: 22,
                color: Colors.grey[400],
              ),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 0,
            ),
          ),
        ),
      ],
    );
  }
  // #endregion
}
