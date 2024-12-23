import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/department.dart';
import '../models/student.dart';
import '../providers/departments_provider.dart';

class NewStudent extends ConsumerStatefulWidget {
  final Student? existingStudent;
  final Function(Student) onSave;

  const NewStudent({super.key, required this.onSave, this.existingStudent});

  @override
  ConsumerState<NewStudent> createState() => _NewStudentState();
}

class _NewStudentState extends ConsumerState<NewStudent> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Department? _selectedDepartment;
  Gender? _selectedGender;
  int _grade = 50;

  @override
  void initState() {
    super.initState();
    if (widget.existingStudent != null) {
      _firstNameController.text = widget.existingStudent!.firstName;
      _lastNameController.text = widget.existingStudent!.lastName;
      _selectedDepartment = widget.existingStudent!.department;
      _selectedGender = widget.existingStudent!.gender;
      _grade = widget.existingStudent!.grade;
    }
  }

  void _save() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _selectedDepartment == null ||
        _selectedGender == null) {
      return;
    }

    final newStudent = Student(
      id: widget.existingStudent?.id ?? DateTime.now().toString(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      department: _selectedDepartment!,
      grade: _grade,
      gender: _selectedGender!,
    );

    widget.onSave(newStudent);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Colors.deepPurpleAccent;
    final departments = ref.watch(departmentsProvider);

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
                widget.existingStudent == null ? 'Додати Студента' : 'Редагувати Студента',
                style: TextStyle(
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
                items: departments,
                borderColor: borderColor,
                itemToString: (department) => department.name,
                onChanged: (value) => setState(() => _selectedDepartment = value),
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
