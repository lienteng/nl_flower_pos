import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ln_flower/data/record_repository.dart';
import 'package:ln_flower/data/records.dart';
import 'package:ln_flower/widgets/custom_dialog.dart';

class IncomeView extends StatefulWidget {
  const IncomeView({super.key});

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  PaymentChannel _channel = PaymentChannel.cash;
  final _repo = const RecordRepository();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(
      locale: 'lo_LA',
      symbol: '₭',
      decimalDigits: 0,
    );

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modern App Bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                  child: Row(
                    children: [
                      Text(
                        'ຮັບເງິນ',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Header
                Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.blue.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.add_circle,
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
                              'ບັນທຶກລາຍຮັບ',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(DateTime.now()),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Amount Field
                Text(
                  'ຈຳນວນເງິນ',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.3)),
                  ),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      prefixText: '₭ ',
                      prefixStyle: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                      hintText: '0',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // Format with thousand separators
                      if (value.isNotEmpty) {
                        final cleanValue = value.replaceAll(',', '');
                        final parsed = double.tryParse(cleanValue);
                        if (parsed != null) {
                          final formatted = currency
                              .format(parsed)
                              .replaceAll('₭', '')
                              .trim();
                          if (formatted != value) {
                            _amountController.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(
                                  offset: formatted.length),
                            );
                          }
                        }
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Payment Channel Field
                Text(
                  'ຊ່ອງທາງຊຳລະ',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.3)),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _labelForChannel(_channel),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    dropdownColor: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    items: const [
                      DropdownMenuItem(
                        value: 'ເງິນສົດ',
                        child: Row(
                          children: [
                            Icon(Icons.money, size: 20, color: Colors.green),
                            SizedBox(width: 8),
                            Text('ເງິນສົດ'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'ໂອນ',
                        child: Row(
                          children: [
                            Icon(Icons.account_balance,
                                size: 20, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('ໂອນ'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _channel = _channelFromLabel(value));
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Note Field
                Text(
                  'ໝາຍເຫດ',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.3)),
                  ),
                  child: TextField(
                    controller: _noteController,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ເພີ່ມໝາຍເຫດ (ທາງເລືອກ)',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    minLines: 3,
                    maxLines: 5,
                  ),
                ),

                const SizedBox(height: 32),

                // Save Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blue.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _onSave,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'ບັນທຶກລາຍຮັບ',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      if (!mounted) return;
      await CustomDialog.show(
        context: context,
        type: DialogType.warning,
        title: 'ຂໍ້ມູນບໍ່ຖືກຕ້ອງ',
        message: 'ກະລຸນາໃສ່ຈຳນວນເງິນໃຫ້ຖືກຕ້ອງ',
      );
      return;
    }

    final now = DateTime.now();
    final record = IncomeRecord(
      id: now.microsecondsSinceEpoch.toString(),
      createdAt: now,
      amount: amount,
      channel: _channel,
      note: _noteController.text.trim(),
    );

    await _repo.addIncome(record);

    _amountController.clear();
    _noteController.clear();
    if (!mounted) return;
    await CustomDialog.show(
      context: context,
      type: DialogType.success,
      title: 'ສຳເລັດ',
      message: 'ບັນທຶກລາຍຮັບສຳເລັດແລ້ວ',
    );
  }

  static String _labelForChannel(PaymentChannel channel) {
    switch (channel) {
      case PaymentChannel.cash:
        return 'ເງິນສົດ';
      case PaymentChannel.transfer:
        return 'ໂອນ';
      case PaymentChannel.qr:
        return 'QR';
    }
  }

  static PaymentChannel _channelFromLabel(String label) {
    switch (label) {
      case 'ເງິນສົດ':
        return PaymentChannel.cash;
      case 'ໂອນ':
        return PaymentChannel.transfer;
      case 'QR':
        return PaymentChannel.qr;
      default:
        return PaymentChannel.cash;
    }
  }
}
