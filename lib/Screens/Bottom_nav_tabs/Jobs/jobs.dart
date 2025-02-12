import 'package:spires_app/Model/job_model.dart';
import '../../../Constants/exports.dart';

class Jobs extends StatefulWidget {
  final bool? showAll;
  final bool? isDrawer;
  const Jobs({super.key, this.showAll, this.isDrawer});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  final c = Get.put(MyController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: const Text('Jobs', style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          color: Colors.black,
        ),),
        leading: widget.isDrawer == true ? IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20,),
        ) : null,
        automaticallyImplyLeading: widget.isDrawer ?? true,
        actions: [
          IconButton(
              onPressed: () => Get.to(() => JobFilter()),
              icon: const Icon(Icons.filter_alt_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
              child: TextField(
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
                  filled: true,
                  fillColor: Colors.grey.shade50,
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
                onChanged: (value) => searchQuery.value = value,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => c.isJobLoading.value
                    ? cardShimmer(size)
                    : FutureBuilder<JobModel>(
                        future: widget.showAll ?? false
                            ? JobsUtils.allJobs()
                            : JobsUtils.showJobs(),
                        builder: (context, snapshot) => snapshot.hasData
                            ? snapshot.data!.data!.isEmpty
                                ? Center(
                                    child: Text(
                                      'No Jobs Available',
                                      style: normalLightText,
                                    ),
                                  )
                                : Obx(() => ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.data!
                                          .where((job) => job.jobTitle!
                                              .toLowerCase()
                                              .contains(
                                                  searchQuery.value.toLowerCase()))
                                          .length,
                                      itemBuilder: (context, index) {
                                        final filteredJobs = snapshot.data!.data!
                                            .where((job) => job.jobTitle!
                                                .toLowerCase()
                                                .contains(searchQuery.value
                                                    .toLowerCase()))
                                            .toList();
                                        return jobCard(
                                            AsyncSnapshot.withData(
                                                ConnectionState.done,
                                                JobModel(
                                                    data: filteredJobs,
                                                    message: snapshot.data!.message)),
                                            index,
                                            size,
                                            false);
                                      },
                                    ))
                            : loading,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget jobCard(
    AsyncSnapshot<JobModel> snapshot,
    int index,
    Size size,
    bool isNearby
) {
  final item = snapshot.data!.data![index];
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 8),
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(12),
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            gradient: LinearGradient(
              colors: [primaryColor.withOpacity(0.1), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.jobTitle!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.admin!.username!,
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
              activelyHiring(),
            ],
          ),
        ),
        
        // Job details section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Job Type Tag - with constrained width
                  Container(
                    constraints: BoxConstraints(maxWidth: size.width * 0.4),
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
                    ),
                  ),
                  
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
                        onTap: () => Get.to(() => JobDetails(snapshot: snapshot, index: index)),
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
