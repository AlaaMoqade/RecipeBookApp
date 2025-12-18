import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const AppButton({
    super.key,
    required this.text,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: onPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: AppTextStyles.body1Bold.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
    );
  }
}
