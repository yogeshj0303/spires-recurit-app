import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Models/counsellor_model.dart';
import 'package:spires_app/Services/api_service.dart';

class CounsellorsScreen extends StatefulWidget {
  const CounsellorsScreen({Key? key}) : super(key: key);

  @override
  State<CounsellorsScreen> createState() => _CounsellorsScreenState();
}

class _CounsellorsScreenState extends State<CounsellorsScreen> {
  // #region Constants
  static const String _defaultImageUrl =
      'https://www.spiresrecruit.com/uploads/counsellors/default_profile.jpg';
  // #endregion

  List<Counsellor> counsellors = [];
  List<Counsellor> filteredCounsellors = [];
  bool isLoading = true;
  bool isSearching = false;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchCounsellors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchCounsellors() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await ApiService.fetchCounsellors();
      
      setState(() {
        counsellors = response.data;
        filteredCounsellors = counsellors;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load counsellors: $e';
        isLoading = false;
      });
    }
  }

  void _filterCounsellors(String query) {
    setState(() {
      if (query.isEmpty && _selectedFilter == 'All') {
        filteredCounsellors = counsellors;
      } else {
        filteredCounsellors = counsellors.where((counsellor) {
          final nameMatch = counsellor.name.toLowerCase().contains(query.toLowerCase());
          final specialityMatch = counsellor.speciality.toLowerCase().contains(query.toLowerCase());
          final addressMatch = counsellor.address.toLowerCase().contains(query.toLowerCase());
          final servicesMatch = counsellor.services.any((service) => 
            service.title.toLowerCase().contains(query.toLowerCase()));
          
          bool filterMatch = true;
          if (_selectedFilter != 'All') {
            filterMatch = counsellor.speciality.contains(_selectedFilter) || 
                          counsellor.services.any((service) => service.title.contains(_selectedFilter));
          }
          
          return (nameMatch || specialityMatch || addressMatch || servicesMatch) && filterMatch;
        }).toList();
      }
    });
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filterCounsellors(_searchController.text);
    });
  }

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
    if (isSearching) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 40,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey[800],
          ),
          onPressed: () {
            setState(() {
              isSearching = false;
              _searchController.clear();
              _filterCounsellors('');
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search counsellors...',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
            border: InputBorder.none,
          ),
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
          ),
          onChanged: _filterCounsellors,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey[700],
              ),
              onPressed: () {
                _searchController.clear();
                _filterCounsellors('');
              },
            ),
        ],
      );
    }

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
                  setState(() {
                    isSearching = true;
                  });
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _searchFocusNode.requestFocus();
                  });
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
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );
    }
    
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchCounsellors,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (counsellors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No counsellors available at the moment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchCounsellors,
      color: primaryColor,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSearching) _buildHeaderSection(),
                _buildFilterSection(),
                _buildCounsellorsGrid(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (isSearching && _searchController.text.isNotEmpty && filteredCounsellors.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No results found for "${_searchController.text}"',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try different keywords or reset filters',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _selectedFilter = 'All';
                        _filterCounsellors('');
                      });
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Reset Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
              '${counsellors.length}+ Expert Counsellors',
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
    // For a cleaner UI, don't show filters when searching to focus on search results
    if (isSearching && _searchController.text.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Row(
          children: [
            Icon(
              Icons.filter_list_rounded,
              size: 16,
              color: Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Text(
              'Results for "${_searchController.text}"',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            const Spacer(),
            if (_selectedFilter != 'All')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Filter: $_selectedFilter',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedFilter = 'All';
                          _filterCounsellors(_searchController.text);
                        });
                      },
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    // Get unique specialties from counsellors
    final Set<String> specialties = {'All'};
    for (final counsellor in counsellors) {
      // Add speciality and services as filters
      if (counsellor.speciality.isNotEmpty) {
        final specialityKeywords = counsellor.speciality.split(', ');
        specialties.addAll(specialityKeywords);
      }
      
      for (final service in counsellor.services) {
        specialties.add(service.title);
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expertise',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              if (_selectedFilter != 'All')
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFilter = 'All';
                      _filterCounsellors(_searchController.text);
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.clear_all,
                        size: 16,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Clear Filters',
                        style: TextStyle(
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: specialties
                  .toList()
                  .map((specialty) => _buildFilterChip(
                      specialty, isSelected: _selectedFilter == specialty))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounsellorsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: filteredCounsellors.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No counsellors match your search',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _selectedFilter = 'All';
                          isSearching = false;
                          _filterCounsellors('');
                        });
                      },
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Reset Filters'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'Found ${filteredCounsellors.length} counsellors',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.58,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredCounsellors.length,
                  itemBuilder: (context, index) {
                    final counsellor = filteredCounsellors[index];
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 200 + (index * 100)),
                      curve: Curves.easeInOut,
                      child: _buildCounsellorCard(
                        name: counsellor.name,
                        imageUrl: counsellor.image,
                        expertise: counsellor.speciality,
                        experience: counsellor.experience,
                        rating: 4.5 + (index * 0.1 > 0.4 ? 0.4 : index * 0.1),
                        reviewCount: 50 + (index * 10),
                        specializations: counsellor.services.map((service) => service.title).toList(),
                        contactNumber: counsellor.contactNumber,
                      ),
                    );
                  },
                ),
              ],
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
    required String contactNumber,
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
            Expanded(
              child: _buildCardContentSection(
                name: name,
                expertise: expertise,
                rating: rating,
                reviewCount: reviewCount,
                specializations: specializations,
                contactNumber: contactNumber,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImageSection(String imageUrl, String experience) {
    // Standardize the image URL handling
    String finalImageUrl = imageUrl;
    if (!imageUrl.startsWith('http')) {
      finalImageUrl = 'https://spiresrecruit.com/$imageUrl';
    }
    
    return Stack(
      children: [
        Hero(
          tag: 'counsellor_$imageUrl',
          child: CachedNetworkImage(
            imageUrl: finalImageUrl,
            height: 120,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            size: 12,
            color: primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            experience,
            style: TextStyle(
              fontSize: 8,
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
    required String contactNumber,
  }) {
    // Limit specializations to prevent overflow
    final displaySpecializations = specializations.take(2).toList();
    
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameAndRating(name, rating, reviewCount),
          const SizedBox(height: 4),
          Expanded(
            child: _buildSpecializations(displaySpecializations),
          ),
          const SizedBox(height: 8),
          _buildBookButton(contactNumber),
        ],
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
    return SingleChildScrollView(
      child: Wrap(
        spacing: 10,
        runSpacing: 4,
        children: specializations.map((spec) {
          return Container(
            // margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBookButton(String contactNumber) {
    return SizedBox(
      width: double.infinity,
      height: 32, // Fixed compact height
      child: ElevatedButton.icon(
        onPressed: () async {
          final url = "https://wa.me/+91$contactNumber";
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

  // #region Helper Methods
  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        onSelected: (bool selected) {
          _applyFilter(selected ? label : 'All');
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
