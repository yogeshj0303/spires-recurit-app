import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Constants/exports.dart';
import '../../Controllers/my_controller.dart';
import '../../Model/review_model.dart';

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
  // Add state variables for reviews
  List<Data> testimonials = [];
  bool isLoadingTestimonials = true;
  String? testimonialsError;

  Future<void> inquire(String programName, String userId) async {
    // Check if user is in guest mode
    if (widget.c.isGuestMode.value) {
      // Show dialog asking user to sign in
      Get.defaultDialog(
        title: 'Sign In Required',
        middleText: 'You need to sign in to send an inquiry about this program. Would you like to sign in now?',
        confirmTextColor: whiteColor,
        confirm: myButton(
          onPressed: () {
            Get.back(); // Close dialog
            Get.to(() => LoginScreen(), transition: Transition.rightToLeft); // Navigate to login
          },
          label: 'Sign In',
          color: primaryColor,
          style: normalWhiteText,
        ),
        cancel: myButton(
          onPressed: () => Get.back(),
          label: 'Cancel',
          color: Colors.grey[400]!,
          style: normalWhiteText,
        ),
      );
      return;
    }
    
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

  // Function to fetch testimonials from API
  Future<void> fetchTestimonials() async {
    try {
      setState(() {
        isLoadingTestimonials = true;
        testimonialsError = null;
      });

      final ReviewModel reviewModel = await HomeUtils.getReviews();
      
      // Debug: Print the testimonials data
      print('Fetched testimonials: ${reviewModel.data?.length} items');
      for (var testimonial in reviewModel.data ?? []) {
        print('Testimonial: ${testimonial.name}');
        print('Description: ${testimonial.description}');
        print('Description length: ${testimonial.description?.length}');
      }
      
      setState(() {
        testimonials = reviewModel.data ?? [];
        isLoadingTestimonials = false;
      });
    } catch (e) {
      setState(() {
        testimonialsError = 'Failed to load testimonials: $e';
        isLoadingTestimonials = false;
      });
      print('Error fetching testimonials: $e');
    }
  }

  // Helper function to strip HTML tags and get plain text
  String stripHtmlTags(String htmlString) {
    // Remove HTML tags using regex
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String plainText = htmlString.replaceAll(exp, '');
    // Decode HTML entities
    plainText = plainText
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
    return plainText.trim();
  }

  late TabController _tabController;
  late Razorpay _razorpay;

  TextEditingController amtController = TextEditingController();
  void openCheckout() async {
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
                'The payment feature for ${widget.title} program (₹${amtController.text}) will be available soon. We\'re working hard to bring you a seamless payment experience.',
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
    // Check if user is in guest mode
    if (widget.c.isGuestMode.value) {
      // Show dialog asking user to sign in
      Get.defaultDialog(
        title: 'Sign In Required',
        middleText: 'You need to sign in to enroll in this program. Would you like to sign in now?',
        confirmTextColor: whiteColor,
        confirm: myButton(
          onPressed: () {
            Get.back(); // Close dialog
            Get.to(() => LoginScreen(), transition: Transition.rightToLeft); // Navigate to login
          },
          label: 'Sign In',
          color: primaryColor,
          style: normalWhiteText,
        ),
        cancel: myButton(
          onPressed: () => Get.back(),
          label: 'Cancel',
          color: Colors.grey[400]!,
          style: normalWhiteText,
        ),
      );
      return;
    }
    
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
    */
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

    // Fetch testimonials from API
    fetchTestimonials();
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
                  child: isLoadingTestimonials
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : testimonialsError != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Failed to load testimonials',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextButton(
                                    onPressed: fetchTestimonials,
                                    child: Text(
                                      'Retry',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : testimonials.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.rate_review_outlined,
                                        size: 48,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No testimonials available',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : CarouselSlider(
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
                                                backgroundImage: testimonial.image != null
                                                    ? NetworkImage('$imgPath/${testimonial.image}')
                                                    : AssetImage('assets/images/logo.png') as ImageProvider,
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                testimonial.name ?? 'Anonymous',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                testimonial.date ?? '',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 24),
                                                child: testimonial.description != null
                                                    ? Container(
                                                        constraints: BoxConstraints(
                                                          maxHeight: 120, // Limit height to prevent overflow
                                                        ),
                                                        child: Text(
                                                          stripHtmlTags(testimonial.description!),
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 15,
                                                            height: 1.5,
                                                            color: Colors.black54,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                          maxLines: 4,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      )
                                                    : Text(
                                                        'No description available',
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
                              'support@spiresrecruit.com',
                            ),
                            _buildContactInfo(
                              Icons.phone_outlined,
                              '+91 7753900944',
                            ),
                            _buildContactInfo(
                              Icons.language_outlined,
                              'www.spiresrecruit.com',
                            ),
                            _buildContactInfo(
                              Icons.location_on_outlined,
                              '93, Bajrang Colony, Jhansi, Uttar Pradesh 284128',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Check if user is in guest mode
                            if (widget.c.isGuestMode.value) {
                              // Show dialog asking user to sign in
                              Get.defaultDialog(
                                title: 'Sign In Required',
                                middleText: 'You need to sign in to contact us. Would you like to sign in now?',
                                confirmTextColor: whiteColor,
                                confirm: myButton(
                                  onPressed: () {
                                    Get.back(); // Close dialog
                                    Get.to(() => LoginScreen(), transition: Transition.rightToLeft); // Navigate to login
                                  },
                                  label: 'Sign In',
                                  color: primaryColor,
                                  style: normalWhiteText,
                                ),
                                cancel: myButton(
                                  onPressed: () => Get.back(),
                                  label: 'Cancel',
                                  color: Colors.grey[400]!,
                                  style: normalWhiteText,
                                ),
                              );
                            } else {
                              // Handle contact action for signed-in users
                              inquire(widget.title, MyController.id.toString());
                            }
                          },
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
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
