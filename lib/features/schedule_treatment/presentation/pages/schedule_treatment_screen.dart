import 'package:ecare360/core/constants/app_colors.dart';
import 'package:ecare360/core/widgets/custom_button.dart';
import 'package:ecare360/core/widgets/custom_text_field.dart';
import 'package:ecare360/features/schedule_treatment/data/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/schedule_treatment_provider.dart';

class ScheduleTreatmentScreen extends ConsumerStatefulWidget {
  const ScheduleTreatmentScreen({super.key});

  @override
  ConsumerState<ScheduleTreatmentScreen> createState() =>
      _ScheduleTreatmentScreenState();
}

class _ScheduleTreatmentScreenState
    extends ConsumerState<ScheduleTreatmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mrnNoController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _patientDob;
  BloodType? _patientBloodType;
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController(
      text: _patientDob == null
          ? ''
          : DateFormat('dd-MM-yyyy').format(_patientDob!),
    );
  }

  @override
  void dispose() {
    _mrnNoController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ref.read(scheduleTreatmentProvider).selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null &&
        picked != ref.read(scheduleTreatmentProvider).selectedDate) {
      ref.read(scheduleTreatmentProvider.notifier).updateSelectedDate(picked);
    }
  }

  Future<void> _selectPatientDob(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _patientDob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _patientDob) {
      setState(() {
        _patientDob = picked;
        _dobController.text = DateFormat('dd-MM-yyyy').format(_patientDob!);
      });
    }
  }

  void _showAddPatientModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Patient',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _mrnNoController,
                  labelText: 'MRN No.',
                  validator: (value) =>
                      value!.isEmpty ? 'MRN No. is required' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _firstNameController,
                  labelText: 'First Name',
                  validator: (value) =>
                      value!.isEmpty ? 'First Name is required' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _lastNameController,
                  labelText: 'Last Name',
                  validator: (value) =>
                      value!.isEmpty ? 'Last Name is required' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _dobController,
                  labelText: 'Date of Birth',
                  readOnly: true,
                  onTap: () => _selectPatientDob(context),
                  suffixIcon: const Icon(Icons.calendar_today),
                  validator: (value) =>
                      value!.isEmpty ? 'Date of Birth is required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<BloodType>(
                  value: _patientBloodType,
                  decoration: InputDecoration(
                    labelText: 'Blood Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: BloodType.values.map((BloodType type) {
                    return DropdownMenuItem<BloodType>(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (BloodType? newValue) {
                    setState(() {
                      _patientBloodType = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Blood Type is required' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'Phone',
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Phone is required' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? 'Email is required' : null,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Add Patient',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newPatient = Patient(
                        mrnNo: _mrnNoController.text,
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        dob: _patientDob!,
                        bloodType: _patientBloodType!,
                        phone: _phoneController.text,
                        email: _emailController.text,
                      );
                      ref
                          .read(scheduleTreatmentProvider.notifier)
                          .addPatient(newPatient);
                      Navigator.pop(context);
                      // Clear the form
                      _mrnNoController.clear();
                      _firstNameController.clear();
                      _lastNameController.clear();
                      _phoneController.clear();
                      _emailController.clear();
                      _patientDob = null;
                      _patientBloodType = null;
                    }
                  },
                  icon: Icons.person_add,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleState = ref.watch(scheduleTreatmentProvider);
    final selectedDate = scheduleState.selectedDate;
    final selectedStatus = scheduleState.selectedStatus;
    final patientList = scheduleState.patientList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Treatment'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context, ref),
                            child: AbsorbPointer(
                              child: CustomTextField(
                                controller: TextEditingController(
                                  text: DateFormat('dd-MM-yyyy')
                                      .format(selectedDate),
                                ),
                                labelText: 'Date',
                                suffixIcon: const Icon(Icons.calendar_today),
                                readOnly: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<TreatmentStatus>(
                            value: selectedStatus,
                            decoration: InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            items: TreatmentStatus.values
                                .map((TreatmentStatus status) {
                              return DropdownMenuItem<TreatmentStatus>(
                                value: status,
                                child: Text(status.toString().split('.').last),
                              );
                            }).toList(),
                            onChanged: (TreatmentStatus? newValue) {
                              if (newValue != null) {
                                ref
                                    .read(scheduleTreatmentProvider.notifier)
                                    .updateSelectedStatus(newValue);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Add Patient',
                            onPressed: () => _showAddPatientModal(context, ref),
                            icon: Icons.person_add,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            text: 'Schedule Treatment',
                            onPressed: () {
                              // Implement scheduling logic here
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Schedule Treatment functionality not yet implemented.')),
                              );
                            },
                            icon: Icons.add,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (patientList.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today,
                          size: 60,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text(
                        'No Treatments Found',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Get started by scheduling your first treatment',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Schedule First Treatment',
                        onPressed: () => _showAddPatientModal(context, ref),
                        icon: Icons.add,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .shadow
                            .withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    itemCount: patientList.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final patient = patientList[index];
                      return _TreatmentItem(
                        patient: patient,
                        treatmentDate: selectedDate,
                        onDelete: () {
                          ref
                              .read(scheduleTreatmentProvider.notifier)
                              .removePatient(patient.mrnNo);
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TreatmentItem extends StatelessWidget {
  final Patient patient;
  final DateTime treatmentDate;
  final VoidCallback onDelete;

  const _TreatmentItem({
    required this.patient,
    required this.treatmentDate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Patient Avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.person,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),

        // Treatment Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patient.fullName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                'MRN: ${patient.mrnNo}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.textSecondaryLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(treatmentDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.bloodtype,
                    size: 14,
                    color: AppColors.textSecondaryLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    patient.bloodType.toString().split('.').last,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Delete Button
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
