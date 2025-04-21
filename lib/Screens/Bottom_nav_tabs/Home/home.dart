import 'package:intl/intl.dart';
import 'package:spires_app/Data/programs_data.dart';
import 'package:spires_app/Model/logo_model.dart';
import 'package:spires_app/Models/quiz_model.dart';
import 'package:spires_app/Screens/Bottom_nav_tabs/program_detail_test.dart';
import 'package:spires_app/Screens/games.dart';
import 'package:spires_app/Screens/quiz_listing.dart';
import 'package:spires_app/Services/api_service.dart';
import '../../../Constants/exports.dart';
import '../../../Utils/banner.dart';
import '../Drawer/programs_screen.dart';
import '../../live_openings_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final c = Get.put(MyController());
  final c1 = Get.put(NearbyJobController());

  List<Quiz> _liveQuizzes = [];
  bool _isLoadingQuizzes = false;

  @override
  void initState() {
    super.initState();
    c1.getJobs();
    _fetchLiveQuizzes();
  }

  Future<void> _fetchLiveQuizzes() async {
    setState(() {
      _isLoadingQuizzes = true;
    });

    try {
      final response = await ApiService.fetchQuizzes();
      setState(() {
        _liveQuizzes = response.data.quizzes;
        _isLoadingQuizzes = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingQuizzes = false;
      });
    }
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
                    Column(
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
                                  letterSpacing: -0.5,
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
                        const SizedBox(height: 8),
                        CarouselSlider(
                          items: ProgramsData.programs
                              .map(
                                (program) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    onTap: () => Get.to(() => ProgramDetailTest(
                                          imageUrl: program.imageUrl,
                                          title: program.title,
                                          description: program.description,
                                          benefits: program.benefits,
                                          howItWorks: program.howItWorks,
                                          faqs: program.faqs,
                                        )),
                                    borderRadius: BorderRadius.circular(24),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.06),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(24)),
                                                child: Stack(
                                                  children: [
                                                    Image.asset(
                                                      program.imageUrl,
                                                      height: 160,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned.fill(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                              Colors
                                                                  .transparent,
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.3),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                top: 12,
                                                right: 12,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        blurRadius: 8,
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.star_rounded,
                                                          color: Colors.amber,
                                                          size: 16),
                                                      const SizedBox(width: 3),
                                                      Text(
                                                        "4.8",
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: primaryColor
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Text(
                                                        "Featured",
                                                        style: TextStyle(
                                                          color: primaryColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      "2 Months",
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  program.title,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black87,
                                                    height: 1.2,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  program.description,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[600],
                                                    height: 1.4,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () => Get.to(
                                                            () =>
                                                                ProgramDetailTest(
                                                                  imageUrl: program
                                                                      .imageUrl,
                                                                  title: program
                                                                      .title,
                                                                  description:
                                                                      program
                                                                          .description,
                                                                  benefits: program
                                                                      .benefits,
                                                                  howItWorks:
                                                                      program
                                                                          .howItWorks,
                                                                  faqs: program
                                                                      .faqs,
                                                                )),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              primaryColor,
                                                          foregroundColor:
                                                              Colors.white,
                                                          elevation: 0,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 12),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'View Details',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[50],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                          color:
                                                              Colors.grey[200]!,
                                                        ),
                                                      ),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          Share.share(
                                                              'Check out this program: ${program.title}');
                                                        },
                                                        icon: Icon(
                                                          Icons.share_rounded,
                                                          color: primaryColor,
                                                          size: 20,
                                                        ),
                                                        constraints:
                                                            const BoxConstraints(
                                                          minWidth: 40,
                                                          minHeight: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          options: CarouselOptions(
                            height: 340,
                            autoPlay: true,
                            viewportFraction: 0.85,
                            autoPlayInterval: const Duration(seconds: 6),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 1000),
                            autoPlayCurve: Curves.easeInOutCubic,
                            pauseAutoPlayOnTouch: true,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Live Contests",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Get.to(() => const QuizListScreen()),
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
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 190,
                          child: _isLoadingQuizzes
                              ? const Center(child: CircularProgressIndicator())
                              : _liveQuizzes.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No live contests available',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _liveQuizzes.length,
                                      itemBuilder: (context, index) {
                                        final quiz = _liveQuizzes[index];
                                        return _buildContestCard(
                                          title: quiz.title,
                                          dateTime: DateFormat('MMM d, h:mm a')
                                              .format(quiz.fromDate),
                                          participants:
                                              "${quiz.questionsCount} Questions",
                                          prize: "${quiz.duration} mins",
                                          color: _getColorForIndex(index),
                                          icon: _getIconForIndex(index),
                                          quiz: quiz,
                                        );
                                      },
                                    ),
                        ),
                      ],
                    ),
                    const FeaturedCategory(),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Live Openings",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.to(() =>
                                    LiveOpeningsScreen(showLeading: true)),
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
                          SizedBox(
                            height: 180,
                            child: ListView(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildOpeningCard(
                                  title: 'Accountant',
                                  description:
                                      'Manage financial records and assist in audits.',
                                  icon: Icons.account_balance,
                                  color: Colors.blue,
                                ),
                                _buildOpeningCard(
                                  title: 'Graphic Design',
                                  description:
                                      'Create visual content for marketing campaigns.',
                                  icon: Icons.palette,
                                  color: Colors.purple,
                                ),
                                _buildOpeningCard(
                                  title: 'Web Design',
                                  description:
                                      'Develop and maintain website layouts.',
                                  icon: Icons.computer,
                                  color: Colors.teal,
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
        icon: Icon(icon, color: primaryColor),
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

  Widget _buildOpeningCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 200,
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: InkWell(
          onTap: () => Get.to(() => LiveOpeningsScreen(showLeading: true)),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContestCard({
    required String title,
    required String dateTime,
    required String participants,
    required String prize,
    required Color color,
    required IconData icon,
    required Quiz quiz,
  }) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.to(() => QuizListScreen()),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer_outlined,
                              color: Colors.red.shade700, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        dateTime,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.quiz_outlined,
                              size: 14, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            participants,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        prize,
                        style: TextStyle(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue[700]!,
      Colors.green[700]!,
      Colors.purple[700]!,
      Colors.orange[700]!,
      Colors.teal[700]!,
    ];
    return colors[index % colors.length];
  }

  IconData _getIconForIndex(int index) {
    final icons = [
      Icons.quiz_rounded,
      Icons.psychology_rounded,
      Icons.school_rounded,
      Icons.lightbulb_rounded,
      Icons.extension_rounded,
    ];
    return icons[index % icons.length];
  }
}
