import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
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
                                      onTap: () =>
                                          Get.to(() => ProgramDetailTest(
                                                imageUrl: program.imageUrl,
                                                title: program.title,
                                                description:
                                                    program.description,
                                                benefits: program.benefits,
                                                howItWorks: program.howItWorks,
                                                faqs: program.faqs,
                                              )),
                                      borderRadius: BorderRadius.circular(24),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.06),
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
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                          top: Radius.circular(
                                                              24)),
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
                                                          offset: const Offset(
                                                              0, 2),
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
                                                        const SizedBox(
                                                            width: 3),
                                                        Text(
                                                          "4.8",
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black87,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 4),
                                                        decoration:
                                                            BoxDecoration(
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
                                                          color:
                                                              Colors.grey[600],
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
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                          onPressed: () =>
                                                              Get.to(() =>
                                                                  ProgramDetailTest(
                                                                    imageUrl:
                                                                        program
                                                                            .imageUrl,
                                                                    title: program
                                                                        .title,
                                                                    description:
                                                                        program
                                                                            .description,
                                                                    benefits:
                                                                        program
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
                                                                    vertical:
                                                                        12),
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
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[50],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                            color: Colors
                                                                .grey[200]!,
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
                                ? const Center(
                                    child: CircularProgressIndicator())
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
                                            dateTime:
                                                DateFormat('MMM d, h:mm a')
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
                      _buildCareerCounsellorsSection(),
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

  Widget _buildCareerCounsellorsSection() {
    return Container(
      clipBehavior: Clip.none,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Best Career Counsellors",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  letterSpacing: -0.5,
                ),
              ),
              TextButton(
                onPressed: () => _showChatForm(),
                child: Text(
                  "Chat with Us",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: ListView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              children: [
                _buildCounsellorCard(
                  name: "Dr. Sarah Johnson",
                  imageUrl:
                      "https://www.spiresrecruit.com/uploads/counsellors/counsellor1.jpg",
                  expertise: "Career Development & Education",
                  experience: "15+ years",
                  specialization: "University Admissions",
                ),
                _buildCounsellorCard(
                  name: "Michael Chen",
                  imageUrl:
                      "https://www.spiresrecruit.com/uploads/counsellors/counsellor2.jpg",
                  expertise: "Professional Development",
                  experience: "12+ years",
                  specialization: "Career Transitions",
                ),
                _buildCounsellorCard(
                  name: "Dr. Emily Rodriguez",
                  imageUrl:
                      "https://www.spiresrecruit.com/uploads/counsellors/counsellor3.jpg",
                  expertise: "Student Counselling",
                  experience: "10+ years",
                  specialization: "Study Abroad",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounsellorCard({
    required String name,
    required String imageUrl,
    required String expertise,
    required String experience,
    required String specialization,
  }) {
    return Container(
      width: 280,
      height: 250, // Fixed height
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image Section - Fixed height
          SizedBox(
            height: 140,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child:
                          Icon(Icons.person, size: 40, color: Colors.grey[400]),
                    ),
                  ),
                ),
                // Experience Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      experience,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content Section - Flexible height
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and WhatsApp button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final url = "https://wa.me/+919329143659";
                              try {
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch WhatsApp';
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        const Text('Could not launch WhatsApp'),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Image.asset(
                                'assets/icons/whatsapp.png',
                                width: 25,
                                height: 25,
                                // color: Colors.green.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Expertise and Specialization
                  Row(
                    children: [
                      Icon(Icons.school_rounded,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          expertise,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          specialization,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChatForm() {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String email = '';
    String message = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Modern Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Attractive Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.support_agent_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Connect with Expert',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Get personalized career guidance',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          Icon(Icons.close, size: 20, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Benefits Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  _buildBenefitItem(
                    Icons.access_time_rounded,
                    'Quick Response',
                    'Within 1 hour',
                  ),
                  _buildBenefitItem(
                    Icons.verified_user_rounded,
                    'Expert Advice',
                    'Certified counselors',
                  ),
                  _buildBenefitItem(
                    Icons.support_rounded,
                    'Free Support',
                    'Always available',
                  ),
                ],
              ),
            ),
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      _buildFormField(
                        label: 'Full Name',
                        hint: 'Enter your name',
                        icon: Icons.person_outline_rounded,
                        onChanged: (value) => name = value,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildFormField(
                        label: 'Email Address',
                        hint: 'Enter your email',
                        icon: Icons.email_outlined,
                        onChanged: (value) => email = value,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Email is required' : null,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildFormField(
                        label: 'Message',
                        hint: 'How can we help you?',
                        icon: Icons.message_outlined,
                        onChanged: (value) => message = value,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Message is required'
                            : null,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Submit Button Container
            Container(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    // TODO: Implement form submission
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Start Consultation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add these helper methods
  Widget _buildBenefitItem(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: onChanged,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(icon, size: 22, color: Colors.grey[400]),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 0,
            ),
          ),
        ),
      ],
    );
  }
}
