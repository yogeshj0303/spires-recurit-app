import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../Constants/exports.dart';
import '../../../Model/job_model.dart';

class JobDetails extends StatelessWidget {
  final AsyncSnapshot<JobModel> snapshot;
  final int index;
  JobDetails({super.key, required this.snapshot, required this.index});
  final c = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final item = snapshot.data!.data![index];
    c.isJobSaved.value = item.isSaved!;
    c.isJobApplied.value = item.isApplied!;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20,),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          'Job Details',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              c.isJobSaved.value ? Icons.bookmark_added : Icons.bookmark_outline,
              color: primaryColor,
            ),
            onPressed: () {
              if (c.isJobSaved.value) {
                JobsUtils.unSaveJob(jobId: item.id!.toInt());
                c.isJobSaved.value = false;  // Update immediately
              } else {
                JobsUtils.saveJob(jobId: item.id!.toInt());
                c.isJobSaved.value = true;   // Update immediately
              }
            },
          )),
          IconButton(
            icon: Icon(Icons.share, color: Colors.black87),
            onPressed: () => shareJobs(item.id!.toInt()),
          ),
        ],
      ),
      body: Obx(
        () => c.isJobLoading.value
            ? loading
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildHeader(item),
                        _buildJobDetails(item),
                        SizedBox(height: 80), // Space for bottom button
                      ],
                    ),
                  ),
                  _buildBottomButton(item),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(Data item) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Actively Hiring',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            item.jobTitle!,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8),
          Text(
            item.admin!.username!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.work_outline,
            text: '${item.experience}+ years experience',
            secondIcon: Icons.location_on_outlined,
            secondText: item.location!,
          ),
          SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.business_center_outlined,
            text: item.jobType!,
            secondIcon: Icons.payments_outlined,
            secondText: '₹${int.parse(item.salary!) * 12} p.a.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required IconData secondIcon,
    required String secondText,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
            fontFamily: 'Poppins',
          ),
        ),
        Spacer(),
        Icon(secondIcon, size: 16, color: Colors.black54),
        SizedBox(width: 8),
        Text(
          secondText,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildJobDetails(Data item) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'About ${item.admin!.username!}',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HtmlWidget(item.admin!.description!),
                SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    await launchUrl(Uri.parse('https://${item.admin!.website}'));
                  },
                  child: Text(
                    'Visit Website →',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildSection(
            title: 'Job Description',
            child: HtmlWidget(item.aboutJob!),
          ),
          _buildSection(
            title: 'Required Skills',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.skills!.split(',').map((skill) => Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  skill.trim(),
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                  ),
                ),
              )).toList(),
            ),
          ),
          _buildSection(
            title: 'Salary Details',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Probation Period',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Get.defaultDialog(
                          title: 'Probation',
                          middleText: 'Probation is a period of trial where the employer gives you time to learn the skills required for the job, which helps you and the employer check whether you are suitable for the role.',
                        );
                      },
                      child: Icon(Icons.info_outline, size: 18, color: primaryColor),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Duration: ${item.probationDuration!} Months',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'Salary during probation: ₹${item.probationSalary!}/month',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Post Probation Salary',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Annual CTC: ₹${int.parse(item.salary!) * 12} p.a.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          _buildSection(
            title: 'Additional Information',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Number of Openings: ${item.openings}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, 
                         size: 16, 
                         color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      'Posted on ${item.postDate}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.timer_outlined, 
                         size: 16, 
                         color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      'Last date to apply: ${item.lastDate}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
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

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 12),
        child,
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBottomButton(Data item) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: c.isJobApplied.value
            ? Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Application Submitted',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : ElevatedButton(
                onPressed: () {
                  if (isValidToApply()) {
                    JobsUtils.applyForJob(jobId: item.id!.toInt());
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Apply Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
