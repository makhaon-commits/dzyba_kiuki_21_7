import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsState {
  final List<Student> list;
  final bool isLoading;
  final String? error;

  StudentsState({
    required this.list,
    required this.isLoading,
    this.error,
  });

  StudentsState copyWith({
    List<Student>? students,
    bool? isLoading,
    String? errorMessage,
  }) {
    return StudentsState(
      list: students ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      error: errorMessage ?? this.error,
    );
  }
}

class StudentsNotifier extends StateNotifier<StudentsState> {
  StudentsNotifier() : super(StudentsState(list: [], isLoading: false));

  Student? _removedStudent;
  int? _removedIndex;

  Future<void> loadStudents() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final students = await Student.remoteGetList();
      state = state.copyWith(students: students, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load students: $e',
      );
    }
  }

  Future<void> addStudent(
    String firstName,
    String lastName,
    department,
    gender,
    int grade,
  ) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final student = await Student.remoteCreate(
          firstName, lastName, department, gender, grade);
      state = state.copyWith(
        students: [...state.list, student],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add student: $e',
      );
    }
  }

  Future<void> editStudent(
    int index,
    String firstName,
    String lastName,
    department,
    gender,
    int grade,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedStudent = await Student.remoteUpdate(
        state.list[index].id,
        firstName,
        lastName,
        department,
        gender,
        grade,
      );
      final updatedList = [...state.list];
      updatedList[index] = updatedStudent;
      state = state.copyWith(students: updatedList, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to edit student: $e',
      );
    }
  }

  void removeStudent(int index) {
    _removedStudent = state.list[index];
    _removedIndex = index;
    final updatedList = [...state.list];
    updatedList.removeAt(index);
    state = state.copyWith(students: updatedList);
  }

  void undo() {
    if (_removedStudent != null && _removedIndex != null) {
      final updatedList = [...state.list];
      updatedList.insert(_removedIndex!, _removedStudent!);
      state = state.copyWith(students: updatedList);
    }
  }

  Future<void> removeLastFromDb() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (_removedStudent != null) {
        await Student.remoteDelete(_removedStudent!.id);
        _removedStudent = null;
        _removedIndex = null;
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete student: $e',
      );
    }
  }
}

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, StudentsState>((ref) {

  final notifier = StudentsNotifier();
  notifier.loadStudents();
  return notifier;
});
