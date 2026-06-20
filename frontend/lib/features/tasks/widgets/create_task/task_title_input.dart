import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TaskTitleInput extends StatelessWidget {
  final TextEditingController titleController;

  const TaskTitleInput({
    super.key,
    required this.titleController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: titleController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Title is required";
        }

        return null;
      },
      maxLines: 4,
      cursorColor: AppColors.primary,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 46,
        fontWeight: FontWeight.w700,
        height: 1,
        letterSpacing: -2,
      ),
      decoration: InputDecoration(
        hintText: "what's the move?",
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(.12),
        ),
        border: InputBorder.none,
      ),
    );
  }
}
