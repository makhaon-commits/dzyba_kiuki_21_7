import 'package:flutter/material.dart';
import '../models/student.dart';

class NewStudent extends StatefulWidget {
  final Student? existingStudent;
  final Function(Student) onSave;

  const NewStudent({super.key, required this.onSave, this.existingStudent});

  @override
  State<NewStudent> createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
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

  String _genderToReadableText(Gender gender) {
    return gender == Gender.male ? 'Чоловік' : 'Жінка';
  }

  Gender _readableTextToGender(String text) {
    return text == 'Чоловік' ? Gender.male : Gender.female;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.grey.shade100;
    final borderColor = Colors.deepPurple.shade300;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                widget.existingStudent == null
                    ? 'Додати Студента'
                    : 'Редагувати Студента',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: borderColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _firstNameController,
                label: 'Ім’я',
                borderColor: borderColor,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _lastNameController,
                label: 'Прізвище',
                borderColor: borderColor,
              ),
              const SizedBox(height: 16),
              _buildDropdownField<Department>(
                value: _selectedDepartment,
                label: 'Факультет',
                items: Department.values,
                borderColor: borderColor,
                onChanged: (value) => setState(() => _selectedDepartment = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender != null ? _genderToReadableText(_selectedGender!) : null,
                decoration: InputDecoration(
                  labelText: 'Стать',
                  labelStyle: TextStyle(color: borderColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
                items: ['Чоловік', 'Жінка'].map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedGender = value == 'Чоловік' ? Gender.male : Gender.female);
                },
              ),
              const SizedBox(height: 16),
              Slider(
                value: _grade.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: 'Оцінка: $_grade',
                activeColor: borderColor,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Зберегти',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required Color borderColor,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: borderColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
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
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: borderColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
      items: items.map((item) {
        String displayText;
        if (item is Department) {
          displayText = _getDepartmentName(item);
        } else {
          displayText = item.toString();
        }
        return DropdownMenuItem(
          value: item,
          child: Text(displayText),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  String _getDepartmentName(Department department) {
    switch (department) {
      case Department.finance:
        return 'Фінанси';
      case Department.law:
        return 'Юриспруденція';
      case Department.it:
        return 'ІТ';
      case Department.medical:
        return 'Медицина';
      default:
        return '';
    }
  }

}
