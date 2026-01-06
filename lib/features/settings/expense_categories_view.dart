import 'package:flutter/material.dart';
import 'package:ln_flower/data/record_repository.dart';
import 'package:ln_flower/data/records.dart';
import 'package:ln_flower/widgets/custom_dialog.dart';

class ExpenseCategoriesView extends StatefulWidget {
  const ExpenseCategoriesView({super.key});

  @override
  State<ExpenseCategoriesView> createState() => _ExpenseCategoriesViewState();
}

class _ExpenseCategoriesViewState extends State<ExpenseCategoriesView> {
  static const _repo = RecordRepository();
  int _refreshKey = 0;

  @override
  void initState() {
    super.initState();
    // Initialize default categories if none exist
    _repo.initializeDefaultExpenseCategories();
  }

  void _refreshData() {
    setState(() => _refreshKey++);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              // Modern App Bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.9),
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'ໝວດໝູ່ລາຍຈ່າຍ',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Builder(
                  builder: (context) {
                    final categories = _repo.getExpenseCategories();

                    if (categories.isEmpty) {
                      return const Center(
                        child: Text('ຍັງບໍ່ມີໝວດໝູ່ລາຍຈ່າຍ'),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    theme.colorScheme.shadow.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.primaryContainer
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _getIconFromName(category.iconName),
                                color: theme.colorScheme.onPrimary,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              category.displayName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              category.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) =>
                                  _handleMenuAction(value, category),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_outlined, size: 18),
                                      SizedBox(width: 8),
                                      Text('ແກ້ໄຂ'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline,
                                          size: 18, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('ລຶບ',
                                          style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Add Button
              Container(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.8)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _addCategory,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'ເພີ່ມໝວດໝູ່',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(String action, ExpenseCategory category) {
    switch (action) {
      case 'edit':
        _editCategory(category);
        break;
      case 'delete':
        _deleteCategory(category);
        break;
    }
  }

  Future<void> _addCategory() async {
    final result = await showDialog<ExpenseCategory>(
      context: context,
      builder: (context) => const _CategoryDialog(),
    );

    if (result != null && mounted) {
      await _repo.addExpenseCategory(result);
      _refreshData();
    }
  }

  Future<void> _editCategory(ExpenseCategory category) async {
    final result = await showDialog<ExpenseCategory>(
      context: context,
      builder: (context) => _CategoryDialog(category: category),
    );

    if (result != null && mounted) {
      await _repo.updateExpenseCategory(result);
      _refreshData();
    }
  }

  Future<void> _deleteCategory(ExpenseCategory category) async {
    final confirmed = await CustomDialog.showConfirmation(
      context: context,
      type: DialogType.warning,
      title: 'ຢືນຢັນການລຶບ',
      message: 'ທ່ານຕ້ອງການລຶບໝວດໝູ່ "${category.displayName}" ຫຼືບໍ່?',
      confirmText: 'ລຶບ',
      cancelText: 'ຍົກເລີກ',
    );

    if (confirmed && mounted) {
      await _repo.deleteExpenseCategory(category.id);
      _refreshData();
    }
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'directions_car':
        return Icons.directions_car;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'school':
        return Icons.school;
      case 'medical_services':
        return Icons.medical_services;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'movie':
        return Icons.movie;
      case 'flight':
        return Icons.flight;
      case 'hotel':
        return Icons.hotel;
      default:
        return Icons.category;
    }
  }
}

class _CategoryDialog extends StatefulWidget {
  const _CategoryDialog({this.category});

  final ExpenseCategory? category;

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _displayNameController;
  late String _selectedIcon;

  final List<Map<String, String>> _availableIcons = [
    {'name': 'category', 'icon': 'category'},
    {'name': 'directions_car', 'icon': 'directions_car'},
    {'name': 'local_gas_station', 'icon': 'local_gas_station'},
    {'name': 'restaurant', 'icon': 'restaurant'},
    {'name': 'shopping_cart', 'icon': 'shopping_cart'},
    {'name': 'home', 'icon': 'home'},
    {'name': 'work', 'icon': 'work'},
    {'name': 'school', 'icon': 'school'},
    {'name': 'medical_services', 'icon': 'medical_services'},
    {'name': 'sports_soccer', 'icon': 'sports_soccer'},
    {'name': 'movie', 'icon': 'movie'},
    {'name': 'flight', 'icon': 'flight'},
    {'name': 'hotel', 'icon': 'hotel'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _displayNameController =
        TextEditingController(text: widget.category?.displayName ?? '');
    _selectedIcon = widget.category?.iconName ?? 'category';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(isEditing ? 'ແກ້ໄຂໝວດໝູ່' : 'ເພີ່ມໝວດໝູ່'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'ຊື່ລະບົບ (ອັງກິດ)',
                hintText: 'general, car, food, etc.',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: 'ຊື່ສະແດງ (ລາວ)',
                hintText: 'ທົ່ວໄປ, ຄ່າລົດ, ຄ່າອາຫານ, ແລະອື່ນໆ',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedIcon,
              decoration: const InputDecoration(
                labelText: 'ໄອຄອນ',
              ),
              items: _availableIcons.map((icon) {
                return DropdownMenuItem<String>(
                  value: icon['name'],
                  child: Row(
                    children: [
                      Icon(_getIconFromName(icon['icon']!)),
                      const SizedBox(width: 8),
                      Text(icon['name']!),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedIcon = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ຍົກເລີກ'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(isEditing ? 'ບັນທຶກ' : 'ເພີ່ມ'),
        ),
      ],
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    final displayName = _displayNameController.text.trim();

    if (name.isEmpty || displayName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ກະລຸນາໃສ່ຂໍ້ມູນໃຫ້ຄົບຖ້ວນ')),
      );
      return;
    }

    final category = ExpenseCategory(
      id: widget.category?.id ?? name.toLowerCase().replaceAll(' ', '_'),
      name: name,
      displayName: displayName,
      iconName: _selectedIcon,
      createdAt: widget.category?.createdAt ?? DateTime.now(),
    );

    Navigator.of(context).pop(category);
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'directions_car':
        return Icons.directions_car;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'school':
        return Icons.school;
      case 'medical_services':
        return Icons.medical_services;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'movie':
        return Icons.movie;
      case 'flight':
        return Icons.flight;
      case 'hotel':
        return Icons.hotel;
      default:
        return Icons.category;
    }
  }
}
