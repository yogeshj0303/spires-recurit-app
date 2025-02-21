import 'package:intl/intl.dart';
import '../../../../Constants/exports.dart';

class EditExp extends StatelessWidget {
  final String profile;
  final String organisation;
  final String location;
  final String startDate;
  final String endDate;
  final String workDesc;
  final int expId;
  EditExp(
      {super.key,
      required this.profile,
      required this.organisation,
      required this.location,
      required this.startDate,
      required this.endDate,
      required this.workDesc,
      required this.expId});
  final profileController = TextEditingController();
  final organisationController = TextEditingController();
  final locationController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final workDescController = TextEditingController();
  final c = Get.put(MyController());
  final RxBool isWfh = false.obs;
  final RxBool isWorking = false.obs;
  final RxInt wordCount = 0.obs;
  final expKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    profileController.text = profile;
    organisationController.text = organisation;
    locationController.text = location;
    startDateController.text = startDate;
    endDateController.text = endDate;
    workDescController.text = workDesc;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Experience', 
          style: TextStyle(fontWeight: FontWeight.w600)
        ),
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
                          _buildTextField(
                            controller: profileController,
                            hintText: 'Job Title / Designation',
                            icon: Icons.work_outline,
                            context: context,
                          ),
                          const SizedBox(height: defaultPadding),
                          _buildTextField(
                            controller: organisationController,
                            hintText: 'Company / Organisation',
                            icon: Icons.business_outlined,
                            context: context,
                          ),

                          const SizedBox(height: defaultPadding * 2),
                          _buildSectionHeader('Location Details', Icons.location_on_outlined, context),
                          const SizedBox(height: defaultPadding),
                          _buildTextField(
                            controller: locationController,
                            hintText: 'Location',
                            icon: Icons.location_on_outlined,
                            context: context,
                          ),
                          _buildCheckboxCard(
                            value: isWfh,
                            title: 'Work From Home',
                            context: context,
                          ),

                          const SizedBox(height: defaultPadding * 2),
                          _buildSectionHeader('Duration', Icons.date_range_outlined, context),
                          const SizedBox(height: defaultPadding),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDateField(
                                  controller: startDateController,
                                  hintText: 'Start Date',
                                  context: context,
                                ),
                              ),
                              const SizedBox(width: defaultPadding),
                              Obx(
                                () => Visibility(
                                  visible: !isWorking.value,
                                  child: Expanded(
                                    child: _buildDateField(
                                      controller: endDateController,
                                      hintText: 'End Date',
                                      context: context,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _buildCheckboxCard(
                            value: isWorking,
                            title: 'I currently work here',
                            context: context,
                          ),

                          const SizedBox(height: defaultPadding * 2),
                          _buildSectionHeader('Work Description', Icons.description_outlined, context),
                          const SizedBox(height: defaultPadding),
                          TextFormField(
                            controller: workDescController,
                            maxLines: 5,
                            maxLength: 250,
                            onChanged: (val) => wordCount.value = val.length,
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
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                          const SizedBox(height: defaultPadding * 2),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                final isValid = expKey.currentState!.validate();
                                if (isValid) {
                                  ProfileUtils.editExperience(
                                    designation: profileController.text,
                                    organisation: organisationController.text,
                                    location: locationController.text,
                                    start: startDateController.text,
                                    end: endDateController.text,
                                    desc: workDescController.text,
                                    isWFH: isWfh.value,
                                    expId: expId,
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
                                'Save Changes',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required BuildContext context,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor.withOpacity(0.7)),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (val) => val!.isEmpty ? 'This field is required' : null,
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String hintText,
    required BuildContext context,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          controller.text = DateFormat('dd MMM yyyy').format(date);
        }
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(
          Icons.calendar_today_outlined,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildCheckboxCard({
    required RxBool value,
    required String title,
    required BuildContext context,
  }) {
    return Card(
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
          value: value.value,
          onChanged: (newvalue) {
            value.value = newvalue!;
          },
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }
}
