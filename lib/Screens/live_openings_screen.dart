import 'package:flutter/material.dart';
import '../Constants/exports.dart';
import '../Model/job_model.dart';
import 'dart:async';
import 'dart:math';

class LiveOpeningsScreen extends StatefulWidget {
  final bool showLeading;

  LiveOpeningsScreen({
    Key? key,
    this.showLeading = false,
  }) : super(key: key);

  @override
  State<LiveOpeningsScreen> createState() => _LiveOpeningsScreenState();
}

class _LiveOpeningsScreenState extends State<LiveOpeningsScreen> {
  final c = Get.put(MyController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxList<Data> filteredJobs = <Data>[].obs;
  Timer? _debounceTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Shuffle jobs when screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _shuffleJobs();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _shuffleJobs() {
    // This will be called when we have job data to shuffle
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      searchQuery.value = value;
      _updateFilteredJobs();
    });
  }

  void _clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    // Clear filtered jobs to trigger reshuffle when showing all jobs
    filteredJobs.clear();
  }

  void _refreshJobs() {
    // Clear search and reshuffle jobs
    searchController.clear();
    searchQuery.value = '';
    filteredJobs.clear();
  }

  void _updateFilteredJobs() {
    // This will be called when we have the job data
  }

  void shareJobs(int jobId) {
    // Share job functionality
    Share.share('Check out this job opportunity! Job ID: $jobId');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 56,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.8),
                ],
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SPIRES RECRUIT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Live Openings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          leading: widget.showLeading
              ? Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    splashRadius: 24,
                  ),
                )
              : null,
          actions: [
            // Refresh button to reshuffle jobs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                onPressed: _refreshJobs,
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                splashRadius: 24,
                tooltip: 'Refresh jobs',
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.work_outline_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Live Vacancies',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 2),
                        FutureBuilder<JobModel>(
                          future: JobsUtils.allJobs(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final jobCount = snapshot.data!.data!.length;
                              return Text(
                                '$jobCount positions available',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              );
                            }
                            return Text(
                              'Loading...',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search for jobs...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.grey.shade600,
                        size: 22,
                      ),
                      suffixIcon: Obx(() => searchQuery.value.isNotEmpty
                          ? IconButton(
                              onPressed: _clearSearch,
                              icon: Icon(
                                Icons.clear_rounded,
                                color: Colors.grey.shade600,
                                size: 20,
                              ),
                            )
                          : const SizedBox.shrink()),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryColor, width: 1.5),
                      ),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  // Search results indicator
                  Obx(() {
                    if (searchQuery.value.isNotEmpty) {
                      return FutureBuilder<JobModel>(
                        future: JobsUtils.allJobs(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final allJobs = snapshot.data!.data!;
                            final query = searchQuery.value.toLowerCase().trim();
                            final filteredCount = allJobs.where((job) {
                              // Search in job title
                              if (job.jobTitle?.toLowerCase().contains(query) == true) {
                                return true;
                              }
                              
                              // Search in company name
                              if (job.admin?.username?.toLowerCase().contains(query) == true) {
                                return true;
                              }
                              
                              // Search in location
                              if (job.location?.toLowerCase().contains(query) == true) {
                                return true;
                              }
                              
                              // Search in job type
                              if (job.jobType?.toLowerCase().contains(query) == true) {
                                return true;
                              }
                              
                              // Search in skills
                              if (job.skills?.toLowerCase().contains(query) == true) {
                                return true;
                              }
                              
                              return false;
                            }).length;
                            final totalCount = allJobs.length;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Found $filteredCount of $totalCount jobs',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () => c.isJobLoading.value
                    ? cardShimmer(size)
                    : FutureBuilder<JobModel>(
                        future: JobsUtils.allJobs(),
                        builder: (context, snapshot) => snapshot.hasData
                            ? snapshot.data!.data!.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.work_outline,
                                          size: 64,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No Jobs Available',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Check back later for new opportunities',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Obx(() {
                                    // Update filtered jobs when search changes
                                    final allJobs = snapshot.data!.data!;
                                    if (searchQuery.value.isEmpty) {
                                      // Shuffle jobs only when showing all jobs (not during search)
                                      if (filteredJobs.isEmpty) {
                                        // First time loading or after search is cleared
                                        final shuffledJobs = List<Data>.from(allJobs);
                                        shuffledJobs.shuffle(_random);
                                        filteredJobs.value = shuffledJobs;
                                      }
                                    } else {
                                      // During search, don't shuffle - just filter
                                      final query = searchQuery.value.toLowerCase().trim();
                                      filteredJobs.value = allJobs.where((job) {
                                        // Search in job title
                                        if (job.jobTitle?.toLowerCase().contains(query) == true) {
                                          return true;
                                        }
                                        
                                        // Search in company name
                                        if (job.admin?.username?.toLowerCase().contains(query) == true) {
                                          return true;
                                        }
                                        
                                        // Search in location
                                        if (job.location?.toLowerCase().contains(query) == true) {
                                          return true;
                                        }
                                        
                                        // Search in job type
                                        if (job.jobType?.toLowerCase().contains(query) == true) {
                                          return true;
                                        }
                                        
                                        // Search in skills
                                        if (job.skills?.toLowerCase().contains(query) == true) {
                                          return true;
                                        }
                                        
                                        return false;
                                      }).toList();
                                    }
                                    
                                    return ListView.builder(
                                      key: const PageStorageKey('live_openings_list'),
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      itemCount: filteredJobs.length,
                                      itemBuilder: (context, index) {
                                        // Add bounds checking to prevent RangeError
                                        if (index >= filteredJobs.length) {
                                          return const SizedBox.shrink();
                                        }
                                        final item = filteredJobs[index];
                                        return _buildJobCard(item, size, snapshot);
                                      },
                                    );
                                  })
                            : Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(
      Data item,
      Size size,
      AsyncSnapshot<JobModel> originalSnapshot,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [primaryColor.withOpacity(0.1), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.jobTitle!,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.admin?.username ?? 'Unknown Company',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildActiveIndicator(),
              ],
            ),
          ),
          
          // Job details section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              children: [
                // Info rows
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icon(Icons.work_outline, size: 18, color: primaryColor),
                        text: item.jobType!,
                        label: 'Job Type',
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icon(Icons.payments_outlined, size: 18, color: primaryColor),
                        text: '₹${int.parse(item.salary!) * 12} p.a.',
                        label: 'Salary',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icon(Icons.timeline, size: 18, color: primaryColor),
                        text: '${item.experience}+ years',
                        label: 'Experience',
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icon(Icons.location_on_outlined, size: 18, color: primaryColor),
                        text: item.location!,
                        label: 'Location',
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                
                // Bottom actions
                Row(
                  children: [
                    // Job Type Tag
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primaryColor.withOpacity(0.2)),
                        ),
                        child: Text(
                          item.jobType!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Action Buttons Row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Share Button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => shareJobs(item.id!.toInt()),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.share_outlined,
                                size: 20,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // View Details Button
                        InkWell(
                          onTap: () {
                            // Find the original index of this item in the full list
                            final originalIndex = originalSnapshot.data!.data!.indexOf(item);
                            if (originalIndex != -1) {
                              Get.to(() => JobDetails(
                                snapshot: originalSnapshot, 
                                index: originalIndex
                              ));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveIndicator() {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Active',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required Widget icon,
    required String text,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
