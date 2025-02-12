import 'package:spires_app/Model/profile_model.dart';
import '../../../../Constants/exports.dart';

class AboutMeCard extends StatelessWidget {
  AboutMeCard({super.key});
  final c = Get.put(MyController());
  final aboutMeController = TextEditingController();
  final aboutMeEditController = TextEditingController();

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
      child: Obx(
        () => c.isAboutLoading.value
            ? profileLoading()
            : FutureBuilder<ProfileModel>(
                future: ProfileUtils.showProfile(),
                builder: (context, snapshot) => snapshot.hasData
                    ? snapshot.data!.message!.description == null ||
                            snapshot.data!.message!.description == ''
                        ? emptyAboutMe()
                        : Column(
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
                                      aboutMeIcon,
                                      color: primaryColor,
                                      height: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'About Me',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () => aboutMeEditDialog(
                                        snapshot.data!.message!.description!),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        size: 20,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                  ),
                                ),
                                child: Text(
                                  snapshot.data!.message!.description!,
                                  style: TextStyle(
                                    height: 1.5,
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          )
                    : profileLoading(),
              ),
      ),
    );
  }

  Widget emptyAboutMe() {
    c.aboutMePoints.value = 0.00;
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              size: 32,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tell us about yourself',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add about yourself and boost your profile by 10%',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => aboutMeAddDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Add About Me',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  aboutMeAddDialog() {
    return Get.defaultDialog(
      radius: 16,
      title: 'Tell us about yourself',
      titleStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      content: Obx(
        () => c.isAboutLoading.value
            ? loading
            : Column(
                children: [
                  TextFormField(
                    controller: aboutMeController,
                    minLines: 8,
                    maxLines: 12,
                    maxLength: 100,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      hintText: 'Write about yourself...',
                      hintStyle: TextStyle(color: Colors.black38),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () => aboutMeController.text.isNotEmpty
                          ? ProfileUtils.addAboutMe(
                              aboutMe: aboutMeController.text)
                          : Fluttertoast.showToast(
                              msg: 'Please write about yourself'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  aboutMeEditDialog(String data) {
    aboutMeEditController.text = data;
    return Get.defaultDialog(
      radius: 16,
      title: 'Edit About Me',
      titleStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      content: Obx(
        () => c.isAboutLoading.value
            ? loading
            : Column(
                children: [
                  TextFormField(
                    controller: aboutMeEditController,
                    minLines: 8,
                    maxLines: 12,
                    maxLength: 100,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      hintText: 'Write about yourself...',
                      hintStyle: TextStyle(color: Colors.black38),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () => aboutMeEditController.text.isNotEmpty
                          ? ProfileUtils.editAboutMe(
                              aboutMe: aboutMeEditController.text)
                          : Fluttertoast.showToast(
                              msg: 'Please write about yourself'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
