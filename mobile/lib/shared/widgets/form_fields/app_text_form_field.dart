import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';

/// Custom TextFormField with consistent styling across the app
class AppTextFormField extends StatefulWidget {
  /// Controller untuk text field
  final TextEditingController? controller;

  /// Label text yang ditampilkan di atas field
  final String? label;

  /// Hint text placeholder
  final String? hintText;

  /// Icon di sebelah kiri field
  final IconData? prefixIcon;

  /// Widget custom di sebelah kiri field (override prefixIcon jika ada)
  final Widget? prefix;

  /// Icon di sebelah kanan field (untuk action atau indicator)
  final IconData? suffixIcon;

  /// Widget custom di sebelah kanan field
  final Widget? suffix;

  /// Callback ketika suffix icon ditekan
  final VoidCallback? onSuffixIconPressed;

  /// Validation function
  final String? Function(String?)? validator;

  /// Callback ketika value berubah
  final void Function(String)? onChanged;

  /// Callback ketika field di-submit
  final void Function(String)? onSubmitted;

  /// Jenis input (text, email, password, number, etc)
  final TextInputType keyboardType;

  /// Bersifat obscure/hidden (untuk password)
  final bool obscureText;

  /// Jumlah maksimal karakter
  final int? maxLength;

  /// Jumlah baris (untuk multiline)
  final int? maxLines;

  /// Jumlah baris minimum
  final int minLines;

  /// Hanya baca
  final bool readOnly;

  /// Format inputan (untuk currency, phone, dll)
  final List<TextInputFormatter>? inputFormatters;

  /// Action button di keyboard
  final TextInputAction? textInputAction;

  /// Focus node untuk control focus
  final FocusNode? focusNode;

  /// Callback ketika field focus
  final VoidCallback? onTap;

  /// Custom error message styling
  final TextStyle? errorStyle;

  /// Enable atau disable field
  final bool enabled;

  /// Custom content padding
  final EdgeInsets? contentPadding;

  const AppTextFormField({
    Key? key,
    this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.onSuffixIconPressed,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.readOnly = false,
    this.inputFormatters,
    this.textInputAction,
    this.focusNode,
    this.onTap,
    this.errorStyle,
    this.enabled = true,
    this.contentPadding,
  }) : super(key: key);

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
        ],

        // TextFormField
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          maxLength: widget.maxLength,
          maxLines: _obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          readOnly: widget.readOnly,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          onTap: widget.onTap,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            prefixIcon: widget.prefix ?? (widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  )
                : null),
            suffixIcon: widget.suffix ?? (widget.suffixIcon != null
                ? GestureDetector(
                    onTap: widget.onSuffixIconPressed,
                    child: Icon(
                      widget.suffixIcon,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                  )
                : null),
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
            filled: true,
            fillColor: widget.enabled 
                ? AppColors.background 
                : AppColors.background.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            errorStyle: widget.errorStyle ??
                AppTypography.bodySmall.copyWith(
                  color: AppColors.error,
                ),
            counterText: '',
          ),
        ),

        // Show obscure toggle for password fields
        if (widget.obscureText) ...[
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Text(
              _obscureText ? 'Show password' : 'Hide password',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
