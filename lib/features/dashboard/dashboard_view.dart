import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ln_flower/data/record_repository.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
    required this.onQuickIncome,
    required this.onQuickExpense,
    required this.onQuickWaybill,
  });

  final VoidCallback onQuickIncome;
  final VoidCallback onQuickExpense;
  final VoidCallback onQuickWaybill;
  static const _repo = RecordRepository();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(
      locale: 'lo_LA',
      symbol: '₭',
      decimalDigits: 0,
    );

    Widget summaryCard({
      required String title,
      required String value,
      required IconData icon,
      required Color color,
      required Color iconColor,
    }) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget modernActionButton({
      required String label,
      required IconData icon,
      required VoidCallback onPressed,
      required Color backgroundColor,
      required Color foregroundColor,
    }) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: foregroundColor),
          label: Text(label, style: TextStyle(color: foregroundColor)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }

    Widget totals() {
      final income = _repo.totalIncome();
      final expense = _repo.totalExpense();
      final profit = income - expense;

      String money(double v) => currency.format(v);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ສະຫຼຸບການເງິນ',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: summaryCard(
                  title: 'ຮັບເງິນ',
                  value: money(income),
                  icon: Icons.trending_up,
                  color: Colors.green,
                  iconColor: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: summaryCard(
                  title: 'ຈ່າຍເງິນ',
                  value: money(expense),
                  icon: Icons.trending_down,
                  color: Colors.red,
                  iconColor: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          summaryCard(
            title: 'ກຳໄລ',
            value: money(profit),
            icon: profit >= 0 ? Icons.account_balance_wallet : Icons.warning,
            color: profit >= 0 ? Colors.blue : Colors.orange,
            iconColor: profit >= 0 ? Colors.blue : Colors.orange,
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.primaryContainer,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/img/logo.png',
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.store, color: theme.colorScheme.primary);
              },
            ),
          ),
        ),
        title: Text(
          'ໜ້າຫຼັກ',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            totals(),
            const SizedBox(height: 32),
            Text(
              'ປຸ່ມດ່ວນ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                modernActionButton(
                  label: 'ຮັບເງິນ',
                  icon: Icons.add_circle,
                  onPressed: onQuickIncome,
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                modernActionButton(
                  label: 'ຈ່າຍເງິນ',
                  icon: Icons.remove_circle,
                  onPressed: onQuickExpense,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                modernActionButton(
                  label: 'ອອກໃບສົ່ງຂອງ',
                  icon: Icons.receipt_long,
                  onPressed: onQuickWaybill,
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(20),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.insights,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                ),
                title: Text(
                  'ລາຍງານຂັ້ນຕອນໄປ',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'ກາຟແລະລາຍງານລະອຽດຈະເພີ່ມໃນລາຍຫຼັງ',
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: theme.colorScheme.primary,
                    size: 16,
                  ),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
