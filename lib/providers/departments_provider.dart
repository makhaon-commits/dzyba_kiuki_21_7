import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/department.dart';

final departmentsProvider = Provider<List<Department>>((ref) {
  return [
    Department(
      id: '1',
      name: 'Finance',
      color: Colors.purple,
      icon: Icons.monetization_on,
    ),
    Department(
      id: '2',
      name: 'Law',
      color: Colors.orange,
      icon: Icons.gavel,
    ),
    Department(
      id: '3',
      name: 'IT',
      color: Colors.indigo,
      icon: Icons.memory,
    ),
    Department(
      id: '4',
      name: 'Medical',
      color: Colors.teal,
      icon: Icons.local_pharmacy,
    ),
  ];
});
