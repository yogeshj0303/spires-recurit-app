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
          padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profilePic(),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildUserInfo(),
                        ),
                      ],
                    ),
                  ),
                  _buildPremiumBadge(),
                ],
              ),
              const SizedBox(height: 16),
              _buildStatisticsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumBadge() {
    return Obx(() {
      if (!(c.isSubscribed.value || MyController.subscribed == '1')) {
        return const SizedBox();
      }
      
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
    });
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                '${MyController.userFirstName} ${MyController.userLastName}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Obx(() => c.isSubscribed.value || MyController.subscribed == '1' 
              ? Row(
                  children: [
                    SizedBox(width: 8),
                    Icon(
                      Icons.verified,
                      color: Colors.amber[300],
                      size: 20,
                    ),
                  ],
                )
              : SizedBox()),
          ],
        ),
        SizedBox(height: 16),
        _buildInfoRow(
          Icons.email_outlined,
          MyController.userEmail,
        ),
        SizedBox(height: 12),
        _buildInfoRow(
          Icons.phone_outlined,
          MyController.userPhone,
        ),
      ],
    );
  }

  Widget _buildStatisticsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildStatItem(
            icon: Icons.work_outline,
            label: 'Jobs Applied',
            value: c.appliedJobs.length.toString(),
          ),
        ),
        _buildDivider(),
        Expanded(
          child: _buildStatItem(
            icon: Icons.work_history_outlined,
            label: 'Jobs Completed',
            value: c.completedJobs.length.toString(),
          ),
        ),
        _buildDivider(),
        Expanded(
          child: _buildStatItem(
            icon: Icons.pending_outlined,
            label: 'In Progress',
            value: c.inProgressJobs.length.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 35,
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withOpacity(0.15),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white.withOpacity(0.95),
            size: 16,
          ),
        ),
        SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
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
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.red[400],
              size: 56,
            ),
            SizedBox(height: 16),
            Text(
              'This action cannot be undone. Are you sure you want to delete your profile?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
      radius: 16,
      confirm: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: () {
            Get.back();
            deletefn();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400],
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'Delete Profile',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      cancel: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
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
    return Obx(() {
      if (c.isDpLoading.value) {
        return loadingProfileDP();
      }
      
      return Container(
        width: 90,
        height: 90,
        margin: EdgeInsets.only(right: 6,top: 10,bottom: 0),
        child: c.profileImg.value == ''
          ? _buildDefaultProfilePic()
          : _buildNetworkProfilePic()
      );
    });
  }

  Widget _buildDefaultProfilePic() {
    return Stack(
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
        _buildCameraButton(),
      ],
    );
  }

  Widget _buildNetworkProfilePic() {
    return Stack(
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
        _buildCameraButton(),
      ],
    );
  }

  Widget _buildCameraButton() {
    return Positioned(
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
    );
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
      radius: 16,
      title: 'Choose Image Source',
      titleStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      content: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _buildImagePickerOption(
              icon: Icons.camera_alt_rounded,
              title: 'Take a Photo',
              onTap: () => pickImageFrom(ImageSource.camera),
            ),
            SizedBox(height: 8),
            _buildImagePickerOption(
              icon: Icons.photo_library_rounded,
              title: 'Choose from Gallery',
              onTap: () => pickImageFrom(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}