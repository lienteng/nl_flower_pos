import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ln_flower/data/record_repository.dart';
import 'package:ln_flower/data/records.dart';
import 'package:ln_flower/features/waybill/waybill_history_view.dart';
import 'package:ln_flower/printing/sunmi_receipt_printer.dart';
import 'package:ln_flower/widgets/custom_dialog.dart';
import 'package:uuid/uuid.dart';

class WaybillView extends StatefulWidget {
  const WaybillView({super.key});

  @override
  State<WaybillView> createState() => _WaybillViewState();
}

class _WaybillViewState extends State<WaybillView> {
  static const _repo = RecordRepository();
  final _customerNameController = TextEditingController(text: 'ລູກຄ້າ');
  final _customerPhoneController = TextEditingController();
  final _parcelController = TextEditingController();
  final feeController = TextEditingController();
  final _branchController = TextEditingController();
  String _shippingCompany = '';

  // Number formatter for thousand separators
  final _numberFormatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    // Initialize default companies if none exist
    _repo.initializeDefaultShippingCompanies();
  }

  // Custom TextInputFormatter for number formatting
  TextInputFormatter get _numberInputFormatter =>
      TextInputFormatter.withFunction(
        (oldValue, newValue) {
          // Allow empty input
          if (newValue.text.isEmpty) {
            return newValue;
          }

          // Parse the input as double
          final parsed = double.tryParse(newValue.text.replaceAll(',', ''));
          if (parsed == null) {
            // If parsing fails, keep the old value
            return oldValue;
          }

          // Format the number
          final formatted = _numberFormatter.format(parsed);

          return TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        },
      );

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _parcelController.dispose();
    feeController.dispose();
    _branchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget cleanTextField({
      required TextEditingController controller,
      required String label,
      required IconData icon,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      String? prefixText,
      String? hintText,
    }) {
      return TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixText: prefixText,
          prefixIcon: Icon(icon, color: theme.colorScheme.primary, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
      );
    }

    Widget cleanDropdown({
      required String label,
      required IconData icon,
      required String? value,
      required String hint,
      required List<DropdownMenuItem<String>> items,
      required ValueChanged<String?> onChanged,
    }) {
      return DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint, style: theme.textTheme.bodyMedium),
        items: items,
        onChanged: onChanged,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: theme.colorScheme.primary, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
        dropdownColor: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
      );
    }

    Widget sectionHeader(String title, IconData icon, Color color) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      );
    }

    Widget cleanPrintButton() {
      return Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: _onPrint,
          icon: const Icon(Icons.print, color: Colors.white, size: 20),
          label: const Text(
            'ພິມໃບບິນ',
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
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        title: Text(
          'ໃບຮັບ/ໃບສົ່ງສິນຄ້າ',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/img/logo.png',
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.store, size: 32);
            },
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            decoration: BoxDecoration(
                // color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WaybillHistoryView(),
                  ),
                );
              },
              icon: const Icon(
                Icons.history,
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Information Section
              sectionHeader(
                  'ຂໍ້ມູນລູກຄ້າ', Icons.person, theme.colorScheme.primary),
              const SizedBox(height: 16),

              cleanTextField(
                controller: _customerNameController,
                label: 'ຊື່ລູກຄ້າ',
                icon: Icons.person_outline,
                hintText: 'ປ້ອນຊື່ລູກຄ້າ',
              ),
              const SizedBox(height: 16),

              cleanTextField(
                controller: _customerPhoneController,
                label: 'ເບີໂທລູກຄ້າ',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                hintText: '020-XXXX-XXXX',
              ),

              const SizedBox(height: 32),

              // Shipping Information Section
              sectionHeader(
                  'ຂໍ້ມູນການຂົນສົ່ງ', Icons.local_shipping, Colors.green),
              const SizedBox(height: 16),

              Builder(
                builder: (context) {
                  final companies = _repo.getShippingCompanies();
                  return cleanDropdown(
                    label: 'ບໍລິສັດຂົນສົ່ງ',
                    icon: Icons.business,
                    value: _shippingCompany.isEmpty ? null : _shippingCompany,
                    hint: 'ເລືອກບໍລິສັດຂົນສົ່ງ',
                    items: companies
                        .map((company) => DropdownMenuItem(
                              value: company.name,
                              child: Text(company.displayName),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _shippingCompany = value!;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              cleanTextField(
                controller: _branchController,
                label: 'ສາຂາປາຍທາງ',
                icon: Icons.location_on,
                hintText: 'ປ້ອນຊື່ສາຂາ',
              ),

              const SizedBox(height: 32),

              // Payment Information Section
              sectionHeader('ຂໍ້ມູນການຊຳລະເງິນ', Icons.payments, Colors.blue),
              const SizedBox(height: 16),

              cleanTextField(
                controller: feeController,
                label: 'ຄ່າບໍລິການ (COD)',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                inputFormatters: [_numberInputFormatter],
                prefixText: '₭ ',
                hintText: '0',
              ),

              const SizedBox(height: 40),

              // Print Button
              cleanPrintButton(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onPrint() async {
    final customerName = _customerNameController.text.trim();
    final customerPhone = _customerPhoneController.text.trim();

    if (customerName.isEmpty || customerPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ກະລຸນາໃສ່ຂໍ້ມູນລູກຄ້າໃຫ້ຄົບ')),
      );
      return;
    }

    // Get the actual shipping company name from dropdown selection
    final actualShippingCompany = _shippingCompany;
    if (actualShippingCompany.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ກະລຸນາເລືອກບໍລິສັດຂົນສົ່ງ')),
      );
      return;
    }

    // Get branch name from controller
    final branchName = _branchController.text.trim();
    if (branchName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ກະລຸນາໃສ່ຊື່ສາຂາ')),
      );
      return;
    }

    // TODO: connect to Hive shop profile later.
    const shopName = 'ຈິທໍ່';
    const shopPhone = '020-5914-6995';

    // Parse fee value and format with thousand separators
    final feeValue =
        double.tryParse(feeController.text.replaceAll(',', '')) ?? 0.0;
    final laoNumberFormatter = NumberFormat('#,###');
    final formattedFee = laoNumberFormatter.format(feeValue);
    final printer = SunmiReceiptPrinter();
    try {
      await printer.printWaybillReceipt(
        data: SunmiReceiptData(
            shopName: shopName,
            shopPhone: shopPhone,
            customerName: customerName,
            customerPhone: customerPhone,
            expressCompany: actualShippingCompany,
            expressBranch: branchName,
            feeController: formattedFee),
      );

      // Save to Hive after successful printing
      final waybillRecord = WaybillRecord(
        id: const Uuid().v4(),
        createdAt: DateTime.now(),
        customerName: customerName,
        customerPhone: customerPhone,
        shippingCompany: actualShippingCompany,
        branch: branchName,
        cod: feeValue,
      );
      await _repo.addWaybill(waybillRecord);

      if (!mounted) return;
      await CustomDialog.show(
        context: context,
        type: DialogType.success,
        title: 'ສຳເລັດ',
        message: 'ສັ່ງພິມໃບຮັບສຳເລັດແລ້ວ',
      );

      // Clear all form fields for next customer
      _customerNameController.clear();
      _customerPhoneController.clear();
      _branchController.clear();
      feeController.clear();
      setState(() {
        _shippingCompany = '';
      });
    } on UnsupportedError catch (e) {
      if (!mounted) return;
      await CustomDialog.show(
        context: context,
        type: DialogType.warning,
        title: 'ບໍ່ສາມາດພິມໄດ້',
        message: e.message ?? 'ອຸປະກອນບໍ່ຮອງຮັບການພິມ',
      );
    } catch (e) {
      if (!mounted) return;
      await CustomDialog.show(
        context: context,
        type: DialogType.error,
        title: 'ເກີດຄວາມຜິດພາດ',
        message: 'ພິມບໍ່ສຳເລັດ: $e',
      );
    }
  }
}
