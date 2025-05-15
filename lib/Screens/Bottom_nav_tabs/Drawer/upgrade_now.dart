import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Model/show_plan_model.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class UpgradeNow extends StatefulWidget {
  const UpgradeNow({super.key});

  @override
  State<UpgradeNow> createState() => _UpgradeNowState();
}

class _UpgradeNowState extends State<UpgradeNow> {
  int planId = 0;
  String environment = "SANDBOX";
  String appId = "com.atc.spires_app";
  String merchantId = "PGTESTPAYUAT";
  String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  String saltIndex = "1";
  String apiEndPoint = "/pg/orders";
  bool isPhonePeInitialized = false;

  @override
  void initState() {
    super.initState();
    initializePhonePe();
  }

  void initializePhonePe() async {
    try {
      await PhonePePaymentSdk.init(
        environment,
        appId,
        merchantId,
        true,
      );
      setState(() {
        isPhonePeInitialized = true;
      });
      print("PhonePe SDK initialized successfully");
    } catch (e) {
      print("PhonePe initialization error: ${e.toString()}");
      Fluttertoast.showToast(msg: "Failed to initialize PhonePe: ${e.toString()}");
    }
  }

  String generateSHA256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void startPhonePePayment(double amount, String planName) async {
    if (!isPhonePeInitialized) {
      Fluttertoast.showToast(msg: "PhonePe is not initialized. Please try again.");
      return;
    }

    try {
      String baseUrl = "https://api.phonepe.com/apis/hermes";
      String callbackUrl = "https://webhook.site/your-callback-url";
      String redirectUrl = "https://webhook.site/your-redirect-url";
      
      String merchantTransactionId = "MT${DateTime.now().millisecondsSinceEpoch}_${planId}_${(amount * 100).toInt()}";
      
      Map<String, dynamic> paymentData = {
        "merchantId": merchantId,
        "merchantTransactionId": merchantTransactionId,
        "merchantUserId": "MUID${DateTime.now().millisecondsSinceEpoch}",
        "amount": (amount * 100).toInt(),
        "redirectUrl": redirectUrl,
        "redirectMode": "POST",
        "callbackUrl": callbackUrl,
        "mobileNumber": MyController.userPhone,
        "paymentInstrument": {
          "type": "UPI_INTENT",
          "targetApp": "PHONEPE"
        }
      };

      String jsonString = json.encode(paymentData);
      String base64String = base64.encode(utf8.encode(jsonString));
      String sha256String = generateSHA256(base64String + apiEndPoint + saltKey);
      String finalXHeader = sha256String + "###" + saltIndex;

      Map<String, dynamic> requestBody = {
        "request": base64String
      };

      String finalRequestBody = json.encode(requestBody);

      print("Starting PhonePe transaction with data: $finalRequestBody");

      try {
        var response = await PhonePePaymentSdk.startTransaction(
          finalRequestBody,
          callbackUrl,
        );

        print("PhonePe transaction response: $response");

        if (response != null) {
          String status = response['status'].toString();
          String error = response['error'].toString();
          if (status == 'SUCCESS') {
            HomeUtils.purchasePlan(planId);
            Fluttertoast.showToast(msg: "Payment Successful");
          } else {
            Fluttertoast.showToast(msg: error);
          }
        }
      } catch (e) {
        print("PhonePe transaction error: ${e.toString()}");
        Fluttertoast.showToast(msg: "Payment failed: ${e.toString()}");
      }
    } catch (e) {
      print("PhonePe payment error: ${e.toString()}");
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade Now'),
      ),
      body: FutureBuilder<ShowPlanModel>(
        future: HomeUtils.showPlan(),
        builder: (context, snapshot) => snapshot.hasData
            ? Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder: (context, index) =>
                      planCard(snapshot, index, size),
                ),
              )
            : loading,
      ),
    );
  }

  MyContainer planCard(
      AsyncSnapshot<ShowPlanModel> snapshot, int index, Size size) {
    final item = snapshot.data!.data![index];
    return MyContainer(
      padding: const EdgeInsets.all(defaultPadding),
      margin: const EdgeInsets.only(bottom: defaultPadding),
      child: Column(
        children: [
          Text(item.planName!, style: normalColorText),
          Text(item.planTitle ?? 'Interview Guide', style: smallText),
          const SizedBox(height: 12),
          Text(
            '₹${item.price!}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w100,
            ),
          ),
          Text(item.planSubTitle ?? 'Key Benefits', style: smallText),
          const SizedBox(height: 16),
          ListView.builder(
            itemCount: snapshot.data!.data![index].list!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, ind) =>
                featuresRow(snapshot.data!.data![index].list![ind], size),
          ),
          const SizedBox(height: 12),
          myButton(
            onPressed: () {
              planId = item.id!.toInt();
              startPhonePePayment(double.parse(item.price!), item.planName!);
            },
            label: 'Buy Now',
            color: primaryColor,
            style: normalWhiteText,
          ),
          const Divider(),
          Align(
            alignment: Alignment.centerRight,
            child:
                Text('Validity : ${item.duration!} Months', style: smallText),
          ),
        ],
      ),
    );
  }

  Padding featuresRow(String feature, Size size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: size.width - 85,
            child: Text(feature, style: normalBoldText),
          )
        ],
      ),
    );
  }
}
