import 'package:flutter/material.dart';
import 'package:ln_flower/data/record_repository.dart';
import 'package:ln_flower/data/records.dart';

class ShippingCompaniesView extends StatefulWidget {
  const ShippingCompaniesView({super.key});

  @override
  State<ShippingCompaniesView> createState() => _ShippingCompaniesViewState();
}

class _ShippingCompaniesViewState extends State<ShippingCompaniesView> {
  static const _repo = RecordRepository();
  int _refreshKey = 0;

  @override
  void initState() {
    super.initState();
    // Initialize default companies if none exist
    _repo.initializeDefaultShippingCompanies();
  }

  void _refreshData() {
    setState(() => _refreshKey++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ບໍລິສັດຂົນສົ່ງ')),
      body: Builder(
        builder: (context) {
          final companies = _repo.getShippingCompanies();

          if (companies.isEmpty) {
            return const Center(
              child: Text('ຍັງບໍ່ມີບໍລິສັດຂົນສົ່ງ'),
            );
          }

          return ListView.builder(
            itemCount: companies.length,
            itemBuilder: (context, index) {
              final company = companies[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.local_shipping_outlined),
                  title: Text(company.displayName),
                  subtitle: Text('${company.branches.length} ສາຂາ'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, company),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('ແກ້ໄຂ'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('ລຶບ'),
                      ),
                    ],
                  ),
                  onTap: () => _showCompanyDetails(company),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCompany,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleMenuAction(String action, ShippingCompany company) {
    switch (action) {
      case 'edit':
        _editCompany(company);
        break;
      case 'delete':
        _deleteCompany(company);
        break;
    }
  }

  void _showCompanyDetails(ShippingCompany company) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(company.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ຊື່ເຕັມ: ${company.name}'),
            const SizedBox(height: 8),
            const Text('ສາຂາ:'),
            ...company.branches.map((branch) => Text('• $branch')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ປິດ'),
          ),
        ],
      ),
    );
  }

  Future<void> _addCompany() async {
    final result = await showDialog<ShippingCompany>(
      context: context,
      builder: (context) => const _CompanyDialog(),
    );

    if (result != null && mounted) {
      await _repo.addShippingCompany(result);
      _refreshData();
    }
  }

  Future<void> _editCompany(ShippingCompany company) async {
    final result = await showDialog<ShippingCompany>(
      context: context,
      builder: (context) => _CompanyDialog(company: company),
    );

    if (result != null && mounted) {
      await _repo.updateShippingCompany(result);
      _refreshData();
    }
  }

  Future<void> _deleteCompany(ShippingCompany company) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ຢືນຢັນການລຶບ'),
        content: Text('ທ່ານຕ້ອງການລຶບ ${company.displayName} ຫຼືບໍ່?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ຍົກເລີກ'),
          ),
          TextButton(
            onPressed: () async {
              await _repo.deleteShippingCompany(company.id);
              if (mounted) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('ລຶບ'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _refreshData();
    }
  }
}

class _CompanyDialog extends StatefulWidget {
  const _CompanyDialog({this.company});

  final ShippingCompany? company;

  @override
  State<_CompanyDialog> createState() => _CompanyDialogState();
}

class _CompanyDialogState extends State<_CompanyDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _displayNameController;
  late final TextEditingController _branchesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.company?.name ?? '');
    _displayNameController =
        TextEditingController(text: widget.company?.displayName ?? '');
    _branchesController =
        TextEditingController(text: widget.company?.branches.join(', ') ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _branchesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.company != null;

    return AlertDialog(
      title: Text(isEditing ? 'ແກ້ໄຂບໍລິສັດ' : 'ເພີ່ມບໍລິສັດ'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'ຊື່ບໍລິສັດ (ອັງກິດ)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _displayNameController,
            decoration: const InputDecoration(
              labelText: 'ຊື່ບໍລິສັດ (ລາວ)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _branchesController,
            decoration: const InputDecoration(
              labelText: 'ສາຂາ (ຄັ່ນໄປດ້ວຍຈຸດ)',
              border: OutlineInputBorder(),
              hintText: 'ສາຂາຫຼັກ, ວຽງຈັນ, ຫຼວງພະບາງ',
            ),
            minLines: 2,
            maxLines: 4,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ຍົກເລີກ'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(isEditing ? 'ແກ້ໄຂ' : 'ເພີ່ມ'),
        ),
      ],
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    final displayName = _displayNameController.text.trim();
    final branchesText = _branchesController.text.trim();

    if (name.isEmpty || displayName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ກະລຸນາໃສ່ຊື່ບໍລິສັດ')),
      );
      return;
    }

    final branches = branchesText.isEmpty
        ? ['ສາຂາຫຼັກ']
        : branchesText
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    final company = ShippingCompany(
      id: widget.company?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      displayName: displayName,
      branches: branches,
      createdAt: widget.company?.createdAt ?? DateTime.now(),
    );

    Navigator.of(context).pop(company);
  }
}
