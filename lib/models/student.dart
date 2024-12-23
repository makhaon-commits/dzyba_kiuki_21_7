import 'package:flutter/material.dart';

enum Department { finance, law, it, medical }
enum Gender { male, female }

const Map<Department, IconData> departmentIcons = {
  Department.finance: Icons.monetization_on,
  Department.law: Icons.business,
  Department.it: Icons.memory,
  Department.medical: Icons.local_pharmacy,
};

class Student {
  final String id;
  final String firstName;
  final String lastName;
  final Department department;
  final int grade;
  final Gender gender;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.grade,
    required this.gender,
  });
}
