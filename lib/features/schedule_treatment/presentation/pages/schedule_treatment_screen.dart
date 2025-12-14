import 'package:dropdown_search/dropdown_search.dart';
import 'package:ecare360/core/utils/logger.dart';
import 'package:ecare360/core/widgets/custom_button.dart';
import 'package:ecare360/core/widgets/custom_text_field.dart';
import 'package:ecare360/data/models/patient_id_model.dart';
import 'package:ecare360/data/models/patient_model.dart';
import 'package:ecare360/data/models/session_data_model.dart';
import 'package:ecare360/data/models/treatment_model.dart';
import 'package:ecare360/data/services/local_storage_service.dart';
import 'package:ecare360/features/home/presentation/providers/local_storage_controller.dart';
import 'package:ecare360/features/home/presentation/providers/patient_id_provider.dart';
import 'package:ecare360/features/schedule_treatment/data/models/patient.dart';
import 'package:ecare360/features/session_management/presentation/pages/session_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../session_management/presentation/pages/report_viewer_screen.dart';
import '../providers/schedule_treatment_provider.dart';

enum TreatmentType { Hemodialysis, PeritonealDialysis }

enum TempPatientName { Ram, Kumar, David }

enum BloodAccessType { Fistula, Graft, Catheter }

enum BloodAccessSubType { IJV, Femoral, PermCatheter }

enum TreatmentMainType {
  CRRT,
  Hemoperfusion,
  Plasmapheresis,
  Hemodiafiltration,
  Hemodialysis,
  PeritonealDialysis,
  slud,
}

