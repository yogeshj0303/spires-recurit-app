import 'package:spires_app/Model/exp_model.dart';
import '../../../../Constants/exports.dart';

class WorkExp extends StatelessWidget {
  WorkExp({super.key});
  final c = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: const EdgeInsets.fromLTRB(defaultPadding, defaultPadding, defaultPadding, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 4),
          Divider(color: Colors.grey[200], thickness: 1),
          _buildExperienceList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            workExpIcon,
            color: primaryColor,
            height: 20,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Work Experience',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () => Get.to(() => AddExp()),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.add,
              color: primaryColor,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceList() {
    return Obx(
      () => c.isExpLoading.value
          ? loadShimmer
          : FutureBuilder<ExpModel>(
              future: ProfileUtils.showExperience(),
              builder: (context, snapshot) => snapshot.hasData
                  ? snapshot.data!.data!.isEmpty
                      ? emptyExp()
                      : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.data!.length,
                          separatorBuilder: (_, __) => Divider(
                            color: Colors.grey[100],
                            height: 10,
                          ),
                          itemBuilder: (context, index) =>
                              ExpCard(snapshot: snapshot, index: index),
                        )
                  : loadShimmer,
            ),
    );
  }

  Widget emptyExp() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.work_outline,
              size: 28,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add your work experience',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Text(
              'Add Experience & boost your profile by 10%',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpCard extends StatelessWidget {
  final AsyncSnapshot<ExpModel> snapshot;
  final int index;
  const ExpCard({super.key, required this.snapshot, required this.index});

  @override
  Widget build(BuildContext context) {
    final item = snapshot.data!.data![index];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(item),
          const SizedBox(height: 12),
          _buildDetails(item),
        ],
      ),
    );
  }

  Widget _buildHeader(Data item) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.designation!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ),
        _buildActionButtons(item),
      ],
    );
  }

  Widget _buildActionButtons(Data item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconButton(
          onTap: () => Get.to(() => EditExp(
                profile: item.designation!,
                organisation: item.organization!,
                location: item.location!,
                startDate: item.startDate!,
                endDate: item.endDate ?? '',
                workDesc: item.description!,
                expId: item.id!.toInt(),
              )),
          icon: Icons.edit_outlined,
          color: primaryColor,
        ),
        const SizedBox(width: 8),
        _buildIconButton(
          onTap: () => deleteDialog(item.id!.toInt()),
          icon: Icons.delete_outline,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  Widget _buildDetails(Data item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(Icons.business, item.organization!),
        const SizedBox(height: 6),
        _buildDetailRow(Icons.location_on_outlined, item.location!),
        const SizedBox(height: 6),
        _buildDetailRow(
          Icons.calendar_today_outlined,
          '${item.startDate} - ${item.endDate ?? 'Present'}',
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  deleteDialog(int expId) {
    return Get.defaultDialog(
      title: 'Delete Experience Details',
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      contentPadding: const EdgeInsets.all(24),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      content: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Are you sure you want to delete this experience detail? This action cannot be undone.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
      radius: 16,
      confirm: ElevatedButton(
        onPressed: () => ProfileUtils.deleteExperience(expId: expId),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Delete',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
