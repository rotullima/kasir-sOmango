import 'package:kasir_s0mango/models/cashier_cust.dart';

final List<Map<String, dynamic>> dummyCustomers = [
  {
    "customer": CashierCustModel(
      id: "c1",
      name: "Umum / Walk-in",
      email: "-",
      points: 0,
    ),
    "lastTransaction": 0,
    "totalSpent": 0,
  },
  {
    "customer": CashierCustModel(
      id: "c2",
      name: "Taery Pratama",
      email: "taery@mail.com",
      points: 1200,
    ),
    "lastTransaction": 68000,
    "totalSpent": 375000,
  },
  {
    "customer": CashierCustModel(
      id: "c3",
      name: "She Nurhaliza",
      email: "she@mail.com",
      points: 3000,
    ),
    "lastTransaction": 77000,
    "totalSpent": 145000,
  },
  {
    "customer": CashierCustModel(
      id: "c4",
      name: "Diti Santoso",
      email: "diti@mail.com",
      points: 700,
    ),
    "lastTransaction": 32000,
    "totalSpent": 68000,
  },
  {
    "customer": CashierCustModel(
      id: "c5",
      name: "Rya Wijaya",
      email: "rya@mail.com",
      points: 9500,
    ),
    "lastTransaction": 120000,
    "totalSpent": 890000,
  },
];
