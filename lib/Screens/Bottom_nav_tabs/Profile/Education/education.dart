import 'package:spires_app/Model/edu_model.dart';
import '../../../../Constants/exports.dart';

class Education extends StatelessWidget {
  Education({super.key});
  final c = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(
      () => c.isEduLoading.value
          ? loadShimmer
          : Container(
              width: size.width,
              margin: const EdgeInsets.fromLTRB(
                  defaultPadding, defaultPadding, defaultPadding, 0),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset(
                          degreeIcon,
                          color: primaryColor,
                          height: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Education',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => Get.to(() => AddEducation()),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Divider(color: Colors.grey[200], thickness: 1),
                  FutureBuilder<EduModel>(
                    future: ProfileUtils.showEducation(),
                    builder: (context, snapshot) => snapshot.hasData
                        ? snapshot.data!.data!.isEmpty
                            ? emptyEdu()
                            : EduCard(snapshot: snapshot)
                        : loadShimmer,
                  ),
                ],
              ),
            ),
    );
  }

  Widget emptyEdu() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.school_outlined,
              size: 32,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Add your education',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Add Education & boost your profile by 10%',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class EduCard extends StatelessWidget {
  final AsyncSnapshot<EduModel> snapshot;
  EduCard({super.key, required this.snapshot});
  final c = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    final item = snapshot.data!.data!;
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: snapshot.data!.data!.length,
      separatorBuilder: (_, __) => Divider(
        color: Colors.grey[100],
        height: 10,
      ),
      itemBuilder: (context, index) => Container(
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
            _buildHeader(item[index]),
            const SizedBox(height: 12),
            _buildDetails(item[index]),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Data item) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.degree!,
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
          onTap: () => Get.to(() => EditEducation(
                collegeName: item.name!,
                stream: item.stream!,
                degree: item.degree!,
                start: item.startDate!,
                end: item.endDate!,
                percent: item.percentage!,
                eduId: item.id!.toInt(),
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
        _buildDetailRow(Icons.business, item.name!),
        const SizedBox(height: 6),
        _buildDetailRow(Icons.school, item.stream!),
        const SizedBox(height: 6),
        _buildDetailRow(
          Icons.calendar_today_outlined,
          '${item.startDate} - ${item.endDate}',
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

  deleteDialog(int eduId) {
    return Get.defaultDialog(
      title: 'Delete Education Details',
      titleStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      contentPadding: EdgeInsets.all(24),
      titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
      content: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
              size: 32,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Are you sure you want to delete this education detail? This action cannot be undone.',
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
        onPressed: () => ProfileUtils.deleteEducation(eduId: eduId),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(
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
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
