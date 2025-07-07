import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Model/user_subscription_plans_model.dart';
import 'package:spires_app/Utils/home_utils.dart';

class SubscriptionPlansCard extends StatefulWidget {
  const SubscriptionPlansCard({Key? key}) : super(key: key);

  @override
  State<SubscriptionPlansCard> createState() => _SubscriptionPlansCardState();
}

class _SubscriptionPlansCardState extends State<SubscriptionPlansCard> {
  final c = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultCardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.card_membership,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'My Subscription Plans',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<UserSubscriptionPlansModel>(
              future: HomeUtils.getUserSubscriptionPlans(MyController.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                  );
                }
                
                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.grey[400],
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load subscription plans',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                if (!snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.subscriptions_outlined,
                          color: Colors.grey[400],
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No subscription plans found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                final plans = snapshot.data!;
                final hasAnyPlans = (plans.membershipPlans?.isNotEmpty == true) ||
                    (plans.upgradePlans?.isNotEmpty == true) ||
                    (plans.certifiedPlans?.isNotEmpty == true);
                
                if (!hasAnyPlans) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.subscriptions_outlined,
                          color: Colors.grey[400],
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No active subscription plans',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => const UpgradeNow());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Upgrade Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return Column(
                  children: [
                    if (plans.membershipPlans?.isNotEmpty == true) ...[
                      _buildPlanSection(
                        'Membership Plans',
                        Icons.star,
                        plans.membershipPlans!,
                        Colors.amber,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (plans.upgradePlans?.isNotEmpty == true) ...[
                      _buildPlanSection(
                        'Upgrade Plans',
                        Icons.upgrade,
                        plans.upgradePlans!,
                        Colors.blue,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (plans.certifiedPlans?.isNotEmpty == true) ...[
                      _buildPlanSection(
                        'Certified Plans',
                        Icons.verified,
                        plans.certifiedPlans!,
                        Colors.green,
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPlanSection(
    String title,
    IconData icon,
    List<dynamic> plans,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...plans.map((plan) => _buildPlanItem(plan, color)).toList(),
      ],
    );
  }
  
  Widget _buildPlanItem(dynamic plan, Color color) {
    final planType = plan.planType ?? 'Unknown Plan';
    final planPrice = plan.planPrice ?? '0.00';
    final startDate = plan.startDate ?? '';
    final expiredDate = plan.expiredDate ?? '';
    
    // Check if plan is expired
    final isExpired = expiredDate.isNotEmpty && 
        DateTime.tryParse(expiredDate)?.isBefore(DateTime.now()) == true;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isExpired ? Colors.grey[50] : color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isExpired ? Colors.grey[300]! : color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isExpired ? Colors.grey[300] : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              isExpired ? Icons.schedule : Icons.check_circle,
              color: isExpired ? Colors.grey[600] : color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planType.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isExpired ? Colors.grey[600] : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹$planPrice',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isExpired ? Colors.grey[500] : color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${startDate.isNotEmpty ? 'From: $startDate' : ''} ${expiredDate.isNotEmpty ? 'To: $expiredDate' : ''}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isExpired ? Colors.red[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isExpired)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Text(
                'EXPIRED',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[600],
                ),
              ),
            ),
        ],
      ),
    );
  }
} 