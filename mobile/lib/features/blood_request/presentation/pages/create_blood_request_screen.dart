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
import 'package:blood_connect/features/blood_request/data/data_export.dart';
import 'package:blood_connect/features/blood_request/domain/domain_export.dart';

class CreateBloodRequestScreen extends ConsumerStatefulWidget {
  const CreateBloodRequestScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateBloodRequestScreen> createState() =>
      _CreateBloodRequestScreenState();
}

class _CreateBloodRequestScreenState
    extends ConsumerState<CreateBloodRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _patientNameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _bagsNeededController = TextEditingController();
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();

  // Dropdowns
  String _selectedBloodType = 'A';
  String _selectedRhesus = '+';
  String _selectedUrgency = 'High';



  @override
  void dispose() {
    _patientNameController.dispose();
    _relationshipController.dispose();
    _bagsNeededController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
  }

  void _handleCreateBloodRequest() {
    if (_formKey.currentState!.validate()) {
      final request = BloodRequestRequest(
        patientName: _patientNameController.text.trim(),
        relationship: _relationshipController.text.trim(),
        location: _locationController.text.trim(),
        bloodType: _selectedBloodType,
        rhesus: _selectedRhesus,
        bagsNeeded: int.parse(_bagsNeededController.text),
        urgency: _selectedUrgency,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      ref.read(bloodRequestNotifierProvider.notifier).createBloodRequest(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bloodRequestNotifierProvider);

    // Listen for success - navigate back to blood request screen
    ref.listen<BloodRequestState>(bloodRequestNotifierProvider,
        (previous, next) {
      if (next.isSuccess && !next.isLoading) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Permintaan darah berhasil dibuat!'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate back to blood request screen after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            context.pop();
          }
        });
      } else if (next.errorMessage != null && !next.isLoading) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Buat Permintaan Darah',
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section: Informasi Pasien
                    Text(
                      'Informasi Pasien',
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Patient Name
                    AppTextFormField(
                      controller: _patientNameController,
                      label: 'Nama Pasien',
                      hintText: 'Masukkan nama pasien',
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Nama pasien wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Relationship
                    AppTextFormField(
                      controller: _relationshipController,
                      label: 'Hubungan Dengan Pasien',
                      hintText: 'Contoh: Diri Sendiri, Ayah, Ibu',
                      prefixIcon: Icons.family_restroom_outlined,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Hubungan dengan pasien wajib diisi';
                        }
                        return null;
                      },
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
                      hintText: 'Contoh: Jakarta Selatan, Surabaya',
                      prefixIcon: Icons.location_on_outlined,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Lokasi wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Section: Informasi Darah
                    Text(
                      'Informasi Darah',
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Blood Type & Rhesus Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            label: 'Jenis Darah',
                            value: _selectedBloodType,
                            items: ['A', 'B', 'AB', 'O'],
                            onChanged: (value) {
                              setState(() => _selectedBloodType = value!);
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildDropdown(
                            label: 'Rhesus',
                            value: _selectedRhesus,
                            items: ['+', '-'],
                            onChanged: (value) {
                              setState(() => _selectedRhesus = value!);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Bags Needed
                    AppTextFormField(
                      controller: _bagsNeededController,
                      label: 'Jumlah Kantong',
                      hintText: 'Masukkan jumlah kantong (minimal 1)',
                      prefixIcon: Icons.inventory_2_outlined,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Jumlah kantong wajib diisi';
                        }
                        final bags = int.tryParse(value!);
                        if (bags == null || bags < 1) {
                          return 'Jumlah kantong minimal 1';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Urgency
                    _buildDropdown(
                      label: 'Tingkat Urgency',
                      value: _selectedUrgency,
                      items: ['Low', 'Medium', 'High', 'Critical'],
                      onChanged: (value) {
                        setState(() => _selectedUrgency = value!);
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

                    // Notes
                    AppTextFormField(
                      controller: _notesController,
                      label: 'Catatan',
                      hintText: 'Masukkan catatan tambahan (opsional)',
                      prefixIcon: Icons.note_outlined,
                      maxLines: 3,
                    ),
                    SizedBox(height: 32.h),

                    // Submit Button
                    state.isLoading
                        ? const Center(child: LoadingWidget())
                        : SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              label: 'Buat Permintaan Darah',
                              onPressed: _handleCreateBloodRequest,
                            ),
                          ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
