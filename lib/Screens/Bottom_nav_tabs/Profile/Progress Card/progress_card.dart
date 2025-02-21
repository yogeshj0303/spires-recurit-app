import '../../../../Constants/exports.dart';

class ProgressCard extends StatelessWidget {
  ProgressCard({super.key});
  final c = Get.put(MyController());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    MyController.veriEmail == '1'
        ? c.emailPoints.value = 15.00
        : c.emailPoints.value = 0.00;
    MyController.veriPhone == '1'
        ? c.phonePoints.value = 15.00
        : c.phonePoints.value = 0.00;
    return Container(
      width: size.width,
      color: primaryColor.withOpacity(0.2),
      height: size.height * 0.2,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          buildProgress(size),
          buildPhoneCard(size),
          buildEmailCard(size),
          const SizedBox(width: 8)
        ],
      ),
    );
  }

  Container buildProgress(Size size) {
    c.getProgressValue();
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 0, 8),
      width: size.width * 0.3,
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Obx(
                () => SleekCircularSlider(
                  initialValue: c.progressValue.value,
                  appearance: CircularSliderAppearance(
                    size: 80,
                    spinnerDuration: 3000,
                    customColors: c.progressValue.value == 100.0
                        ? CustomSliderColors(
                            progressBarColor: Colors.green.shade600,
                            trackColor: Colors.black12,
                          )
                        : CustomSliderColors(
                            progressBarColor: primaryColor,
                            trackColor: Colors.black12,
                          ),
                  ),
                  innerWidget: (percentage) {
                    return Center(
                      child: Obx(
                        () => Text(
                          '${c.progressValue.value}%',
                          style: c.progressValue.value == 100.00
                              ? smallGreenText
                              : smallColorText,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            c.progressValue.value == 100.00
                ? Text(
                    'Congratulations!!! Your Profile is complete.',
                    style: smallGreenText,
                    textAlign: TextAlign.center,
                  )
                : Text(
                    'We suggest you to have a complete profile. ',
                    style: xsmallText,
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }

  Container buildPhoneCard(Size size) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: borderRadius,
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.fromLTRB(8, 8, 0, 8),
      width: size.width * 0.3,
      child: Obx(
            () => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '+ 15%',
                style: xsmallGreenText,
              ),
            ),
            c.isPhoneVerified.value || MyController.veriPhone == '1'
                ? CircleAvatar(
              backgroundColor: Colors.green.withOpacity(0.8),
              child: const Icon(Icons.verified, color: whiteColor, size: 20),
            )
                : CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.1),
              child: const Icon(Icons.phone_android, color: primaryColor, size: 20),
            ),
            const Spacer(),
            Text(
              'Recruiters contact verified numbers',
              style: xsmallText,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            c.isPhoneVerified.value || MyController.veriPhone == '1'
                ? Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: borderRadius,
              ),
              child: Text(
                'Verified',
                textAlign: TextAlign.center,
                style: smallWhiteText,
              ),
            )
                : GestureDetector(
                    onTap: () {
                      _showPhoneNumberDialog(Get.context!);
                    },
                    child: Obx(
                      () => c.isotpLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Container(
                              height: 20,
                              width: size.width * 0.2,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.2),
                                borderRadius: borderRadius,
                              ),
                              child: Text(
                                'Verify',
                                textAlign: TextAlign.center,
                                style: smallColorText,
                              ),
                            ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }


  void _showPhoneNumberDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Verify Phone Number',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter your phone number to receive verification code',
                style: xsmallText,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  prefixIcon: Icon(Icons.phone_android, color: primaryColor),
                  filled: true,
                  fillColor: primaryColor.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    minimumSize: Size(100, 40),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final phoneNumber = phoneController.text.trim();
                    if (phoneNumber.isNotEmpty) {
                      MyController.userPhone = phoneNumber;
                      Navigator.of(context).pop();
                      await ProfileUtils.getOtp(MyController.userPhone);
                    } else {
                      Fluttertoast.showToast(msg: 'Please enter a phone number');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: Size(100, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Send OTP',
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        );
      },
    );
  }

  Container buildEmailCard(Size size) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: borderRadius,
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.fromLTRB(8, 8, 0, 8),
      width: size.width * 0.3,
      child: Obx(
        () => Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text('+ 15%', style: xsmallGreenText),
            ),
            c.isEmailVerified.value || MyController.veriEmail == '1'
                ? CircleAvatar(
                    backgroundColor: Colors.green.withOpacity(0.8),
                    child: const Icon(Icons.verified_rounded,
                        color: whiteColor, size: 20),
                  )
                : CircleAvatar(
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: const Icon(Icons.email_outlined,
                        color: primaryColor, size: 20),
                  ),
            const Spacer(),
            Text(
              'Recruiters contact verified email',
              style: xsmallText,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            c.isEmailVerified.value || MyController.veriEmail == '1'
                ? Container(
                    height: 20,
                    width: size.width * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: borderRadius,
                    ),
                    child: Text(
                      'Verified',
                      textAlign: TextAlign.center,
                      style: smallWhiteText,
                    ),
                  )
                : InkWell(
                    onTap: () => ProfileUtils.getEmailVerification(),
                    child: Obx(
                      () => c.isemailLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Container(
                              height: 20,
                              width: size.width * 0.2,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.2),
                                borderRadius: borderRadius,
                              ),
                              child: Text(
                                'Verify',
                                textAlign: TextAlign.center,
                                style: smallColorText,
                              ),
                            ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
