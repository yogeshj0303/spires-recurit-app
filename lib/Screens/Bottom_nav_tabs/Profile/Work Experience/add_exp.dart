import 'package:intl/intl.dart';

import '../../../../Constants/exports.dart';

class AddExp extends StatelessWidget {
  AddExp({super.key});
  final profileController = TextEditingController();
  final organisationController = TextEditingController();
  final locationController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final workDescController = TextEditingController();
  final expKey = GlobalKey<FormState>();
  final c = Get.put(MyController());
  final RxBool isWfh = false.obs;
  final RxBool isWorking = false.obs;
  @override
  Widget build(BuildContext context) {
    c.startDate.value = DateTime(1999);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Experience', style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Obx(
        () => c.isExpLoading.value
            ? loading
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Form(
                      key: expKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader('Basic Information', Icons.person_outline, context),
                          const SizedBox(height: defaultPadding),
                          TextFormField(
                            controller: profileController,
                            decoration: InputDecoration(
                              hintText: 'Job Title / Designation',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(Icons.work_outline, 
                                color: Theme.of(context).primaryColor.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[200]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[200]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: (val) => val!.isEmpty ? 'This field is required' : null,
                          ),
                          const SizedBox(height: defaultPadding),
                          TextFormField(
                            controller: organisationController,
                            decoration: InputDecoration(
                              hintText: 'Company / Organisation',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(Icons.business_outlined, 
                                color: Theme.of(context).primaryColor.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[200]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[200]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: defaultPadding * 2),
                          _buildSectionHeader('Location Details', Icons.location_on_outlined, context),
                          const SizedBox(height: defaultPadding),
                          
                          TextFormField(
                            controller: locationController,
                            decoration: InputDecoration(
                              hintText: 'Location',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(Icons.location_on_outlined, 
                                color: Theme.of(context).primaryColor.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[200]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[200]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey[200]!),
                            ),
                            color: Colors.grey[50],
                            child: Obx(
                              () => CheckboxListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: isWfh.value,
                                onChanged: (newvalue) {
                                  isWfh.value = newvalue!;
                                },
                                title: Text(
                                  'Work From Home',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: defaultPadding * 2),
                          _buildSectionHeader('Duration', Icons.date_range_outlined, context),
                          const SizedBox(height: defaultPadding),
                          
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: startDateController,
                                  readOnly: true,
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime.now(),
                                    );
                                    if (date != null) {
                                      startDateController.text = DateFormat('dd MMM yyyy').format(date);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Start Date',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    prefixIcon: Icon(Icons.calendar_today_outlined, 
                                      color: Theme.of(context).primaryColor.withOpacity(0.7),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[200]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[200]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: defaultPadding),
                              Obx(
                                () => Visibility(
                                  visible: !isWorking.value,
                                  child: Expanded(
                                    child: TextFormField(
                                      controller: endDateController,
                                      decoration: InputDecoration(
                                        hintText: 'End Date',
                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                        prefixIcon: Icon(Icons.calendar_today_outlined, 
                                          color: Theme.of(context).primaryColor.withOpacity(0.7),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[200]!),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[200]!),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).primaryColor,
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey[200]!),
                            ),
                            color: Colors.grey[50],
                            child: Obx(
                              () => CheckboxListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: isWorking.value,
                                onChanged: (newvalue) {
                                  isWorking.value = newvalue!;
                                },
                                title: Text(
                                  'I currently work here',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: defaultPadding * 2),
                          _buildSectionHeader('Work Description', Icons.description_outlined, context),
                          const SizedBox(height: defaultPadding),
                          
                          TextFormField(
                            controller: workDescController,
                            maxLines: 5,
                            maxLength: 250,
                            validator: (val) =>
                                val!.isEmpty ? 'Please describe your work experience' : null,
                            decoration: InputDecoration(
                              hintText: 'Describe your responsibilities and achievements...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[200]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[200]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: defaultPadding),
                          proTips(size, context),
                          const SizedBox(height: defaultPadding * 2),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                final isValid = expKey.currentState!.validate();
                                if (isValid) {
                                  ProfileUtils.addExperience(
                                    designation: profileController.text,
                                    organisation: organisationController.text,
                                    location: locationController.text,
                                    start: startDateController.text,
                                    end: isWorking.value ? '' : endDateController.text,
                                    desc: workDescController.text,
                                    isWFH: isWfh.value,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Save Experience',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).primaryColor.withOpacity(0.8),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget proTips(Size size, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Pro Tips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          ProTipItem(
            text: 'Use bullet points to highlight 3-4 key responsibilities',
            size: size,
          ),
          const SizedBox(height: 8),
          ProTipItem(
            text: 'Start with strong action verbs: Led, Built, Developed, Implemented',
            size: size,
          ),
        ],
      ),
    );
  }
}

class ProTipItem extends StatelessWidget {
  final String text;
  final Size size;

  const ProTipItem({
    required this.text,
    required this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, size: 18),
        const SizedBox(width: 12),
        SizedBox(
          width: size.width - 100,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
