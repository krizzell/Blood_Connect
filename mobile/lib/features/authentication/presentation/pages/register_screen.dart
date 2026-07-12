import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/core/config/router/app_routes.dart';
import 'package:blood_connect/shared/widgets/buttons/primary_button.dart';
import 'package:blood_connect/shared/widgets/form_fields/app_text_form_field.dart';
import 'package:blood_connect/shared/widgets/loading_widget.dart';
import '../../domain/domain_export.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedBloodType = 'A';
  String _selectedRhesus = '+';
  DateTime? _selectedBirthDate;
  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthDateController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // Get current location (simplified - in real app use geolocator package)
      _latitude = -6.2088; // Jakarta default
      _longitude = 106.8456;

      ref.read(authNotifierProvider.notifier).register(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phone: _phoneController.text.trim(),
            gender: _selectedGender,
            birthDate: _birthDateController.text,
            bloodType: _selectedBloodType,
            rhesus: _selectedRhesus,
            weight: int.parse(_weightController.text),
            lastDonorDate: null,
            latitude: _latitude!,
            longitude: _longitude!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Navigate based on auth state
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      print('[RegisterScreen] Auth state changed: previous=$previous, next=$next');
      next.whenOrNull(
        authenticated: (_, __) {
          print('[RegisterScreen] Authenticated - navigating to main');
          context.go(AppRoutes.main);
        },
        registrationSuccess: () {
          print('[RegisterScreen] Registration success - showing snackbar and navigating to login');
          // Reset auth state to unauthenticated first
          ref.read(authNotifierProvider.notifier).resetState();
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Akun berhasil dibuat! Silakan login.'),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 3),
            ),
          );
          // Navigate to login
          context.go(AppRoutes.login);
        },
        error: (message) {
          print('[RegisterScreen] Error: $message');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Buat Akun',
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Dasar',
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),

                // Full Name
                AppTextFormField(
                  controller: _fullNameController,
                  label: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap',
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Nama tidak boleh kosong';
                    }
                    if (value!.length < 3) {
                      return 'Nama minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Email
                AppTextFormField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Masukkan email Anda',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Phone
                AppTextFormField(
                  controller: _phoneController,
                  label: 'Nomor Telepon',
                  hintText: 'Masukkan nomor telepon',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    if (!RegExp(r'^(\+62|0)[0-9]{9,12}$').hasMatch(value!)) {
                      return 'Format nomor telepon tidak valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Birth Date
                AppTextFormField(
                  controller: _birthDateController,
                  label: 'Tanggal Lahir',
                  hintText: 'Pilih tanggal lahir',
                  prefixIcon: Icons.calendar_today_outlined,
                  readOnly: true,
                  onTap: () => _selectBirthDate(context),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Tanggal lahir tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Gender & Blood Type Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jenis Kelamin',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            isExpanded: true,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedGender = value);
                              }
                            },
                            items: const [
                              DropdownMenuItem(value: 'Male', child: Text('Laki-laki')),
                              DropdownMenuItem(value: 'Female', child: Text('Perempuan')),
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.background,
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
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Golongan Darah',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          DropdownButtonFormField<String>(
                            value: _selectedBloodType,
                            isExpanded: true,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedBloodType = value);
                              }
                            },
                            items: const [
                              DropdownMenuItem(value: 'A', child: Text('A')),
                              DropdownMenuItem(value: 'B', child: Text('B')),
                              DropdownMenuItem(value: 'AB', child: Text('AB')),
                              DropdownMenuItem(value: 'O', child: Text('O')),
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.background,
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
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Rhesus & Weight Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rhesus',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          DropdownButtonFormField<String>(
                            value: _selectedRhesus,
                            isExpanded: true,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedRhesus = value);
                              }
                            },
                            items: const [
                              DropdownMenuItem(value: '+', child: Text('Positif (+)')),
                              DropdownMenuItem(value: '-', child: Text('Negatif (-)')),
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.background,
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
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Berat Badan (kg)',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          AppTextFormField(
                            controller: _weightController,
                            hintText: 'Masukkan berat badan',
                            keyboardType: TextInputType.number,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 12.h,
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Berat badan tidak boleh kosong';
                              }
                              try {
                                final weight = double.parse(value!);
                                if (weight < 45) {
                                  return 'Min 45 kg';
                                }
                                if (weight > 200) {
                                  return 'Max 200 kg';
                                }
                              } catch (e) {
                                return 'Format tidak valid';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Password Section
                Text(
                  'Keamanan Akun',
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),

                // Password
                AppTextFormField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: 'Masukkan password (min 6 karakter)',
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value!.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Confirm Password
                AppTextFormField(
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi Password',
                  hintText: 'Konfirmasi password',
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleRegister(),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }
                    if (value != _passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // Register Button
                authState.when(
                  initial: () => _buildRegisterButton(),
                  loading: () => _buildLoadingButton(),
                  authenticated: (_, __) => _buildRegisterButton(),
                  unauthenticated: () => _buildRegisterButton(),
                  registrationSuccess: () => _buildRegisterButton(),
                  error: (_) => _buildRegisterButton(),
                ),
                SizedBox(height: 16.h),

                // Login Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Sudah punya akun? ',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: Text(
                              'Login di sini',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        label: 'Buat Akun',
        onPressed: _handleRegister,
      ),
    );
  }

  Widget _buildLoadingButton() {
    return const SizedBox(
      width: double.infinity,
      child: LoadingWidget(),
    );
  }
}
