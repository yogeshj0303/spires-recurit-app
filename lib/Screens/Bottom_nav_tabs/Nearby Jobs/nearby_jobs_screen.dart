import 'package:flutter/material.dart';
import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Nearby%20Jobs/nearby_job_controller.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/Jobs/job_details.dart';
import 'package:spires_app/Model/job_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyJobsScreen extends StatelessWidget {
  final controller = Get.put(NearbyJobController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Nearby Jobs', 
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Filter functionality
              Fluttertoast.showToast(msg: 'Filter options coming soon');
            },
            icon: Icon(Icons.filter_alt_outlined, color: Colors.grey[800]),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildJobsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: searchController,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          color: Colors.black87,
        ),
        onChanged: (value) {
          controller.searchQuery.value = value;
          controller.filterJobs();
        },
        decoration: InputDecoration(
          hintText: 'Search for nearby jobs...',
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
          suffixIcon: IconButton(
            icon: Icon(
              Icons.location_on_rounded,
              color: primaryColor,
              size: 22,
            ),
            onPressed: () {
              controller.useCurrentLocation();
            },
          ),
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
      ),
    );
  }

  Widget _buildJobsList() {
    return Obx(() {
      if (controller.isDataLoading.value || controller.isNLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              Text(
                'Finding the best jobs for you...',
                style: TextStyle(
                  color: Colors.grey[700], 
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait a moment',
                style: TextStyle(
                  color: Colors.grey[500], 
                  fontSize: 13,
                  fontFamily: 'Poppins'
                ),
              ),
            ],
          ),
        );
      }
      
      if (controller.jobs.isEmpty) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.work_off_rounded, 
                    size: 60, 
                    color: primaryColor.withOpacity(0.7)
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'No nearby jobs found',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.grey[800],
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Try adjusting your location or search criteria to find more opportunities',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14, 
                      color: Colors.grey[600], 
                      height: 1.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 160,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.getJobs();
                    },
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                    label: const Text(
                      'Refresh', 
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 15, 
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      )
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: controller.jobs.length,
        itemBuilder: (context, index) {
          final job = controller.jobs[index];
          return _buildJobCard(job);
        },
      );
    });
  }

  Widget _buildJobCard(JobsModel job) {
    // Create an AsyncSnapshot for this job to use with JobDetails
    final jobData = _createJobDataFromNearbyJob(job);
    final snapshot = _createJobSnapshotFromData(jobData);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.to(() => JobDetails(snapshot: snapshot, index: 0));
            },
            splashColor: primaryColor.withOpacity(0.1),
            highlightColor: primaryColor.withOpacity(0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor.withOpacity(0.1), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompanyLogo(job.logo),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.jobTitle.isNotEmpty ? job.jobTitle : "Untitled Job",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.business_center_rounded, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    job.companyName,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8, top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Job details section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      // Info rows
                      Row(
                        children: [
                          Expanded(
                            child: _buildJobInfoItem(
                              icon: Icons.work_outline_rounded,
                              text: job.jobType.isNotEmpty ? job.jobType : "Full-time",
                              label: 'Job Type',
                            ),
                          ),
                          Expanded(
                            child: _buildJobInfoItem(
                              icon: Icons.payments_outlined,
                              text: job.salary.isNotEmpty ? "₹${job.salary}" : "Not specified",
                              label: 'Salary',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildJobInfoItem(
                              icon: Icons.timeline,
                              text: job.experience.isNotEmpty ? "${job.experience}+ years" : "Not specified",
                              label: 'Experience',
                            ),
                          ),
                          Expanded(
                            child: _buildJobInfoItem(
                              icon: Icons.location_on_outlined,
                              text: job.location.isNotEmpty ? job.location : "Not specified",
                              label: 'Location',
                            ),
                          ),
                        ],
                      ),
                    
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      const SizedBox(height: 16),
                      
                      // Bottom actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Post date tag
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined, 
                                size: 14, 
                                color: Colors.grey[600]
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Posted: ${job.postDate.isNotEmpty ? job.postDate : "Recently"}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
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
          ),
        ),
      ),
    );
  }
  
  Widget _buildJobInfoItem({
    required IconData icon,
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
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16, color: primaryColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildTag(String text, {required Color backgroundColor, required Color textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
  
  Widget _buildCompanyLogo(String logoUrl) {
    if (logoUrl.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.business_rounded, color: Colors.grey[400], size: 30),
      );
    }
    
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          logoUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.business_rounded, color: Colors.grey[400], size: 30);
          },
        ),
      ),
    );
  }
  
  // Helper method to convert JobsModel to Data
  Data _createJobDataFromNearbyJob(JobsModel job) {
    return Data(
      id: job.jobId,
      jobTitle: job.jobTitle,
      experience: job.experience,
      aboutJob: job.aboutJob,
      location: job.location,
      salary: job.salary,
      skills: job.skill,
      openings: job.openings,
      probationSalary: job.probSalary,
      probationDuration: job.probDuration,
      lastDate: job.lastDate,
      isApplied: job.isApplied,
      isSaved: job.isSaved,
      postDate: job.postDate,
      jobType: job.jobType,
      admin: Admin(
        username: job.companyName,
        description: job.cDescription,
        website: job.website,
        logo: job.logo,
        latitude: job.lat,
        longitude: job.long,
      )
    );
  }
  
  // Helper method to create AsyncSnapshot from Data
  AsyncSnapshot<JobModel> _createJobSnapshotFromData(Data jobData) {
    // Create a mock JobModel with this single job
    final jobModel = JobModel(
      error: false,
      message: "Success",
      data: [jobData]
    );
    
    // Create an AsyncSnapshot to pass to JobDetails
    return AsyncSnapshot<JobModel>.withData(
      ConnectionState.done,
      jobModel
    );
  }
} 


