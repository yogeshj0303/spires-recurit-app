import 'package:spires_app/Screens/Bottom_nav_tabs/Filters/Internship/internship_filter.dart';
import '../../../Constants/exports.dart';
import 'package:spires_app/Model/internship_model.dart';

class Internship extends StatefulWidget {
  final bool? allInternship;
  final bool? isDrawer;
  const Internship({super.key, this.allInternship, this.isDrawer});

  @override
  State<Internship> createState() => _InternshipState();
}

class _InternshipState extends State<Internship> {
  final c = Get.put(MyController());
  final TextEditingController searchController = TextEditingController();
  List<Data> filteredInternships = [];
  List<Data> allInternships = [];

  // Add this method to filter internships
  void filterInternships(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredInternships = allInternships;
      } else {
        filteredInternships = allInternships.where((internship) {
          final title = internship.internshipTitle?.toLowerCase() ?? '';
          final searchTerm = query.toLowerCase();
          return title.contains(searchTerm);
        }).toList();
      }
    });
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
        title: const Text('Internship', style: TextStyle(
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
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () => Get.to(() => InternshipFilter()),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: filterInternships,
              decoration: InputDecoration(
                hintText: 'Search internships...',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
                prefixIcon: const Icon(Icons.search, color: primaryColor, size: 22),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: primaryColor, width: 1.5),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Obx(
                () => c.isInternshipLoading.value
                    ? cardShimmer(size)
                    : FutureBuilder<InternshipModel>(
                        future: widget.allInternship ?? false
                            ? InternshipUtils.allInternship()
                            : InternshipUtils.showInternship(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // Store all internships when data is loaded
                            if (allInternships.isEmpty) {
                              allInternships = snapshot.data!.data ?? [];
                              filteredInternships = allInternships;
                            }
                            
                            return filteredInternships.isEmpty
                                ? Center(
                                    child: Text(
                                      'No Internships Available',
                                      style: normalLightText,
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredInternships.length,
                                    itemBuilder: (context, index) =>
                                        internshipCard(
                                          AsyncSnapshot.withData(
                                            ConnectionState.done,
                                            InternshipModel(
                                              data: filteredInternships,
                                            ),
                                          ),
                                          index,
                                          size,
                                        ),
                                  );
                          }
                          return loading;
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget internshipCard(
    AsyncSnapshot<InternshipModel> snapshot,
    int index,
    Size size,
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
                      item.internshipTitle!,
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
        
        // Internship details section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              // Info rows
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Image.asset(homeFilled, height: 18, color: primaryColor),
                      text: item.internshipType!,
                      label: 'Type',
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icon(Icons.calendar_month, size: 18, color: primaryColor),
                      text: '${item.duration} Months',
                      label: 'Duration',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icon(Icons.payments_outlined, size: 18, color: primaryColor),
                      text: '₹${item.stipend}/month',
                      label: 'Stipend',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.play_circle_outline, 
                      size: 20, 
                      color: Colors.green.shade700
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Starts Immediately',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              
              // Bottom actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Internship Tag - with constrained width
                  Container(
                    constraints: BoxConstraints(maxWidth: size.width * 0.4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryColor.withOpacity(0.2)),
                    ),
                    child: Text(
                      'Internship with job offer',
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
                          onTap: () => shareInternships(item.id!.toInt()),
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
                        onTap: () => Get.to(() => InternshipDetails(snapshot: snapshot, index: index)),
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

