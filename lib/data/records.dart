enum PaymentChannel { cash, transfer, qr }

class ExpenseCategory {
  ExpenseCategory({
    required this.id,
    required this.name,
    required this.displayName,
    required this.iconName,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String displayName;
  final String iconName;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'displayName': displayName,
        'iconName': iconName,
        'createdAt': createdAt.toIso8601String(),
      };

  static ExpenseCategory fromMap(Map map) => ExpenseCategory(
        id: map['id'] as String,
        name: map['name'] as String,
        displayName: map['displayName'] as String,
        iconName: (map['iconName'] as String?) ?? 'category',
        createdAt: DateTime.parse(map['createdAt'] as String),
      );

  // Get a list of default expense categories for initial setup
  static List<ExpenseCategory> getDefaultCategories() {
    return [
      ExpenseCategory(
        id: 'general',
        name: 'general',
        displayName: 'ທົ່ວໄປ',
        iconName: 'category',
        createdAt: DateTime.now(),
      ),
      ExpenseCategory(
        id: 'car',
        name: 'car',
        displayName: 'ຄ່າລົດ',
        iconName: 'directions_car',
        createdAt: DateTime.now(),
      ),
      ExpenseCategory(
        id: 'fuel',
        name: 'fuel',
        displayName: 'ຄ່ານ້ຳມັນ',
        iconName: 'local_gas_station',
        createdAt: DateTime.now(),
      ),
    ];
  }
}

class IncomeRecord {
  IncomeRecord({
    required this.id,
    required this.createdAt,
    required this.amount,
    required this.channel,
    required this.note,
  });

  final String id;
  final DateTime createdAt;
  final double amount;
  final PaymentChannel channel;
  final String note;

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'amount': amount,
        'channel': channel.name,
        'note': note,
      };

  static IncomeRecord fromMap(Map map) => IncomeRecord(
        id: map['id'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        amount: (map['amount'] as num).toDouble(),
        channel: PaymentChannel.values
            .firstWhere((e) => e.name == (map['channel'] as String)),
        note: (map['note'] as String?) ?? '',
      );
}

class ExpenseRecord {
  ExpenseRecord({
    required this.id,
    required this.createdAt,
    required this.amount,
    required this.categoryId,
    required this.note,
  });

  final String id;
  final DateTime createdAt;
  final double amount;
  final String categoryId;
  final String note;

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'amount': amount,
        'categoryId': categoryId,
        'note': note,
      };

  static ExpenseRecord fromMap(Map map) => ExpenseRecord(
        id: map['id'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        amount: (map['amount'] as num).toDouble(),
        categoryId: (map['categoryId'] as String?) ?? 'general',
        note: (map['note'] as String?) ?? '',
      );
}

class ShippingCompany {
  ShippingCompany({
    required this.id,
    required this.name,
    required this.displayName,
    required this.branches,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String displayName;
  final List<String> branches;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'displayName': displayName,
        'branches': branches,
        'createdAt': createdAt.toIso8601String(),
      };

  static ShippingCompany fromMap(Map map) => ShippingCompany(
        id: map['id'] as String,
        name: map['name'] as String,
        displayName: map['displayName'] as String,
        branches: (map['branches'] as List<dynamic>?)?.cast<String>() ?? [],
        createdAt: DateTime.parse(map['createdAt'] as String),
      );

  // Get a list of default shipping companies for initial setup
  static List<ShippingCompany> getDefaultCompanies() {
    return [
      ShippingCompany(
        id: 'anousith',
        name: 'Anousith Express',
        displayName: 'ອານຸສິດ ຂົນສົ່ງ',
        branches: ['ສາຂາຫຼັກ', 'ວຽງຈັນ', 'ຫຼວງພະບາງ', 'ຈຳປາສັກ'],
        createdAt: DateTime.now(),
      ),
      ShippingCompany(
        id: 'hal',
        name: 'HAL logistics',
        displayName: 'ຮຸ່ງອາລຸນ',
        branches: ['ສາຂາຫຼັກ', 'ວຽງຈັນ', 'ສະຫວັນນະເຂດ'],
        createdAt: DateTime.now(),
      ),
      ShippingCompany(
        id: 'mixay',
        name: 'Mixay Express',
        displayName: 'ມີໄຊ',
        branches: ['ສາຂາຫຼັກ', 'ວຽງຈັນ', 'ອຸດົມໄຊ', 'ຫຼວງນ້ຳທາ'],
        createdAt: DateTime.now(),
      ),
      ShippingCompany(
        id: 'unitel',
        name: 'Unitel logistics',
        displayName: 'Unitel',
        branches: ['ສາຂາຫຼັກ'],
        createdAt: DateTime.now(),
      ),
    ];
  }
}

class WaybillRecord {
  WaybillRecord({
    required this.id,
    required this.createdAt,
    required this.customerName,
    required this.customerPhone,
    required this.shippingCompany,
    required this.branch,
    required this.cod,
  });

  final String id;
  final DateTime createdAt;
  final String customerName;
  final String customerPhone;
  final String shippingCompany;
  final String branch;
  final double cod;

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'customerName': customerName,
        'customerPhone': customerPhone,
        'shippingCompany': shippingCompany,
        'branch': branch,
        'cod': cod,
      };

  static WaybillRecord fromMap(Map map) => WaybillRecord(
        id: map['id'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        customerName: map['customerName'] as String,
        customerPhone: map['customerPhone'] as String,
        shippingCompany: map['shippingCompany'] as String,
        branch: map['branch'] as String,
        cod: (map['cod'] as num).toDouble(),
      );
}
