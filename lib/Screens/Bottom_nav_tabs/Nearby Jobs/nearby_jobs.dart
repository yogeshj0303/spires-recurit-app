import 'package:spires_app/Constants/exports.dart';
import '../../../Model/job_model.dart';

class NearbyJobs extends StatefulWidget {
  final String cityName;
  final bool isCityWise;
  const NearbyJobs(
      {super.key, required this.cityName, required this.isCityWise});

  @override
  State<NearbyJobs> createState() => _NearbyJobsState();
}

class _NearbyJobsState extends State<NearbyJobs> {
  final c = Get.put(NearbyJobController());
  final control = Get.put(MyController());
  final searchControl = TextEditingController();
  bool isSearch = false;

  @override
  void initState() {
    super.initState();
    searchControl.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: isSearch ? searchAppBar() : appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Obx(
            () => control.isJobLoading.value
                ? loading
                : control.isLocationLoading.value && !widget.isCityWise
                    ? enableLocation(size)
                    : FutureBuilder<JobModel>(
                        future: c.showNearbyJobs(widget.cityName),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.data!.isEmpty) {
                              emptyCard();
                            }
                            List<Data> allJobData = snapshot.data!.data!;
                            List<Data> searchData = allJobData;
                            searchData = searchData
                                .where(
                                  (e) => e.jobTitle!.toLowerCase().contains(
                                      searchControl.text.toLowerCase()),
                                )
                                .toList();
                            if (searchData.isEmpty &&
                                searchControl.text.isNotEmpty) {
                              return Center(
                                  child: Text('No results found',
                                      style: mediumText));
                            }
                            return Column(
                              children: [
                                widget.isCityWise
                                    ? Container()
                                    : locationCard(),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: searchData.length,
                                  itemBuilder: (context, index) =>
                                      filterJobCard(searchData, index, size),
                                ),
                              ],
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (context, index) =>
                                  cardShimmer(size),
                            );
                          }
                        },
                      ),
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title:
          widget.isCityWise ? Text(widget.cityName) : const Text('Nearby Jobs'),
      actions: [
        IconButton(
          onPressed: () => setState(() => isSearch = true),
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  AppBar searchAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: TextFormField(
        controller: searchControl,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: 'Search with Job keywords',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => isSearch = false),
          ),
        ),
      ),
    );
  }

  Widget emptyCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          widget.isCityWise ? Container() : locationCard(),
          widget.isCityWise
              ? Text(
                  'No Jobs Available for ${widget.cityName}',
                  style: normalLightText,
                  textAlign: TextAlign.center,
                )
              : Text(
                  'No Jobs Available for ${widget.cityName}',
                  style: normalLightText,
                  textAlign: TextAlign.center,
                ),
        ],
      ),
    );
  }

  SizedBox enableLocation(Size size) {
    return SizedBox(
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please enable your location services',
            style: normalLightText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          myButton(
            onPressed: () => LocationServices.getLocation(),
            label: 'Enable Location',
            color: primaryColor,
            style: smallWhiteText,
          )
        ],
      ),
    );
  }

  MyContainer locationCard() {
    return MyContainer(
      color: whiteColor,
      margin: const EdgeInsets.all(defaultMargin),
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.my_location, color: primaryColor),
              const SizedBox(width: 12),
              Text(
                'Showing nearby jobs based on: \n${control.location.value}',
                style: smallText,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
  
  Widget filterJobCard(List<Data> filterData, int index, Size size) {
    final item = filterData[index];
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      margin: const EdgeInsets.only(
          bottom: defaultMargin, left: defaultMargin, right: defaultMargin),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          activelyHiring(),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.55,
                    child: Text(
                      item.jobTitle!,
                      style: mediumBoldText,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(item.admin?.username ?? "Unknown Company", style: normalLightText),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Image.asset(homeFilled, height: 16),
              const SizedBox(width: 8),
              Text(item.jobType ?? "", style: smallLightText),
              const Spacer(),
              const Icon(Icons.payments, color: primaryColor, size: 16),
              const SizedBox(width: 8),
              Text(item.salary != null ? '₹${item.salary} p.a.' : 'Not specified',
                  style: smallLightText),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Image.asset(jobsfilled, height: 16),
              const SizedBox(width: 8),
              Text('${item.experience ?? "0"}+ years experience', style: smallLightText),
              const Spacer(),
              const Icon(Icons.location_on, color: primaryColor, size: 16),
              const SizedBox(width: 8),
              Text(item.location ?? "Remote", style: smallLightText),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              MyContainer(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding * 0.5, horizontal: defaultPadding),
                color: primaryColor.withOpacity(0.2),
                child: Text('Job', style: xsmallText),
              ),
              const Spacer(),
              InkWell(
                onTap: () => shareJobs(item.id!.toInt()),
                child: const Icon(Icons.share, size: 20),
              )
            ],
          ),
          const Divider(color: Colors.black26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Get.to(() => FilteredJobDetails(snapshot: filterData, index: index)),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('View Details', style: normalColorText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
