import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../providers/students_provider.dart';
import '../widgets/student_item.dart';
import '../widgets/new_student.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    void showNewStudentForm({Student? student}) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return NewStudent(
            existingStudent: student,
            onSave: (updatedStudent) {
              if (student != null) {
                ref.read(studentsProvider.notifier).updateStudent(updatedStudent);
              } else {
                ref.read(studentsProvider.notifier).addStudent(updatedStudent);
              }
            },
          );
        },
      );
    }

    void deleteStudent(Student student) {
      ref.read(studentsProvider.notifier).deleteStudent(student.id);
      final container = ProviderScope.containerOf(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${student.firstName} успішно видалено.'),
          action: SnackBarAction(
            label: 'Скасувати',
            onPressed: () {
              container.read(studentsProvider.notifier).restoreStudent(student);
            },
          ),
        ),
      );
    }

    return Scaffold(
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
            onDismissed: (_) => deleteStudent(student),
            child: InkWell(
              onTap: () => showNewStudentForm(student: student),
              child: StudentItem(student: student),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showNewStudentForm(),
        label: const Text('Додати'),
        icon: const Icon(Icons.person_add_alt_1),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
