import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier() : super([]);

  void addStudent(Student student) {
    state = [...state, student];
  }

  void updateStudent(Student updatedStudent) {
    state = state.map((student) {
      return student.id == updatedStudent.id ? updatedStudent : student;
    }).toList();
  }

  void deleteStudent(String id) {
    state = state.where((student) => student.id != id).toList();
  }

  void restoreStudent(Student student) {
    state = [...state, student];
  }
}

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>(
  (ref) => StudentsNotifier(),
);
