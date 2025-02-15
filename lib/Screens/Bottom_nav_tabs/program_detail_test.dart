import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:spires_app/Payment/razor_pay.dart';

import '../../Constants/exports.dart';
import '../../Controllers/my_controller.dart';

class ProgramDetailTest extends StatefulWidget {
  final c = Get.put(MyController());
  final String imageUrl;
  final String title;
  final String description;
  final String benefits;
  final List<Map<String, String>> faqs;
  final String howItWorks;

  ProgramDetailTest({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.benefits,
    required this.howItWorks,
    this.faqs = const [],
  });

  @override
  State<ProgramDetailTest> createState() => _ProgramDetailTestState();
}

class _ProgramDetailTestState extends State<ProgramDetailTest>
    with SingleTickerProviderStateMixin {
  Future<void> inquire(String programName, String userId) async {
    var headers = {
      'Authorization':
          'Bearer sk-proj-lvOy2JU3EbHjOlkGjHMZT3BlbkFJbPIDfmDJQk89WcagsYgr'
    };

    var request = http.Request(
      'POST',
      Uri.parse(
          'https://spiresrecruit.com/api/program-enquiry?program_name=$programName&user_id=$userId'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: const Text(
            'Inquiry Sent',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          content: const Text(
            'Your inquiry has been sent successfully',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      );
      print('Inquiry sent');
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: const Text('Error', style: TextStyle(fontFamily: 'Poppins')),
          content: const Text(
            'An error occurred while sending your inquiry',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  final List<Testimonial> testimonials = [
    Testimonial(
      name: 'John Doe',
      text:
          "Nulla facilisi. Nullam laoreet odio a risus scelerisque, quis bibendum libero ultrices.",
      imageUrl: "assets/images/logo.png",
    ),
    Testimonial(
      name: 'Jane Doe',
      text:
          "Nulla facilisi. Nullam laoreet odio a risus scelerisque, quis bibendum libero ultrices.",
      imageUrl: "assets/images/logo.png",
    ),
    Testimonial(
      name: 'Alice Doe',
      text:
          "Nulla facilisi. Nullam laoreet odio a risus scelerisque, quis bibendum libero ultrices.",
      imageUrl: "assets/images/logo.png",
    ),
    Testimonial(
      name: 'Bob Doe',
      text:
          "Vestibulum pharetra enim non varius feugiat. Nunc et metus sed nulla fringilla mattis a quis orci.",
      imageUrl: "assets/images/logo.png",
    ),
  ];
  late TabController _tabController;
  late Razorpay _razorpay;

  TextEditingController amtController = TextEditingController();
  void openCheckout() async {
    var amount = num.parse(amtController.text) * 100;
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': amount,
      'name': 'Spires Recruit',
      'description': 'Payment for enrolling to a program',
      'prefill': {
        'contact': '8888888888',
        'email': 'test@gmail.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'Success: ${response.paymentId}');
    print('Payment Success');
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'Error: ${response.code} - ${response.message}');
    print('Payment Error');
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'External Wallet: ${response.walletName}');
    print('External Wallet');
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);

    // Set initial value for amount controller
    amtController.text = '834';
    amtController
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: amtController.text.length));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, size: 20,),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          physics: PageScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16),
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: 'Description'),
            Tab(text: 'Testimonials'),
            Tab(text: 'How it Works'),
            Tab(text: 'Talk to Us'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              physics: PageScrollPhysics(),
              controller: _tabController,
              children: [
                // Description Tab
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                widget.imageUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.description,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Benefits',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.benefits,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      height: 1.5,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Testimonials Tab
                Container(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 320.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      viewportFraction: 0.85,
                      autoPlayInterval: Duration(seconds: 3),
                    ),
                    items: testimonials.map((testimonial) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(testimonial.imageUrl),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  testimonial.name,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    testimonial.text,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      height: 1.5,
                                      color: Colors.black54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),

                // How it Works Tab
                SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How it Works',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.howItWorks,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      if (widget.faqs.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FAQs:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 8),
                            ...widget.faqs
                                .map((faq) => _buildFAQ(
                                      question: faq['question']!,
                                      answer: faq['answer']!,
                                    ))
                                .toList(),
                          ],
                        )
                    ],
                  ),
                ),

                // Talk to Us Tab
                SingleChildScrollView(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 120,
                              width: 120,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Get in Touch',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildContactInfo(
                              Icons.email_outlined,
                              'example@gmail.com',
                            ),
                            _buildContactInfo(
                              Icons.phone_outlined,
                              '+254 712 345 678',
                            ),
                            _buildContactInfo(
                              Icons.language_outlined,
                              'www.example.com',
                            ),
                            _buildContactInfo(
                              Icons.location_on_outlined,
                              '1234 Example Street, Nairobi',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Contact Us',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Payment Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '₹834',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '2 months plan',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 140,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: openCheckout,
                    child: Text(
                      'Pay Now',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 24),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class Testimonial {
  final String name;
  final String text;
  final String imageUrl;

  Testimonial({
    required this.text,
    required this.imageUrl,
    required this.name,
  });
}


Widget _buildFAQ({required String question, required String answer}) {
  return Padding(
    padding:
        const EdgeInsets.symmetric(vertical: 8.0), // Add spacing for clarity
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Q: $question',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5), // Smaller spacing for better visual appeal
        Text(
          'A: $answer',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
      ],
    ),
  );
}
