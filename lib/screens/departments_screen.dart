import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/departments_provider.dart';
import '../providers/students_provider.dart';
import '../widgets/department_item.dart';

class DepartmentsScreen extends ConsumerWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departments = ref.watch(departmentsProvider);
    final students = ref.watch(studentsProvider);

    final departmentsWithCounts = departments.map((dept) {
      final studentCount = students
          .where((student) => student.department.id == dept.id)
          .length;

      return DepartmentItem(
        name: dept.name,
        color: dept.color,
        icon: dept.icon,
        studentCount: studentCount,
      );
    }).toList();

    return GridView(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 2,
      ),
      children: departmentsWithCounts,
    );
  }
}
