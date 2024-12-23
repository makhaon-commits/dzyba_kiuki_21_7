import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';

class StudentsScreen extends StatelessWidget {
  StudentsScreen({super.key});

  final List<Student> _students = [
    Student(
      firstName: 'Андрій',
      lastName: 'Іванов',
      department: Department.it,
      grade: 90,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Марія',
      lastName: 'Петренко',
      department: Department.medical,
      grade: 85,
      gender: Gender.female,
    ),
    Student(
      firstName: 'Олег',
      lastName: 'Сидоренко',
      department: Department.law,
      grade: 70,
      gender: Gender.male,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Студенти',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo.shade400,
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (ctx, index) {
          return StudentItem(student: _students[index]);
        },
      ),
    );
  }
}
