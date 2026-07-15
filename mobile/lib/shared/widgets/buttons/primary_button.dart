import 'package:flutter/material.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/core/constants/app_constants.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const PrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.height = AppDimensions.buttonHeightMedium,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.shortAnimationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: ElevatedButton(
          onPressed: widget.enabled && !widget.isLoading
              ? () {
                  _controller.forward().then((_) {
                    _controller.reverse();
                  });
                  widget.onPressed();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                widget.backgroundColor ?? AppColors.primary,
            disabledBackgroundColor: AppColors.textSecondary.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius:
                  widget.borderRadius ?? BorderRadius.circular(16),
            ),
            elevation: 0,
            padding: widget.padding,
          ),
          child: widget.isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.textColor ?? Colors.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.prefixIcon != null) ...[
                      widget.prefixIcon!,
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: AppTypography.labelLarge.copyWith(
                        color: widget.textColor ?? Colors.white,
                      ),
                    ),
                    if (widget.suffixIcon != null) ...[
                      const SizedBox(width: 8),
                      widget.suffixIcon!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
