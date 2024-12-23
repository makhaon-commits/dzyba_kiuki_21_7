import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';
import 'new_student.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final List<Student> students = [
    Student(
      id: '1',
      firstName: 'Андрій',
      lastName: 'Іванов',
      department: Department.it,
      grade: 90,
      gender: Gender.male,
    ),
    Student(
      id: '2',
      firstName: 'Марія',
      lastName: 'Петренко',
      department: Department.medical,
      grade: 85,
      gender: Gender.female,
    ),
    Student(
      id: '3',
      firstName: 'Олег',
      lastName: 'Сидоренко',
      department: Department.law,
      grade: 70,
      gender: Gender.male,
    ),
  ];

  void _showNewStudentForm({Student? student}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NewStudent(
          existingStudent: student,
          onSave: (updatedStudent) {
            setState(() {
              if (student != null) {
                final index = students.indexWhere((s) => s.id == student.id);
                students[index] = updatedStudent;
              } else {
                students.add(updatedStudent);
              }
            });
          },
        );
      },
    );
  }

  void _deleteStudent(int index) {
    final removedStudent = students[index];
    setState(() => students.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedStudent.firstName} успішно видалено.'),
        action: SnackBarAction(
          label: 'Скасувати',
          onPressed: () => setState(() => students.insert(index, removedStudent)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Студенти'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (ctx, index) {
          final student = students[index];
          return Dismissible(
            key: ValueKey(student.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: student.gender == Gender.male
                    ? Colors.lightBlue.shade200
                    : Colors.pink.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                student.gender == Gender.male
                    ? 'Прощавай, студент!'
                    : 'Запис вилучено!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: student.gender == Gender.male
                      ? Colors.blue.shade800
                      : Colors.pink.shade800,
                ),
              ),
            ),
            onDismissed: (_) => _deleteStudent(index),
            child: InkWell(
              onTap: () => _showNewStudentForm(student: student),
              child: StudentItem(student: student),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewStudentForm(),
        label: const Text('Додати'),
        icon: const Icon(Icons.person_add_alt_1),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
