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

    if (students.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    void showNewStudentForm({int? index}) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return NewStudent(studentIndex: index,);
        },
      );
    }

    void deleteStudent(Student student, int index) {
      ref.read(studentsProvider.notifier).removeStudent(index);
      final container = ProviderScope.containerOf(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${student.firstName} успішно видалено.'),
          action: SnackBarAction(
            label: 'Скасувати',
            onPressed: () {
              container.read(studentsProvider.notifier).undo();
            },
          ),
        ),
      ).closed.then((value) {
        if (value != SnackBarClosedReason.action) {
          ref.read(studentsProvider.notifier).removeLastFromDb();
        }
      });
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: students.list.length,
        itemBuilder: (ctx, index) {
          final student = students.list[index];
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
            onDismissed: (_) => deleteStudent(student, index),
            child: InkWell(
              onTap: () => showNewStudentForm(index: index),
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
