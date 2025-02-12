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
                        padding: EdgeInsets.all(8),
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
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey[200], thickness: 1),
                  const SizedBox(height: 16),
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
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
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
          SizedBox(height: 16),
          Text(
            'Add your education',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add Education & boost your profile by 10%',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
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
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[100],
        height: 24,
      ),
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item[index].degree!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => Get.to(() => EditEducation(
                            collegeName: item[index].name!,
                            stream: item[index].stream!,
                            degree: item[index].degree!,
                            start: item[index].startDate!,
                            end: item[index].endDate!,
                            percent: item[index].percentage!,
                            eduId: item[index].id!.toInt(),
                          )),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: primaryColor,
                          size: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: () => deleteDialog(item[index].id!.toInt()),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.school,
                  size: 16,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 8),
                Text(
                  item[index].stream!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.business,
                  size: 16,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 8),
                Text(
                  item[index].name!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 8),
                Text(
                  '${item[index].startDate} - ${item[index].endDate}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  deleteDialog(int eduId) {
    return Get.defaultDialog(
      title: 'Delete Education',
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      middleText: 'Are you sure you want to delete this education detail?',
      middleTextStyle: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
      radius: 16,
      confirm: ElevatedButton(
        onPressed: () => ProfileUtils.deleteEducation(eduId: eduId),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text('Delete'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'Cancel',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }
}
