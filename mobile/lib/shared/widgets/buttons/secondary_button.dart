import 'package:flutter/material.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/core/constants/app_constants.dart';

class SecondaryButton extends StatefulWidget {
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
  final Color? borderColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const SecondaryButton({
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
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
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
        child: OutlinedButton(
          onPressed: widget.enabled && !widget.isLoading
              ? () {
                  _controller.forward().then((_) {
                    _controller.reverse();
                  });
                  widget.onPressed();
                }
              : null,
          style: OutlinedButton.styleFrom(
            backgroundColor:
                widget.backgroundColor ?? AppColors.background,
            disabledBackgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius:
                  widget.borderRadius ?? BorderRadius.circular(16),
            ),
            side: BorderSide(
              color: widget.borderColor ?? AppColors.border,
              width: 1,
            ),
            padding: widget.padding,
          ),
          child: widget.isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.textColor ?? AppColors.primary,
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
                        color: widget.textColor ?? AppColors.primary,
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
