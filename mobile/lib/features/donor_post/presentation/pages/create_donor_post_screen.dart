import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/features/donor_post/data/models/donor_post_request.dart';
import 'package:blood_connect/features/donor_post/domain/notifiers/donor_post_notifier.dart';
import 'package:blood_connect/features/authentication/domain/notifiers/auth_notifier.dart';
import 'package:blood_connect/shared/widgets/widgets_export.dart';

class CreateDonorPostScreen extends ConsumerStatefulWidget {
  const CreateDonorPostScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateDonorPostScreen> createState() =>
      _CreateDonorPostScreenState();
}

class _CreateDonorPostScreenState extends ConsumerState<CreateDonorPostScreen> {
  final _formKey = GlobalKey<FormState>();

  final _notesController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  String _selectedBloodType = 'A';
  String _selectedRhesus = '+';

  final List<String> _bloodTypes = ['A', 'B', 'AB', 'O'];
  final List<String> _rhesusTypes = ['+', '-'];

  @override
  void dispose() {
    _notesController.dispose();
    _locationController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authState = ref.read(authNotifierProvider);
      final user = authState.mapOrNull(authenticated: (s) => s.user);
      if (user != null && user.phone.isNotEmpty) {
        _contactPhoneController.text = user.phone;
      }
    });
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final request = CreateDonorPostRequest(
        bloodType: _selectedBloodType,
        rhesus: _selectedRhesus,
        location: _locationController.text.trim(),
        contactPhone: _contactPhoneController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      final success = await ref
          .read(donorPostNotifierProvider.notifier)
          .createPost(request);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tawaran donor berhasil dibuat!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else if (mounted) {
        final error = ref.read(donorPostNotifierProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Gagal membuat tawaran donor'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(donorPostNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buat Tawaran Donor',
          style: AppTypography.headingSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bantu Mereka yang Membutuhkan',
                  style: AppTypography.headingMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Beritahu orang lain bahwa Anda siap mendonorkan darah Anda.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 32.h),

                // Section: Golongan Darah
                Text(
                  'Golongan Darah Anda',
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _selectedBloodType,
                        decoration: InputDecoration(
                          labelText: 'Golongan Darah',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.water_drop_outlined,
                              color: AppColors.primary),
                        ),
                        items: _bloodTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedBloodType = value);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _selectedRhesus,
                        decoration: InputDecoration(
                          labelText: 'Rhesus',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _rhesusTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedRhesus = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Section: Lokasi
                Text(
                  'Lokasi / Daerah',
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                AppTextFormField(
                  controller: _locationController,
                  label: 'Kota / Daerah',
                  hintText: 'Misal: Jakarta Selatan, Surabaya',
                  prefixIcon: Icons.location_on_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // Section: Kontak Darurat
                Text(
                  'Kontak Darurat',
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                AppTextFormField(
                  controller: _contactPhoneController,
                  label: 'Nomor WhatsApp',
                  hintText: 'Misal: 08123456789',
                  prefixIcon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor WhatsApp tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // Section: Catatan Tambahan
                Text(
                  'Catatan Tambahan',
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                AppTextFormField(
                  controller: _notesController,
                  label: 'Catatan Ketersediaan',
                  hintText: 'Misal: Tersedia akhir pekan di area Jakarta Selatan',
                  maxLines: 3,
                  prefixIcon: Icons.note_alt_outlined,
                ),
                SizedBox(height: 40.h),

                // Submit Button
                PrimaryButton(
                  label: 'Posting Tawaran Donor',
                  onPressed: _submit,
                  enabled: !state.isLoading,
                  isLoading: state.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
