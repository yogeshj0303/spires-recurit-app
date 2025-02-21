import 'package:spires_app/Model/logo_model.dart';
import '../../../Constants/exports.dart';
import '../../../Utils/banner.dart';
import '../Drawer/programs_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final c = Get.put(MyController());
  final c1 = Get.put(NearbyJobController());
  @override
  void initState() {
    super.initState();
    c1.getJobs();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      key: _scaffoldKey,
      drawer: MyDrawer(size: size),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await c1.getJobs();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 75),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: BannerCarousel(size: size),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              "Explore Opportunities",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildModernQuickActionCard(
                                  icon: Icons.work_outline_rounded,
                                  title: "Find Jobs",
                                  subtitle: "Discover your next career move",
                                  color: primaryColor,
                                  onTap: () => Get.to(() => Jobs()),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildModernQuickActionCard(
                                  icon: Icons.school_outlined,
                                  title: "Internships",
                                  subtitle: "Kickstart your\ncareer journey",
                                  color: Colors.blue[700]!,
                                  onTap: () => Get.to(() => Internship()),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                   
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Our Programs",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Get.to(() => const ProgramsScreen()),
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CarouselSlider(
                            items: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                child: ProgramCard(
                                  imageUrl: 'assets/icons/1.png',
                                  title: 'SkillUp 1.0',
                                  description:
                                      'Description:SkillUp 1.0 is your comprehensive training program designed to equip you with the essential skills and knowledge needed to land your dream internship or entry-level job. Through interactive modules, practical exercises, and industry expert insights, you\'ll gain the confidence and competence to impress employers.',
                                  benefits:
                                      "• Gain valuable skills through interactive modules & practical exercises.\n• Build confidence with mock interviews, interview tips, & resume workshops.\n• Connect with industry professionals & gain insights into your dream career.\n• Get access to exclusive internship listings with top companies.\n• Receive personalized guidance & support from our career coaches.",
                                  onShare: () {
                                    // Handle share action
                                  },
                                  faqs: [
                                    {
                                      'question': 'Is SkillUp 1.0 free?',
                                      'answer':
                                          'Yes, SkillUp 1.0 is completely free to access for all Spires Recruit users.'
                                    },
                                    {
                                      'question':
                                          'What skills can I learn through SkillUp 1.0?',
                                      'answer':
                                          'SkillUp 1.0 offers a variety of modules covering in-demand skills such as communication, problem-solving, teamwork, digital marketing, social media marketing, data analysis, and more.'
                                    },
                                    {
                                      'question':
                                          'How do I get access to exclusive internship listings?',
                                      'answer':
                                          'By completing relevant SkillUp 1.0 modules and demonstrating your skills, you\'ll gain access to a curated list of internship opportunities from top companies.'
                                    },
                                    {
                                      'question':
                                          'Will I receive a certificate upon completion?',
                                      'answer':
                                          'Yes, upon successful completion of a SkillUp 1.0 learning path, you\'ll receive a digital certificate to showcase your acquired skills to potential employers.'
                                    },
                                  ],
                                  howItWorks:
                                      '1. Download the Spires Recruit app / website & create a free account.\n2. Select a learning path based on your career interests & desired skills.\n3. Work through interactive modules at your own pace, anytime, anywhere.\n4. Sharpen your skills with mock interviews & resume feedback.\n5. Network with companies and apply for exclusive internship opportunities.',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                child: ProgramCard(
                                  imageUrl: 'assets/icons/3.png',
                                  title: 'Resume Workshop',
                                  description:
                                      'Master the art of resume writing with our interactive Resume Workshop! Get expert guidance on building a compelling resume that stands out to hiring managers and lands you interviews.',
                                  benefits:
                                      '• Learn proven resume writing strategies.\n• Optimize your resume for Applicant Tracking Systems (ATS).\n• Tailor your resume for specific job applications.\n• Gain confidence in your resume writing skills.\n• Get feedback from career experts.\n• Network with other job seekers.',
                                  faqs: [
                                    {
                                      'question':
                                          'Is the Resume Workshop free?',
                                      'answer':
                                          'Yes, the Spires Recruit Resume Workshop is completely free to attend!'
                                    },
                                    {
                                      'question':
                                          'Who should attend the Resume Workshop?',
                                      'answer':
                                          'This workshop is beneficial for anyone seeking to improve their resume writing skills, from recent graduates to experienced professionals looking to make a career change.'
                                    },
                                    {
                                      'question':
                                          'What will I learn in the workshop?',
                                      'answer':
                                          'The workshop will cover a variety of topics, including resume structure, formatting, keyword optimization, crafting impactful achievements statements, and tailoring your resume for specific job applications.'
                                    },
                                    {
                                      'question':
                                          'How do I register for the workshop?',
                                      'answer':
                                          'Download the Spires Recruit app or visit our website (link) to find upcoming workshop dates and register.'
                                    },
                                  ],
                                  onShare: () {
                                    // Handle share action
                                  },
                                  howItWorks:
                                      '• Sign up for the free workshop through the Spires Recruit app / website.\n• Join our live, interactive workshop led by career development professionals.\n• Engage in interactive exercises and discussions to learn resume best practices.\n• Have the opportunity to receive personalized feedback on your resume during the workshop or through follow-up resources.',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                child: ProgramCard(
                                  imageUrl: 'assets/icons/2.png',
                                  title: 'Interview Preparation',
                                  description:
                                      'Nail your next interview with Spires Recruit\'s comprehensive Interview Preparation section! This interactive tool equips you with the knowledge and confidence to shine in any interview setting.',
                                  benefits:
                                      '• Boost confidence and reduce interview anxiety.\n• Learn effective strategies for answering common interview questions.\n• Practice your responses with interactive mock interview tools.\n• Receive personalized feedback to identify areas for improvement.\n• Gain insights into different interview formats and company cultures',
                                  faqs: [
                                    {
                                      'question':
                                          'What types of interview formats are covered?',
                                      'answer':
                                          'Spires Recruit covers various interview formats, including phone interviews, video interviews, and traditional in-person interviews.'
                                    },
                                    {
                                      'question':
                                          'How does the mock interview simulator work?',
                                      'answer':
                                          'The simulator provides a virtual interviewer and presents you with common interview questions. You can record your response and receive automated feedback on your body language, verbal delivery, and answer content.'
                                    },
                                    {
                                      'question':
                                          'Are there interview tips for different industries?',
                                      'answer':
                                          'Yes, we offer tailored interview prep resources for various industries, helping you understand industry-specific questions and expectations.'
                                    },
                                    {
                                      'question':
                                          'How can I access the Interview Preparation section?',
                                      'answer':
                                          'The Interview Preparation section is available within the Spires Recruit app. Download the app for free and explore all our resources designed to help you land your dream job!'
                                    },
                                  ],
                                  onShare: () {
                                    // Handle share action
                                  },
                                  howItWorks:
                                      '• Access a vast library of interview questions categorized by industry, job title & difficulty level.\n• Utilize our AI-powered mock interview simulator to practice your responses in a realistic setting.\n• Review detailed feedback reports on your mock interviews, highlighting strengths & areas for development./n• Watch informative video tutorials & read articles from industry professionals on interview best practices.',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                child: ProgramCard(
                                  imageUrl: 'assets/icons/jsdh.png',
                                  title: 'Coding Clubs',
                                  description:
                                      'The Spires Recruit Coding Club is a community for developers who are passionate about building and improving the Spires Recruit platform. We welcome coders of all experience levels, from beginners to seasoned professionals.',
                                  benefits:
                                      '• Work on real-world projects that utilize various coding skills and technologies.\n• Approach challenges creatively and find innovative solutions.\n• Get guidance and feedback from industry professionals.\n• Showcase your coding projects to potential employers.\n• Connect with other programmers who share your passion for coding.',
                                  faqs: [
                                    {
                                      'question':
                                          'Is there a cost to join the Spires Recruit Coding Club?',
                                      'answer':
                                          'No, the Spires Recruit Coding Club is completely free to join and participate in.'
                                    },
                                    {
                                      'question':
                                          'What coding experience level is required?',
                                      'answer':
                                          'The Spires Recruit Coding Club welcomes coders of all skill levels, from beginners to experienced programmers.'
                                    },
                                    {
                                      'question':
                                          'What programming languages are covered in the club?',
                                      'answer':
                                          'The Spires Recruit Coding Club covers a variety of popular programming languages, with the specific languages addressed depending on member interests and industry trends.'
                                    },
                                    {
                                      'question':
                                          'How do I find out about upcoming workshops and events?',
                                      'answer':
                                          'Announcements for upcoming workshops, challenges, and events will be posted within the Spires Recruit Coding Club forum and communicated through the Spires Recruit app.'
                                    },
                                  ],
                                  onShare: () {
                                    // Handle share action
                                  },
                                  fit: BoxFit.fill,
                                  howItWorks:
                                      '• Sign up for the Spires Recruit Coding Club through the Spires Recruit app / website.\n• Participate in weekly coding challenges designed to test and enhance your skills.\n• Attend regular online workshops and Q&A sessions hosted by industry experts.\n• Join discussions, share solutions, and get help from fellow club members.\n• Connect with other coders through the forum and participate in virtual coding meetups.',
                                ),
                              ),
                            ],
                            options: CarouselOptions(
                              height: 278,
                              autoPlay: true,
                              viewportFraction: 1,
                              autoPlayInterval: const Duration(seconds: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const FeaturedCategory(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.1),
                            Colors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: buildTopCompanies(),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Reviews(),
                    ),
                  ],
                ),
              ),
            ),
            _buildModernAppBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildModernAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            icon: const Icon(Icons.menu, color: Colors.black87),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${MyController.userFirstName} ${MyController.userLastName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildIconButton(
            icon: Icons.notifications_outlined,
            onTap: () => Get.to(() => const NotificationScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.black87),
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
      ),
    );
  }

  Widget _buildModernQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.12),
              color.withOpacity(0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.grey[900],
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                height: 1.3,
                letterSpacing: -0.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  buildTopCompanies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: primaryColor.withOpacity(0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: defaultPadding, left: defaultPadding),
                child: Text(
                  "Top Companies trust us",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder<LogoModel>(
                future: HomeUtils.getLogo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loading;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData ||
                      snapshot.data!.data!.isEmpty) {
                    return Text('No data available');
                  } else {
                    return Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      height: 70,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 70,
                          viewportFraction: 0.38,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                        ),
                        items: snapshot.data!.data!.map((logo) {
                          return Card(
                            elevation: 4,
                            color: whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: borderRadius,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: '$imgPath/${logo.logo}',
                              width: 115,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
