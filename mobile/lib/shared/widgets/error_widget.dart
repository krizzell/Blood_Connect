import 'package:flutter/material.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/core/constants/app_constants.dart';
import 'package:gap/gap.dart';
import 'buttons/primary_button.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final IconData icon;

  const ErrorStateWidget({
    Key? key,
    required this.title,
    this.message,
    this.onRetry,
    this.retryLabel,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              icon,
              size: 64,
              color: AppColors.error,
            ),

            const Gap(AppDimensions.spacing16),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            if (message != null) ...[
              const Gap(AppDimensions.spacing8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],

            if (onRetry != null) ...[
              const Gap(AppDimensions.spacing24),
              PrimaryButton(
                label: retryLabel ?? 'Try Again',
                onPressed: onRetry!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
