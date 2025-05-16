import 'package:flutter/material.dart';
import 'package:spires_app/Constants/exports.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          _buildTopThree(context),
          Expanded(
            child: _buildRankingList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTopThree(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildSecondPlace(),
          _buildFirstPlace(),
          _buildThirdPlace(),
        ],
      ),
    );
  }

  Widget _buildFirstPlace() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.amber.shade300,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.shade300.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/90'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: -15,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.amber.shade200,
                      Colors.amber.shade400,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.shade300.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'John Doe',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Text(
          '950 Points',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondPlace() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 3,
                ),
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/80'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: -8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Jane Smith',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        Text(
          '920 Points',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildThirdPlace() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.amber.shade700,
                  width: 3,
                ),
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/80'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: -8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.shade700.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Mike Johnson',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        Text(
          '890 Points',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildRankingList(BuildContext context) {
    final List<Map<String, dynamic>> rankings = [
      {'rank': 4, 'name': 'Sarah Wilson', 'points': 850, 'image': 'https://via.placeholder.com/40'},
      {'rank': 5, 'name': 'David Brown', 'points': 820, 'image': 'https://via.placeholder.com/40'},
      {'rank': 6, 'name': 'Emily Davis', 'points': 800, 'image': 'https://via.placeholder.com/40'},
      {'rank': 7, 'name': 'Michael Lee', 'points': 780, 'image': 'https://via.placeholder.com/40'},
      {'rank': 8, 'name': 'Lisa Anderson', 'points': 760, 'image': 'https://via.placeholder.com/40'},
      {'rank': 9, 'name': 'Tom Wilson', 'points': 740, 'image': 'https://via.placeholder.com/40'},
      {'rank': 10, 'name': 'Anna Taylor', 'points': 720, 'image': 'https://via.placeholder.com/40'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final rank = rankings[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
                image: DecorationImage(
                  image: NetworkImage(rank['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              rank['name'],
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              '${rank['points']} Points',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
            trailing: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  '${rank['rank']}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 