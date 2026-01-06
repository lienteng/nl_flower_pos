import 'package:flutter/material.dart';
import 'package:ln_flower/features/dashboard/dashboard_view.dart';
import 'package:ln_flower/features/expense/expense_view.dart';
import 'package:ln_flower/features/income/income_view.dart';
import 'package:ln_flower/features/settings/settings_view.dart';
import 'package:ln_flower/features/waybill/waybill_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _index = 3;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardView(
        onQuickIncome: () => setState(() => _index = 1),
        onQuickExpense: () => setState(() => _index = 2),
        onQuickWaybill: () => setState(() => _index = 3),
      ),
      const IncomeView(),
      const ExpenseView(),
      const WaybillView(),
      const SettingsView(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'ໜ້າຫຼັກ',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'ຮັບເງິນ',
          ),
          NavigationDestination(
            icon: Icon(Icons.remove_circle_outline),
            label: 'ຈ່າຍເງິນ',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'ໃບສົ່ງຂອງ',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'ຕັ້ງຄ່າ',
          ),
        ],
      ),
    );
  }
}
