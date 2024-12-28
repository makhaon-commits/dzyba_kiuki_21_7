import 'package:flutter/material.dart';

class Department {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  Department({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}

final departments = [
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
