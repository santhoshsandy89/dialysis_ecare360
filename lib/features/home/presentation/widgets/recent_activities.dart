import 'package:ecare360/data/models/treatment_model.dart';
import 'package:ecare360/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Recent activities widget

class ScheduleTreatmentList extends StatefulWidget {
  final List<Treatment> treatments;

  const ScheduleTreatmentList({
    super.key,
    required this.treatments,
  });

  @override
  State<ScheduleTreatmentList> createState() => _ScheduleTreatmentListState();
}

class _ScheduleTreatmentListState extends State<ScheduleTreatmentList> {
  late List<Treatment> treatments;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    treatments = widget.treatments;
    _loadTreatments();
  }

  @override
  void didUpdateWidget(covariant ScheduleTreatmentList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.treatments != widget.treatments) {
      setState(() {
        treatments = widget.treatments;
      });
    }
  }

  Future<void> _loadTreatments() async {
    final list = await LocalStorageService.getTreatments();
    setState(() {
      treatments = list;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildCard(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Treatments',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'View All',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : treatments.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "No Treatments Scheduled",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: List.generate(treatments.length, (index) {
                    final t = treatments[index];
                    return Column(
                      children: [
                        TreatmentItem(treatment: t),
                        if (index < treatments.length - 1)
                          const Divider(height: 24),
                      ],
                    );
                  }),
                ),
    );
  }
}

class TreatmentItem extends StatelessWidget {
  final Treatment treatment;

  const TreatmentItem({super.key, required this.treatment});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd MMM yyyy').format(treatment.scheduledDate);
    final formattedTime = treatment.scheduledTime.format(context);
    return Row(
      children: [
        // Icon for treatment
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.medical_services,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),

        // Treatment Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${treatment.patient.firstName} ${treatment.patient.lastName}",
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "${treatment.treatmentType.name} • $formattedDate $formattedTime",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),

        // Optional status badge
        // Status badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: treatment.isCompleted
                ? AppColors.success.withOpacity(0.1)
                : AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            treatment.isCompleted ? "Completed" : "Pending",
            style: AppTextStyles.labelSmall.copyWith(
              color:
                  treatment.isCompleted ? AppColors.success : AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
