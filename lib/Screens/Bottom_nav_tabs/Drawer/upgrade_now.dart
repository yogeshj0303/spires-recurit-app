import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Model/show_plan_model.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spires_app/Services/phonepe_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeNow extends StatefulWidget {
  const UpgradeNow({super.key});

  @override
  State<UpgradeNow> createState() => _UpgradeNowState();
}

class _UpgradeNowState extends State<UpgradeNow> {
  int planId = 0;
  String environment = "SANDBOX";
  String clientId = "TEST-M2262FQ2G51D7_25050";
  String clientSecret = "ZDViYzI4MzgtODQ4Ny00M2YyLWFjYzItZmI2MTU5NTU1ZDIy";
  String baseUrl = "https://api-preprod.phonepe.com/apis/pg-sandbox";
  bool isPhonePeInitialized = false;
  String? authToken;

  @override
  void initState() {
    super.initState();
    // initializePhonePe();
    PhonepeService.getAuthToken();
  }

  Future<void> initializePhonePe() async {
    try {
      // Get package info
      final packageInfo = await PackageInfo.fromPlatform();
      print("App package name: ${packageInfo.packageName}");
      print("App version: ${packageInfo.version}");
      print("App build number: ${packageInfo.buildNumber}");

      await PhonePePaymentSdk.init(
        environment,
        clientId,
        clientId,
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

  Future<String?> getAuthToken() async {
    try {
      final response = await http.post(
        Uri.parse('https://api-preprod.phonepe.com/apis/pg-sandbox/v1/oauth/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'client_credentials',
          'client_version': '1.0',
        },
      );

      print("Auth token response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['access_token'];
      } else {
        print("Auth token error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Auth token error: ${e.toString()}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> createOrder(double amount, String planName) async {
    print('💳 [PhonePe] Starting order creation for amount: $amount, plan: $planName');
    
    if (authToken == null) {
      print('🔑 [PhonePe] No auth token found, requesting new token...');
      authToken = await PhonepeService.getAuthToken();
      if (authToken == null) {
        print('❌ [PhonePe] Failed to get auth token');
        throw Exception("Failed to get auth token");
      }
      print('✅ [PhonePe] Successfully obtained auth token');
    }

    try {
      final merchantOrderId = "M${DateTime.now().millisecondsSinceEpoch}";
      final merchantTransactionId = "TX${DateTime.now().millisecondsSinceEpoch}";
      
      print('💳 [PhonePe] Generated merchantOrderId: $merchantOrderId');
      print('💳 [PhonePe] Generated merchantTransactionId: $merchantTransactionId');
      
      final orderData = {
        "merchantOrderId": merchantOrderId,
        "merchantTransactionId": merchantTransactionId,
        "merchantUserId": "USER${planId}",
        "amount": (amount * 100).toInt(),
        "callbackUrl": "https://spiresrecurit.com/callback",
        "mobileNumber": "9893333654",
        "paymentInstrument": {
          "type": "UPI_INTENT",
          "targetApp": "com.phonepe.app",
          "appId": "com.atc.spires_app"
        }
      };

      print('💳 [PhonePe] Order request data: $orderData');

      final response = await http.post(
        Uri.parse('$baseUrl/checkout/v2/pay'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'O-Bearer $authToken',
          'Accept': 'application/json',
        },
        body: json.encode(orderData),
      );

      print('💳 [PhonePe] Order response status: ${response.statusCode}');
      print('💳 [PhonePe] Order response headers: ${response.headers}');
      print('💳 [PhonePe] Order response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['orderId'] != null && data['redirectUrl'] != null) {
          print('✅ [PhonePe] Order created successfully');
          print('✅ [PhonePe] Order ID: ${data['orderId']}');
          print('✅ [PhonePe] Redirect URL: ${data['redirectUrl']}');
          return data;
        } else {
          print('❌ [PhonePe] Missing required fields in response');
          print('❌ [PhonePe] Response data: $data');
          return null;
        }
      } else {
        print('❌ [PhonePe] Order creation failed');
        print('❌ [PhonePe] Error response: ${response.body}');
        return null;
      }
    } catch (e, stackTrace) {
      print('❌ [PhonePe] Order creation error: $e');
      print('❌ [PhonePe] Stack trace: $stackTrace');
      return null;
    }
  }

  void startPhonePePayment(double amount, String planName) async {
    // Show "coming soon" dialog instead of processing payment
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.schedule,
                  color: primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Coming Soon!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Feature',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The payment feature for $planName plan (₹${amount.toInt()}) will be available soon. We\'re working hard to bring you a seamless payment experience.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active,
                      color: primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'We\'ll notify you when payments are live!',
                        style: TextStyle(
                          fontSize: 13,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Got it',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    // TODO: Uncomment below code when payment feature is ready
    /*
    print('💳 [PhonePe] Starting payment process');
    print('💳 [PhonePe] Amount: $amount, Plan: $planName');
    
    try {
      final orderResponse = await createOrder(amount, planName);
      
      if (orderResponse == null) {
        print('❌ [PhonePe] Failed to create order');
        Fluttertoast.showToast(msg: "Failed to create order");
        return;
      }

      final orderId = orderResponse['orderId'];
      final redirectUrl = orderResponse['redirectUrl'];

      print('💳 [PhonePe] Payment order created');
      print('💳 [PhonePe] Order ID: $orderId');
      print('💳 [PhonePe] Redirect URL: $redirectUrl');

      // Launch the redirect URL in browser
      print('💳 [PhonePe] Attempting to launch payment page...');
      if (await canLaunchUrl(Uri.parse(redirectUrl))) {
        print('✅ [PhonePe] Launching payment page');
        final result = await launchUrl(
          Uri.parse(redirectUrl),
          mode: LaunchMode.externalApplication,
        );
        
        if (result) {
          print('✅ [PhonePe] Payment page launched successfully');
          // Start polling for payment status
          _pollPaymentStatus(orderId);
        } else {
          print('❌ [PhonePe] Failed to launch payment page');
          Fluttertoast.showToast(msg: "Could not launch payment page");
        }
      } else {
        print('❌ [PhonePe] Could not launch payment page');
        Fluttertoast.showToast(msg: "Could not launch payment page");
      }

    } catch (e, stackTrace) {
      print('❌ [PhonePe] Payment process error: $e');
      print('❌ [PhonePe] Stack trace: $stackTrace');
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
    */
  }

  Future<void> _pollPaymentStatus(String orderId) async {
    print('💳 [PhonePe] Starting payment status polling for order: $orderId');
    
    // Poll for 5 minutes (30 seconds interval)
    for (int i = 0; i < 10; i++) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/checkout/v2/status/$orderId'),
          headers: {
            'Authorization': 'O-Bearer $authToken',
            'Accept': 'application/json',
          },
        );

        print('💳 [PhonePe] Status check response: ${response.body}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final state = data['state'];
          
          if (state == 'SUCCESS') {
            print('✅ [PhonePe] Payment successful');
            HomeUtils.purchasePlan(planId);
            Fluttertoast.showToast(msg: "Payment Successful");
            return;
          } else if (state == 'FAILED') {
            print('❌ [PhonePe] Payment failed');
            Fluttertoast.showToast(msg: "Payment Failed");
            return;
          }
        }
        
        // Wait for 30 seconds before next poll
        await Future.delayed(const Duration(seconds: 30));
      } catch (e) {
        print('❌ [PhonePe] Error checking payment status: $e');
      }
    }
    
    print('⚠️ [PhonePe] Payment status polling timed out');
    Fluttertoast.showToast(msg: "Payment status unknown. Please check your order history.");
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
