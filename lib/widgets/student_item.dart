import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentItem extends StatelessWidget {
  final Student student;

  const StudentItem({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final bgColor = student.gender == Gender.male
        ? Colors.lightBlue.shade100
        : Colors.pink.shade100;

    final borderColor = student.gender == Gender.male
        ? Colors.blue.shade700
        : Colors.pink.shade700;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipPath(
            clipper: DiamondClipper(),
            child: Container(
              width: 50,
              height: 50,
              color: borderColor.withOpacity(0.3),
              alignment: Alignment.center,
              child: Icon(
                student.department.icon, // Используем поле icon из Department
                size: 28,
                color: borderColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${student.firstName} ${student.lastName}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: borderColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  student.department.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: borderColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${student.grade}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: borderColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
