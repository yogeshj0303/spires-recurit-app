import 'package:flutter/material.dart';
import '../Constants/exports.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:math';

class MembershipDriveScreen extends StatefulWidget {
  const MembershipDriveScreen({super.key});

  @override
  State<MembershipDriveScreen> createState() => _MembershipDriveScreenState();
}

class _MembershipDriveScreenState extends State<MembershipDriveScreen> {
  String environment = "SANDBOX";
  String appId = "TEST-M2262FQ2G51D7_25050";
  String merchantId = "MERCHANTUAT";
  bool enableLogging = true;
  String checksum = "";
  String saltKey = "ZDViYzI4MzgtODQ4Ny00M2YyLWFjYzItZmI2MTU5NTU1ZDIy";
  String saltIndex = "1";
  String apiEndPoint = "/pg/orders";

  @override
  void initState() {
    super.initState();
    initializePhonePe();
  }

  void initializePhonePe() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) {
      setState(() {
        // SDK initialized successfully
      });
    }).catchError((error) {
      // Handle initialization error
      print("PhonePe SDK initialization error: $error");
    });
  }

  String generateSha256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void startPhonePePayment(String amount, String planName) async {
    try {
      // Generate a unique order ID in the format required by PhonePe
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String orderId = "ORDER_${timestamp}_${(1000 + Random().nextInt(9000))}";
      String merchantTransactionId = orderId;
      
      // Create the payment payload according to PhonePe's requirements
      Map<String, dynamic> data = {
        "merchantId": merchantId,
        "merchantTransactionId": merchantTransactionId,
        "merchantUserId": "MUID_$timestamp",
        "amount": (int.parse(amount) * 100).toString(), // Convert to paise
        "redirectUrl": "https://webhook.site/redirect-url",
        "redirectMode": "POST",
        "callbackUrl": "https://webhook.site/callback-url",
        "mobileNumber": "9999999999",
        "paymentInstrument": {
          "type": "PAYMENT_PAGE",
          "targetApp": "com.phonepe.app",
          "appId": "com.atc.spires_app"
        }
      };

      // Convert to JSON string first, then encode to base64
      String jsonString = json.encode(data);
      String base64Body = base64.encode(utf8.encode(jsonString));
      
      // Generate checksum
      String string = base64Body + apiEndPoint + saltKey;
      String sha256 = generateSha256(string);
      checksum = sha256 + "###" + saltIndex;

      print("Payment payload: $jsonString");
      print("Base64 encoded payload: $base64Body");
      print("Checksum: $checksum");

      // Create the final payload
      Map<String, dynamic> finalPayload = {
        "merchantId": merchantId,
        "merchantTransactionId": merchantTransactionId,
        "merchantUserId": "MUID_$timestamp",
        "amount": (int.parse(amount) * 100).toString(),
        "redirectUrl": "https://webhook.site/redirect-url",
        "redirectMode": "POST",
        "callbackUrl": "https://webhook.site/callback-url",
        "mobileNumber": "9999999999",
        "paymentInstrument": {
          "type": "PAYMENT_PAGE",
          "targetApp": "com.phonepe.app",
          "appId": "com.atc.spires_app"
        },
        "data": base64Body,
        "checksum": checksum,
        "saltKey": saltKey,
        "saltIndex": saltIndex,
        "apiEndPoint": apiEndPoint,
        "orderId": orderId,
        "token": checksum
      };

      print("Final payload: ${json.encode(finalPayload)}");

      // First initialize the SDK
      await PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging);
      
      // Then start the transaction
      var response = await PhonePePaymentSdk.startTransaction(
        json.encode(finalPayload),
        checksum,
      );

      if (response != null) {
        print("Payment response: $response");
        String status = response['status']?.toString() ?? 'FAILED';
        String error = response['error']?.toString() ?? 'Unknown error';
        
        if (status == 'SUCCESS') {
          // Payment successful
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Payment Successful'),
                content: Text('Your $planName plan has been activated successfully!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Payment failed
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Payment Failed'),
                content: Text('Error: $error'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (error) {
      print("Payment error: $error");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred while processing the payment: $error'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor,
                      primaryColor.withOpacity(1), // Dark blue-gray color
                    ],
                  ),
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SPIRES RECRUIT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 2),
                  const Text(
                    'Membership Drive',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Row(
                            children: [
                              Icon(Icons.info_outline, color: primaryColor),
                              const SizedBox(width: 8),
                              const Text(
                                'Important Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoItem(
                                'Payment',
                                'One-time registration fee of ₹199',
                              ),
                              const SizedBox(height: 10),
                              _buildInfoItem(
                                'Validity',
                                'Membership valid for 1 year',
                              ),
                              const SizedBox(height: 10),
                              _buildInfoItem(
                                'Support',
                                'Contact: +91 7753900602',
                              ),
                              const SizedBox(height: 10),
                              _buildInfoItem(
                                'Note',
                                'Profile picture is mandatory for ID card',
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Got it',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 2),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header Container with gradient background
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [primaryColor, primaryColor.withOpacity(0.1)],
                  ),
                ),
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SPIRES RECRUIT',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'An organization dedicated to the career growth of students in internship and job searching, as well as skill improvement.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
      
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                
                    // After Benefits Section and before Registration Form
                    _buildPricingTable(),
                    _buildFooter(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.business,
              color: primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Regards,',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Team Spires Recruit',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      '+91 7753900602',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.language, size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'www.spiresrecruit.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingTable() {
    final plans = [
      {
        'title': 'Basic',
        'subtitle': 'Essential features',
        'price': '200',
        'period': 'one-time',
        'features': {
          'Appear in general search results': true,
          'Accept mobile applications': true,
          'Manage candidates directly from your Indeed account': true,
        },
        'buttonText': 'Buy Now',
        'isPopular': false,
      },
      {
        'title': 'Advanced',
        'subtitle': 'Most recommended',
        'price': '999',
        'period': 'one-time',
        'features': {
          'Appear in general search results': true,
          'Accept mobile applications': true,
          'Manage candidates directly from your Indeed account': true,
        },
        'buttonText': 'Buy Now',
        'isPopular': true,
      },
      {
        'title': 'Premium',
        'subtitle': 'Complete solution',
        'price': '1499',
        'period': 'one-time',
        'features': {
          'Appear in general search results': true,
          'Accept mobile applications': true,
          'Manage candidates directly from your Indeed account': true,
        },
        'buttonText': 'Buy Now',
        'isPopular': false,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: CarouselSlider.builder(
        itemCount: plans.length,
        options: CarouselOptions(
          clipBehavior: Clip.none,
          height: 480,
          viewportFraction: 0.9,
          enableInfiniteScroll: false,
          initialPage: 1,
        ),
        itemBuilder: (context, index, realIndex) {
          final plan = plans[index];
          return _buildPlanCard(
            title: plan['title'] as String,
            subtitle: plan['subtitle'] as String,
            price: plan['price'] as String,
            period: plan['period'] as String,
            features: plan['features'] as Map<String, bool>,
            buttonText: plan['buttonText'] as String,
            isPopular: plan['isPopular'] as bool,
          );
        },
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String subtitle,
    required String price,
    required String period,
    required Map<String, bool> features,
    required String buttonText,
    required bool isPopular,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? primaryColor.withOpacity(0.3) : Colors.grey.shade200,
          width: isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPopular 
                ? primaryColor.withOpacity(0.15)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            decoration: BoxDecoration(
              color: isPopular ? primaryColor : Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isPopular ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isPopular ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
                if (price != '0') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isPopular ? Colors.white70 : primaryColor,
                        ),
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: isPopular ? Colors.white : primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    period,
                    style: TextStyle(
                      fontSize: 14,
                      color: isPopular ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Features and Button Container
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (isPopular)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.deepOrange,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'RECOMMENDED',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Features List
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: features.entries.map((feature) => Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: feature.value 
                                  ? Colors.green.shade50 
                                  : Colors.grey.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              feature.value 
                                  ? Icons.check_rounded
                                  : Icons.remove_rounded,
                              color: feature.value 
                                  ? Colors.green.shade500 
                                  : Colors.grey.shade400,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature.key,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      )).toList(),
                    ),
                  ),
                  // Button
                  Container(
                    width: double.infinity,
                    height: 46,
                    margin: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () => startPhonePePayment(price, title),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPopular ? primaryColor : Colors.white,
                        foregroundColor: isPopular ? Colors.white : primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isPopular 
                                ? Colors.transparent 
                                : primaryColor,
                          ),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