enum CrrtSubType {
  CVVHD,
  CVVHF,
  CVVHDF,
  SCUF,
  SLED,
}

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
                            buildPatientSearchDropdown(patients),
                            /*_buildDropdownField(
                              'Patient MRN',
                              _selectedPatientMrn,
                              patients
                                  .map((p) => {
                                        'value': p.id, // real value!
                                        'display':
                                            '${p.id} - ${p.username} ${p.lastName}',
                                      })
                                  .toList(),
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
                            ),*/
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
                                        child: Text(e.displayName),
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
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return null;
                                }
                                final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                );
                                return emailRegex.hasMatch(v)
                                    ? null
                                    : "Invalid email";
                              },
                            ),
                            const SizedBox(height: 20),

                            // 🔥 SAVE BUTTON
                            CustomButton(
                              text: "Add Patient",
                              icon: Icons.person_add,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_selectedPatientMrn == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please select a patient MRN.")),
                                    );
                                    return;
                                  }
                                  AppLogger.debug(
                                      'ADD_PATIENT_MODAL: _selectedPatientMrn: $_selectedPatientMrn');
                                  final patient = PatientModel(
                                    mrnNo: _selectedPatientMrn!,
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

    final _formKey = GlobalKey<FormState>();

    const Map<BloodAccessType, String> bloodAccessTypeLabels = {
      BloodAccessType.Fistula: "Fistula",
      BloodAccessType.Graft: "Graft",
      BloodAccessType.Catheter: "Catheter",
    };

    const Map<BloodAccessSubType, String> catheterSubTypeLabels = {
      BloodAccessSubType.IJV: "IJV (Internal Jugular Vein)",
      BloodAccessSubType.Femoral: "Femoral",
      BloodAccessSubType.PermCatheter: "Perm Catheter",
    };

    const Map<TreatmentMainType, String> treatmentMainLabels = {
      TreatmentMainType.CRRT: "CRRT (Continuous Renal Replacement Therapy)",
      TreatmentMainType.Hemoperfusion: "Hemoperfusion",
      TreatmentMainType.Plasmapheresis: "Plasmapheresis",
      TreatmentMainType.Hemodiafiltration: "Hemodiafiltration",
      TreatmentMainType.slud: "SLUD",
    };

    const Map<CrrtSubType, String> crrtSubLabels = {
      CrrtSubType.CVVHD: "CVVHD",
      CrrtSubType.CVVHF: "CVVHF",
      CrrtSubType.CVVHDF: "CVVHDF",
      CrrtSubType.SCUF: "SCUF",
      CrrtSubType.SLED: "SLED",
    };

    final durationController = TextEditingController();
    final locationController = TextEditingController();
    final nurseController = TextEditingController();
    final ufGoalController = TextEditingController();
    final notesController = TextEditingController();

    final storageState = ref.watch(localStorageProvider);
    final patientList = storageState.patients;

    PatientModel? selectedPatient;
    TreatmentMainType? mainType;
    CrrtSubType? crrtSubType;
    BloodAccessType? accessType;
    BloodAccessSubType? bloodAccessSubType;

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
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

                  // 🔹 FORM CONTENT
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // PATIENT
                            DropdownButtonFormField<PatientModel>(
                              value: selectedPatient,
                              decoration: const InputDecoration(
                                labelText: "Select Patient (MRN) *",
                                border: OutlineInputBorder(),
                              ),
                              items: patientList.map((p) {
                                return DropdownMenuItem(
                                  value: p,
                                  child: Text(
                                      "${p.mrnNo} - ${p.firstName} ${p.lastName}"),
                                );
                              }).toList(),
                              onChanged: (v) =>
                                  setState(() => selectedPatient = v),
                              validator: (v) =>
                                  v == null ? "Patient is required" : null,
                            ),
                            const SizedBox(height: 16),

                            // TREATMENT TYPE
                            DropdownButtonFormField<TreatmentMainType>(
                              value: mainType,
                              decoration: const InputDecoration(
                                labelText: "Treatment Type *",
                                border: OutlineInputBorder(),
                              ),
                              items: TreatmentMainType.values.map((t) {
                                return DropdownMenuItem(
                                  value: t,
                                  child: Text(treatmentMainLabels[t] ?? t.name),
                                );
                              }).toList(),
                              onChanged: (v) {
                                setState(() {
                                  mainType = v;
                                  crrtSubType = null;
                                });
                              },
                              validator: (v) =>
                                  v == null ? "Treatment type required" : null,
                            ),
                            const SizedBox(height: 16),

                            // CRRT SUBTYPE
                            if (mainType == TreatmentMainType.CRRT)
                              DropdownButtonFormField<CrrtSubType>(
                                value: crrtSubType,
                                decoration: const InputDecoration(
                                  labelText: "CRRT Sub Type *",
                                  border: OutlineInputBorder(),
                                ),
                                items: CrrtSubType.values.map((t) {
                                  return DropdownMenuItem(
                                    value: t,
                                    child: Text(crrtSubLabels[t]!),
                                  );
                                }).toList(),
                                onChanged: (v) =>
                                    setState(() => crrtSubType = v),
                                validator: (v) =>
                                    v == null ? "CRRT subtype required" : null,
                              ),
                            const SizedBox(height: 16),

                            // DATE
                            CustomTextField(
                              labelText: "Scheduled Date *",
                              readOnly: true,
                              controller: TextEditingController(
                                text: scheduleDate == null
                                    ? ""
                                    : DateFormat('dd-MM-yyyy')
                                        .format(scheduleDate!),
                              ),
                              validator: (_) =>
                                  scheduleDate == null ? "Date required" : null,
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

                            // TIME
                            CustomTextField(
                              labelText: "Scheduled Time *",
                              readOnly: true,
                              controller: TextEditingController(
                                text: scheduleTime == null
                                    ? ""
                                    : scheduleTime!.format(context),
                              ),
                              validator: (_) =>
                                  scheduleTime == null ? "Time required" : null,
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
                              labelText: "Planned Duration (minutes) *",
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Duration is required";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // LOCATION
                            CustomTextField(
                              controller: locationController,
                              labelText: "Location / Station",
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Location is required";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // NURSE
                            CustomTextField(
                              controller: nurseController,
                              labelText: "Assigned Nurse",
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Assigned Nurse is required";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

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
                                labelText: "Access Type *",
                                border: OutlineInputBorder(),
                              ),
                              items: BloodAccessType.values.map((t) {
                                return DropdownMenuItem(
                                  value: t,
                                  child: Text(bloodAccessTypeLabels[t]!),
                                );
                              }).toList(),
                              onChanged: (v) {
                                setState(() {
                                  accessType = v;
                                  bloodAccessSubType = null;
                                });
                              },
                              validator: (v) =>
                                  v == null ? "Access type required" : null,
                            ),
                            const SizedBox(height: 16),

                            if (accessType == BloodAccessType.Catheter)
                              DropdownButtonFormField<BloodAccessSubType>(
                                value: bloodAccessSubType,
                                decoration: const InputDecoration(
                                  labelText: "Catheter Sub Type *",
                                  border: OutlineInputBorder(),
                                ),
                                items: BloodAccessSubType.values.map((t) {
                                  return DropdownMenuItem(
                                    value: t,
                                    child: Text(catheterSubTypeLabels[t]!),
                                  );
                                }).toList(),
                                onChanged: (v) =>
                                    setState(() => bloodAccessSubType = v),
                                validator: (v) => v == null
                                    ? "Catheter subtype required"
                                    : null,
                              ),
                            const SizedBox(height: 16),

                            // UF GOAL
                            CustomTextField(
                              controller: ufGoalController,
                              labelText: "Target Ultrafiltration Goal (mL)",
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Target Ultrafiltration Goal is required";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // NOTES
                            CustomTextField(
                              controller: notesController,
                              labelText: "Scheduling Notes",
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Scheduling Notes is required";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // SUBMIT
                            CustomButton(
                              text: "Schedule Treatment",
                              icon: Icons.event_available,
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                final treatment = Treatment(
                                  patient: selectedPatient!,
                                  treatmentMainType: mainType!,
                                  crrtSubType:
                                      mainType == TreatmentMainType.CRRT
                                          ? crrtSubType
                                          : null,
                                  scheduledDate: scheduleDate!,
                                  scheduledTime: scheduleTime!,
                                  durationMinutes:
                                      int.tryParse(durationController.text) ??
                                          0,
                                  location: locationController.text,
                                  nurse: nurseController.text,
                                  accessType: accessType!,
                                  ufGoal: int.tryParse(ufGoalController.text),
                                  notes: notesController.text,
                                  status: SessionStatus.pending,
                                );

                                await ref
                                    .read(localStorageProvider.notifier)
                                    .addTreatment(treatment);

                                Navigator.pop(context, true);
                              },
                            ),
                            const SizedBox(height: 12),

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
                      child: DropdownButtonFormField<SessionStatus>(
                        value: selectedStatus,
                        decoration: const InputDecoration(
                          labelText: "Status",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (SessionStatus? value) {
                          if (value != null) {
                            ref
                                .read(scheduleTreatmentProvider.notifier)
                                .updateSelectedStatus(value);
                          }
                        },
                        items: SessionStatus.values
                            .map(
                              (status) => DropdownMenuItem<SessionStatus>(
                                value: status,
                                child: Text(
                                  _statusLabel(status),
                                ),
                              ),
                            )
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
                      patientId: scheduledListController[i].patient.mrnNo,
                      onSessionCompleted: () {
                        // Force a refresh of the entire list to re-evaluate button states
                        ref.invalidate(localStorageProvider);
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
  Widget buildPatientSearchDropdown(List<PatientIDModel> patients) {
    PatientIDModel? selectedPatient =
        patients.any((p) => p.id == _selectedPatientMrn)
            ? patients.firstWhere((p) => p.id == _selectedPatientMrn)
            : null;
    return DropdownSearch<PatientIDModel>(
      popupProps: PopupProps.dialog(
        showSearchBox: true,
        searchFieldProps: const TextFieldProps(
          decoration: InputDecoration(
            labelText: "Search MRN",
            border: OutlineInputBorder(),
          ),
        ),
        itemBuilder: (context, patient, isSelected) {
          return ListTile(
            title:
                Text("${patient.id} - ${patient.username} ${patient.lastName}"),
          );
        },
      ),
      items: patients,
      itemAsString: (PatientIDModel p) =>
          "${p.id} - ${p.username} ${p.lastName}",
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Patient MRN *",
          border: OutlineInputBorder(),
        ),
      ),
      selectedItem: selectedPatient,
      onChanged: (PatientIDModel? p) {
        if (p == null) return;

        setState(() {
          _selectedPatientMrn = p.id;
          _firstNameController.text = p.username;
          _lastNameController.text = p.lastName;
          _phoneController.text = p.phone;
          _emailController.text = p.email;
        });
      },
    );
  }

  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<Map<String, dynamic>> displayValueMap,
    ValueChanged<String?> onChanged,
    bool isRequired,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: displayValueMap.map((map) {
          return DropdownMenuItem<String>(
            value: map['value'], // <-- real ID
            child: Text(map['display']), // <-- nice label
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

  String _statusLabel(SessionStatus status) {
    switch (status) {
      case SessionStatus.pending:
        return 'Pending';
      case SessionStatus.in_progress:
        return 'In Progress';
      case SessionStatus.completed:
        return 'Completed';
    }
  }
}

class _ScheduledTreatmentItem extends ConsumerWidget {
  final Treatment treatment;
  final VoidCallback onDelete;
  final String patientId;
  final VoidCallback onSessionCompleted;

  const _ScheduledTreatmentItem({
    required this.treatment,
    required this.onDelete,
    required this.patientId,
    required this.onSessionCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate =
        DateFormat('dd MMM yyyy').format(treatment.scheduledDate);
    final formattedTime = treatment.scheduledTime.format(context);

    // Using FutureBuilder to get the most up-to-date treatment status
    return FutureBuilder<Treatment?>(
      future:
          LocalStorageService.getTreatment(patientId, treatment.scheduledDate),
      builder: (context, snapshot) {
        AppLogger.debug(
            'SCHEDULE_ITEM: Checking treatment status for patient: $patientId, date: ${treatment.scheduledDate.toIso8601String().split('T').first}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          AppLogger.error(
              'SCHEDULE_ITEM: Error fetching treatment for $patientId on ${treatment.scheduledDate.toIso8601String().split('T').first}: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        }

        final Treatment? currentTreatment =
            snapshot.data; // This is the updated treatment from storage
        final SessionStatus sessionStatus =
            currentTreatment?.status ?? SessionStatus.pending;

        String buttonText;
        Color buttonColor;
        VoidCallback? onPressedAction;
        IconData buttonIcon;

        if (sessionStatus == SessionStatus.completed) {
          buttonText = "View Report";
          buttonColor = Colors.blue;
          buttonIcon = Icons.visibility;
          onPressedAction = () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReportViewerScreen(
                    patientId: patientId, sessionDate: treatment.scheduledDate),
              ),
            );
          };
        } else if (sessionStatus == SessionStatus.in_progress) {
          buttonText = "In Progress";
          buttonColor = Colors.orange;
          buttonIcon = Icons.play_circle_fill; // Icon for in-progress
          onPressedAction = () async {
            final SessionData? sessionData =
                await LocalStorageService.fetchSessionData(
                    patientId, treatment.scheduledDate);
            final int initialTabIndex = sessionData?.lastActiveTabIndex ?? 0;
            final SessionStatus? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SessionManagementScreen(
                  patient: treatment.patient,
                  treatmentType: treatment.treatmentMainType.name,
                  scheduledDate: treatment.scheduledDate,
                  initialStatus: SessionStatus.in_progress,
                  initialTabIndex: initialTabIndex,
                ),
              ),
            );
            // Refresh the list if the session status changed (e.g., completed)
            if (result != null) {
              onSessionCompleted();
            }
          };
        } else {
          // SessionStatus.pending
          buttonText = "Start Session";
          buttonColor = Colors.green;
          buttonIcon = Icons.play_arrow;
          onPressedAction = () async {
            final SessionStatus? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SessionManagementScreen(
                  patient: treatment.patient,
                  treatmentType: treatment.treatmentMainType.name,
                  scheduledDate: treatment.scheduledDate,
                  initialStatus: SessionStatus.pending,
                  initialTabIndex: 0,
                ),
              ),
            );
            // Refresh the list if the session status changed (e.g., in_progress or completed)
            if (result != null) {
              onSessionCompleted();
            }
          };
        }

        AppLogger.debug(
            'SCHEDULE_ITEM: Patient: $patientId, Scheduled Date: ${treatment.scheduledDate.toIso8601String().split('T').first}, Session Status: ${sessionStatus.name}, Button: $buttonText');

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
                    "${treatment.treatmentMainType.name} • $formattedDate $formattedTime",
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
                            onPressed: onPressedAction,
                            icon: Icon(buttonIcon, color: Colors.white),
                            label: Text(buttonText),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
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
      },
    );
  }
}
