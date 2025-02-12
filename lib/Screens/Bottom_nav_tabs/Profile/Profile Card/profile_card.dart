import 'dart:io';
import '../../../../Constants/exports.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  File? image;
  final c = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.85),
          ],
          stops: [0.2, 0.9],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    profilePic(),
                    _buildPremiumBadge(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => _buildUserInfo()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumBadge() {
    if (!(c.isSubscribed.value || MyController.subscribed == '1')) return SizedBox();
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.workspace_premium,
            color: Colors.amber[300],
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Premium',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${MyController.userFirstName} ${MyController.userLastName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (c.isSubscribed.value || MyController.subscribed == '1') ...[
                    SizedBox(width: 8),
                    Icon(
                      Icons.verified,
                      color: Colors.amber[300],
                      size: 20,
                    ),
                  ],
                ],
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                Icons.email_outlined,
                MyController.userEmail,
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                Icons.phone_outlined,
                MyController.userPhone,
              ),
            ],
          ),
        ),
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white.withOpacity(0.9),
            size: 16,
          ),
        ),
        SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDeleteDialog(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.delete_outline,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    Get.defaultDialog(
      title: 'Delete Profile',
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      middleText: 'Are you sure you want to delete your profile?',
      middleTextStyle: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
      radius: 12,
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          deletefn();
        },
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

  pickImageFrom(ImageSource source) async {
    XFile? pickedImg = await ImagePicker().pickImage(source: source);
    if (pickedImg != null) {
      image = File(pickedImg.path);
      Get.back();
      ProfileUtils.updateDP(imagePath: image!.path);
    } else {
      Fluttertoast.showToast(msg: 'No Files selected');
    }
  }

  Widget profilePic() {
    return Obx(() => c.isDpLoading.value
        ? loadingProfileDP()
        : c.profileImg.value == ''
            ? Stack(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        profileImage,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () => showImagePickerDialog(),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: c.profileImg.value.isURL
                            ? c.profileImg.value
                            : '$imgPath/${c.profileImg.value}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () => showImagePickerDialog(),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  loadingProfileDP() {
    return Container(
      height: 120,
      width: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: FileImage(image!),
          opacity: 0.3,
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      ),
    );
  }

  showImagePickerDialog() {
    return Get.defaultDialog(
      radius: 4,
      title: 'Choose Source',
      titleStyle: mediumBoldText,
      content: Column(
        children: [
          ListTile(
            dense: true,
            onTap: () => pickImageFrom(ImageSource.camera),
            title: Text('Camera', style: normalText),
            leading: const Icon(
              Icons.add_a_photo,
              color: primaryColor,
            ),
          ),
          ListTile(
            dense: true,
            onTap: () => pickImageFrom(ImageSource.gallery),
            title: Text('Gallery', style: normalText),
            leading: const Icon(
              Icons.image,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}