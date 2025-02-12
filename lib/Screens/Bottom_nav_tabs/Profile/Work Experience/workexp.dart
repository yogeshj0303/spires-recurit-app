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
                  workExpIcon,
                  color: primaryColor,
                  height: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
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
          Obx(
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
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.grey[100],
                                  height: 24,
                                ),
                                itemBuilder: (context, index) =>
                                    ExpCard(snapshot: snapshot, index: index),
                              )
                        : loadShimmer,
                  ),
          ),
        ],
      ),
    );
  }

  Widget emptyExp() {
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
              Icons.work_outline,
              size: 32,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Add your work experience',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add Experience & boost your profile by 10%',
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

class ExpCard extends StatelessWidget {
  final AsyncSnapshot<ExpModel> snapshot;
  final int index;
  const ExpCard({super.key, required this.snapshot, required this.index});

  @override
  Widget build(BuildContext context) {
    final item = snapshot.data!.data![index];
    return Container(
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
                  item.designation!,
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
                    onTap: () => Get.to(() => EditExp(
                          profile: item.designation!,
                          organisation: item.organization!,
                          location: item.location!,
                          startDate: item.startDate!,
                          endDate: item.endDate ?? '',
                          workDesc: item.description!,
                          expId: item.id!.toInt(),
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
                    onTap: () => deleteDialog(item.id!.toInt()),
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
                Icons.business,
                size: 16,
                color: Colors.grey[600],
              ),
              SizedBox(width: 8),
              Text(
                item.organization!,
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
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey[600],
              ),
              SizedBox(width: 8),
              Text(
                item.location!,
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
                '${item.startDate} - ${item.endDate ?? 'Present'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  deleteDialog(int expId) {
    return Get.defaultDialog(
      title: 'Delete Experience',
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      middleText: 'Are you sure you want to delete this experience?',
      middleTextStyle: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
      radius: 16,
      confirm: ElevatedButton(
        onPressed: () => ProfileUtils.deleteExperience(expId: expId),
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
