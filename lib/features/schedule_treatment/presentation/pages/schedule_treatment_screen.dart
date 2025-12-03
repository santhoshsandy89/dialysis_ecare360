import 'package:ecare360/core/widgets/custom_button.dart';
import 'package:ecare360/core/widgets/custom_text_field.dart';
import 'package:ecare360/data/models/patient_model.dart';
import 'package:ecare360/data/models/treatment_model.dart';
import 'package:ecare360/features/home/presentation/providers/local_storage_controller.dart';
import 'package:ecare360/features/home/presentation/providers/patient_id_provider.dart';
import 'package:ecare360/features/schedule_treatment/data/models/patient.dart';
import 'package:ecare360/features/session_management/presentation/pages/session_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/schedule_treatment_provider.dart';

enum TreatmentType { Hemodialysis, PeritonealDialysis }

enum TempPatientName { Ram, Kumar, David }

enum BloodAccessType { Fistula, Graft, Catheter }

class ScheduleTreatmentSection extends ConsumerStatefulWidget {
  const ScheduleTreatmentSection({super.key});

  @override
  ConsumerState<ScheduleTreatmentSection> createState() =>
      _ScheduleTreatmentSectionState();
}

class _ScheduleTreatmentSectionState
    extends ConsumerState<ScheduleTreatmentSection> {
  final _formKey = GlobalKey<FormState>();

  final _mrnNoController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  String? _selectedPatientMrn;

  DateTime? _patientDob;
  BloodType? _patientBloodType;

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
    final picked = await showDatePicker(
      context: context,
      initialDate: ref.read(scheduleTreatmentProvider).selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      ref.read(scheduleTreatmentProvider.notifier).updateSelectedDate(picked);
    }
  }

  Future<void> _selectPatientDob(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _patientDob = picked;
        _dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _showAddPatientModal(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientIdProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 HEADER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Add New Patient",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),

                    // 🔹 FORM FIELDS
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                        child: Column(
                          children: [
                            _buildDropdownField(
                              'Patient MRN',
                              _selectedPatientMrn,
                              patients
                                  .map((p) => p.id)
                                  .toList(), // list of MRNs
                              (String? newValue) {
                                final patient = patients
                                    .firstWhere((p) => p.id == newValue);
                                setState(() {
                                  _selectedPatientMrn = newValue;
                                  _firstNameController.text = patient.username;
                                  _lastNameController.text = patient.lastName;
                                  _phoneController.text = patient.phone;
                                  _emailController.text = patient.email;
                                });
                              },
                              true,
                              displayValueMap: patients
                                  .map((p) => {
                                        'display':
                                            '${p.id} - ${p.username} ${p.lastName}',
                                        'value': p.id
                                      })
                                  .toList(),
                            ),
                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _firstNameController,
                              labelText: 'First Name',
                              validator: (v) =>
                                  v!.isEmpty ? "First Name is required" : null,
                            ),
                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _lastNameController,
                              labelText: 'Last Name',
                              validator: (v) =>
                                  v!.isEmpty ? "Last Name is required" : null,
                            ),
                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _dobController,
                              labelText: "Date of Birth",
                              readOnly: true,
                              suffixIcon: const Icon(Icons.calendar_today),
                              onTap: () => _selectPatientDob(context),
                              validator: (v) => v!.isEmpty
                                  ? "Date of Birth is required"
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            DropdownButtonFormField<BloodType>(
                              value: _patientBloodType,
                              decoration: const InputDecoration(
                                labelText: "Blood Type",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (v) =>
                                  setState(() => _patientBloodType = v),
                              items: BloodType.values
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child:
                                            Text(e.toString().split('.').last),
                                      ))
                                  .toList(),
                              validator: (v) =>
                                  v == null ? "Blood Type is required" : null,
                            ),
                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _phoneController,
                              labelText: "Phone",
                              validator: (v) =>
                                  v!.isEmpty ? "Phone is required" : null,
                            ),
                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _emailController,
                              labelText: "Email",
                              validator: (v) =>
                                  v!.isEmpty ? "Email is required" : null,
                            ),
                            const SizedBox(height: 20),

                            // 🔥 SAVE BUTTON
                            CustomButton(
                              text: "Add Patient",
                              icon: Icons.person_add,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final patient = PatientModel(
                                    mrnNo: _selectedPatientMrn ??
                                        _mrnNoController.text,
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    dob: _patientDob.toString(),
                                    bloodType: _patientBloodType.toString(),
                                    phone: _phoneController.text,
                                    email: _emailController.text,
                                  );

                                  // ⭐ SAVE TO SHARED PREFERENCES
                                  await ref
                                      .read(localStorageProvider.notifier)
                                      .addPatient(patient);

                                  Navigator.pop(context, true);
                                }
                              },
                            ),

                            const SizedBox(height: 12),

                            // CANCEL BUTTON
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showScheduleTreatmentBottomSheet(BuildContext context, WidgetRef ref) {
    DateTime? scheduleDate;
    TimeOfDay? scheduleTime;

    final durationController = TextEditingController();
    final locationController = TextEditingController();
    final nurseController = TextEditingController();
    final ufGoalController = TextEditingController();
    final notesController = TextEditingController();

    final storageState = ref.watch(localStorageProvider);
    final patientList = storageState.patients;

    BloodAccessType? accessType;
    TreatmentType? treatmentType;
    PatientModel? selectedPatient;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔵 HEADER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // MAIN TITLE
                        Text(
                          "Schedule Dialysis Treatment",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 6),

                        // SUB HEADER
                        Text(
                          "Enter scheduling information only — detailed session data will be captured during treatment.",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(0.85),
                                  ),
                        ),
                      ],
                    ),
                  ),

                  // 🔹 FORM CONTENT (scrollable)
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Column(
                        children: [
                          // SELECT PATIENT
                          DropdownButtonFormField<PatientModel>(
                            value: selectedPatient,
                            decoration: const InputDecoration(
                              labelText: "Select Patient (MRN)",
                              border: OutlineInputBorder(),
                            ),
                            items: patientList.map((p) {
                              return DropdownMenuItem(
                                value: p,
                                child: Text(
                                    "${p.mrnNo} - ${p.firstName} ${p.lastName}"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPatient = value;
                              });
                            },
                            validator: (v) =>
                                v == null ? "Please select a patient" : null,
                          ),
                          const SizedBox(height: 16),

                          // TREATMENT TYPE
                          DropdownButtonFormField<TreatmentType>(
                            value: treatmentType,
                            decoration: const InputDecoration(
                              labelText: "Treatment Type",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (v) => setState(() => treatmentType = v),
                            items: TreatmentType.values
                                .map((t) => DropdownMenuItem(
                                      value: t,
                                      child: Text(t.name),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 16),

                          // SCHEDULE DATE
                          CustomTextField(
                            labelText: "Scheduled Date",
                            readOnly: true,
                            controller: TextEditingController(
                              text: scheduleDate == null
                                  ? ""
                                  : DateFormat('dd-MM-yyyy')
                                      .format(scheduleDate!),
                            ),
                            suffixIcon:
                                const Icon(Icons.calendar_today_outlined),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                setState(() => scheduleDate = date);
                              }
                            },
                          ),
                          const SizedBox(height: 16),

                          // SCHEDULE TIME
                          CustomTextField(
                            labelText: "Scheduled Time",
                            readOnly: true,
                            controller: TextEditingController(
                              text: scheduleTime == null
                                  ? ""
                                  : scheduleTime!.format(context),
                            ),
                            suffixIcon: const Icon(Icons.access_time),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                setState(() => scheduleTime = time);
                              }
                            },
                          ),
                          const SizedBox(height: 16),

                          // DURATION
                          CustomTextField(
                            controller: durationController,
                            labelText: "Planned Duration (minutes)",
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // LOCATION
                          CustomTextField(
                            controller: locationController,
                            labelText: "Location / Station",
                          ),
                          const SizedBox(height: 16),

                          // ASSIGNED NURSE
                          CustomTextField(
                            controller: nurseController,
                            labelText: "Assigned Nurse",
                          ),
                          const SizedBox(height: 32),

                          // SECTION HEADER
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Hemodialysis Planning Parameters",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ACCESS TYPE
                          DropdownButtonFormField<BloodAccessType>(
                            value: accessType,
                            decoration: const InputDecoration(
                              labelText: "Access Type",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (v) => setState(() => accessType = v),
                            items: BloodAccessType.values
                                .map((t) => DropdownMenuItem(
                                      value: t,
                                      child: Text(t.name),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 16),

                          // UF GOAL
                          CustomTextField(
                            controller: ufGoalController,
                            labelText: "Target Ultrafiltration Goal (mL)",
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // NOTES
                          CustomTextField(
                            controller: notesController,
                            labelText: "Scheduling Notes",
                          ),
                          const SizedBox(height: 20),

                          // SUBMIT BUTTON
                          CustomButton(
                            text: "Schedule Treatment",
                            icon: Icons.event_available,
                            onPressed: () async {
                              if (selectedPatient == null ||
                                  treatmentType == null ||
                                  scheduleDate == null ||
                                  scheduleTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Please fill all required fields")),
                                );
                                return;
                              }

                              final treatment = Treatment(
                                patient: selectedPatient!,
                                treatmentType: treatmentType!,
                                scheduledDate: scheduleDate!,
                                scheduledTime: scheduleTime!,
                                durationMinutes:
                                    int.tryParse(durationController.text) ?? 0,
                                location: locationController.text,
                                nurse: nurseController.text,
                                accessType: accessType!,
                                ufGoal: int.tryParse(ufGoalController.text),
                                notes: notesController.text,
                                isCompleted: false,
                              );

                              await ref
                                  .read(localStorageProvider.notifier)
                                  .addTreatment(treatment);

                              Navigator.pop(context, true);
                            },
                          ),
                          const SizedBox(height: 12),

                          // CANCEL BUTTON
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduleTreatmentProvider);
    final selectedDate = state.selectedDate;
    final patientList = state.patientList;
    final selectedStatus = state.selectedStatus;
    final scheduledList = state.scheduledTreatments;
    final storageState = ref.watch(localStorageProvider);
    final scheduledListController = storageState.treatments;
    final patientListController = storageState.patients;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TOP CARD
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context, ref),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: TextEditingController(
                              text:
                                  DateFormat('dd-MM-yyyy').format(selectedDate),
                            ),
                            labelText: "Date",
                            readOnly: true,
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<TreatmentStatus>(
                        value: selectedStatus,
                        decoration: const InputDecoration(
                          labelText: "Status",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) {
                          if (v != null) {
                            ref
                                .read(scheduleTreatmentProvider.notifier)
                                .updateSelectedStatus(v);
                          }
                        },
                        items: TreatmentStatus.values
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child:
                                      Text(status.toString().split('.').last),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "Add Patient",
                        icon: Icons.person_add,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        onPressed: () {
                          _showAddPatientModal(context, ref);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: "Schedule Treatment",
                        icon: Icons.add,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        onPressed: () =>
                            _showScheduleTreatmentBottomSheet(context, ref),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // PATIENT LIST
        if (scheduledListController.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(Icons.calendar_today,
                    size: 60,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5)),
                const SizedBox(height: 12),
                Text("No Treatments Found",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  "Get started by scheduling your first treatment",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: List.generate(
                scheduledListController.length,
                (i) => Column(
                  children: [
                    _ScheduledTreatmentItem(
                      treatment: scheduledListController[i],
                      onDelete: () {
                        ref
                            .read(scheduleTreatmentProvider.notifier)
                            .removeScheduledTreatment(i);
                      },
                      onStartSession: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SessionManagementScreen(
                              patient: patientListController.first,
                              treatmentType:
                                  "Hemodialysis", // or dynamically pass schedule.treatmentType
                            ),
                          ),
                        );
                        ref
                            .read(scheduleTreatmentProvider.notifier)
                            .startSession(
                                patientListController[i], "Hemodialysis");
                      },
                    ),
                    if (i != scheduledListController.length - 1)
                      const Divider(height: 24),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Helper method for dropdown fields
  // Helper method for dropdown fields (SAFE VERSION)
  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
    bool isRequired, {
    List<Map<String, dynamic>>? displayValueMap,
  }) {
    // If using displayValueMap → rebuild items from it
    final dropdownItems = displayValueMap != null
        ? displayValueMap.map((map) => map['display'] as String).toList()
        : items;

    // Prevent Flutter crash: value must be in items
    final safeValue =
        dropdownItems.contains(selectedValue) ? selectedValue : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: safeValue,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }
}

class _ScheduledTreatmentItem extends StatelessWidget {
  final Treatment treatment;
  final VoidCallback onDelete;
  final VoidCallback onStartSession;

  const _ScheduledTreatmentItem({
    required this.treatment,
    required this.onDelete,
    required this.onStartSession,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd MMM yyyy').format(treatment.scheduledDate);
    final formattedTime = treatment.scheduledTime.format(context);
    return Row(
      children: [
        // Avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(Icons.medical_services, color: Colors.blue),
        ),
        const SizedBox(width: 12),

        // Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                treatment.patient.firstName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                "${treatment.treatmentType.name} • $formattedDate $formattedTime",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                const buttonWidth = 140.0;

                return Column(
                  children: [
                    SizedBox(
                      width: buttonWidth,
                      child: ElevatedButton.icon(
                        onPressed: onStartSession,
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        label: const Text("Start Session"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: buttonWidth,
                      child: ElevatedButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text("Delete"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        )
      ],
    );
  }
}
