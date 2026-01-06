import 'package:flutter/material.dart';
import 'package:ln_flower/features/settings/customers_view.dart';
import 'package:ln_flower/features/settings/expense_categories_view.dart';
import 'package:ln_flower/features/settings/shop_profile_view.dart';
import 'package:ln_flower/features/settings/shipping_companies_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget modernSettingTile({
      required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
      required Color color,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),

              // Settings Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primaryContainer,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        color: theme.colorScheme.onPrimary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ການຕັ້ງຄ່າລະບົບ',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ຈັດການຂໍ້ມູນຕ່າງໆໃນລະບົບ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Settings Options
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      modernSettingTile(
                        icon: Icons.store_outlined,
                        title: 'ຂໍ້ມູນຮ້ານ',
                        subtitle: 'ໂລໂກ້, ຂໍ້ມູນຮ້ານ, ຂໍ້ຄວາມທ້າຍບິນ',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const ShopProfileView()),
                        ),
                        color: Colors.blue,
                      ),
                      modernSettingTile(
                        icon: Icons.people_outline,
                        title: 'ຈັດການລູກຄ້າ',
                        subtitle: 'ເພີ່ມ, ແກ້ໄຂ, ລຶບຂໍ້ມູນລູກຄ້າ',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const CustomersView()),
                        ),
                        color: Colors.green,
                      ),
                      modernSettingTile(
                        icon: Icons.local_shipping_outlined,
                        title: 'ບໍລິສັດຂົນສົ່ງ',
                        subtitle: 'ຈັດການບໍລິສັດຂົນສົ່ງແລະສາຂາ',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const ShippingCompaniesView()),
                        ),
                        color: Colors.orange,
                      ),
                      modernSettingTile(
                        icon: Icons.payment_outlined,
                        title: 'ໝວດໝູ່ລາຍຈ່າຍ',
                        subtitle: 'ຈັດການໝວດໝູ່ລາຍຈ່າຍ',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const ExpenseCategoriesView()),
                        ),
                        color: Colors.purple,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
