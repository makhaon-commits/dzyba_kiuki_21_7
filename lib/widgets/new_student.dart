import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/department.dart';
import '../models/student.dart';
import '../providers/departments_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';


class NewStudent extends ConsumerStatefulWidget {
  const NewStudent({
    super.key,
    this.studentIndex
  });

  final int? studentIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewStudentState();
}

class _NewStudentState extends ConsumerState<NewStudent> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Department _selectedDepartment = departments[0];
  Gender _selectedGender = Gender.female;
  int _grade = 50;

  @override
  void initState() {
    super.initState();
    if (widget.studentIndex != null) {
      final student = ref.read(studentsProvider).list[widget.studentIndex!];
      _firstNameController.text = student.firstName;
      _lastNameController.text = student.lastName;
      _selectedGender = student.gender;
      _selectedDepartment = student.department;
      _grade = student.grade;
    }
  }

  void _save() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty) {
      return;
    }

    if (widget.studentIndex == null)  {
      await ref.read(studentsProvider.notifier).addStudent(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDepartment,
            _selectedGender,
            _grade,
          );
    } else {
      await ref.read(studentsProvider.notifier).editStudent(
            widget.studentIndex!,
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDepartment,
            _selectedGender,
            _grade,
          );
    }

    if (!context.mounted) return;
    Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Colors.deepPurpleAccent;
    final departmentsP = ref.watch(departmentsProvider);
    final state = ref.watch(studentsProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                widget.studentIndex == null ? 'Додати Студента' : 'Редагувати Студента',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: borderColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildInputField(_firstNameController, 'Ім’я', borderColor),
              const SizedBox(height: 16),
              _buildInputField(_lastNameController, 'Прізвище', borderColor),
              const SizedBox(height: 16),
              _buildDropdownField<Department>(
                value: _selectedDepartment,
                label: 'Факультет',
                items: departmentsP,
                borderColor: borderColor,
                itemToString: (department) => department.name,
                onChanged: (value) => setState(() => _selectedDepartment = value!),
              ),
              const SizedBox(height: 16),
              _buildDropdownField<String>(
                value: _selectedGender != null ? _genderToUkrainian(_selectedGender!) : null,
                label: 'Стать',
                items: ['Чоловік', 'Жінка'],
                borderColor: borderColor,
                itemToString: (item) => item,
                onChanged: (value) =>
                    setState(() => _selectedGender = _ukrainianToGender(value!)),
              ),
              const SizedBox(height: 16),
              Slider(
                value: _grade.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: 'Оцінка: $_grade',
                onChanged: (value) => setState(() => _grade = value.toInt()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: borderColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Зберегти'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, String label, Color borderColor) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required String label,
    required List<T> items,
    required Color borderColor,
    required String Function(T) itemToString,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: items.contains(value) ? value : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemToString(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  String _genderToUkrainian(Gender gender) {
    return gender == Gender.male ? 'Чоловік' : 'Жінка';
  }

  Gender _ukrainianToGender(String text) {
    return text == 'Чоловік' ? Gender.male : Gender.female;
  }
}
