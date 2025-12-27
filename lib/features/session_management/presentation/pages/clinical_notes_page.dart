import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:flutter/material.dart';

class ClinicalNotesPage extends StatelessWidget {
  final TextEditingController machineAlarmsController;
  final TextEditingController nursingInterventionsController;
  final TextEditingController patientToleranceController;
  final TextEditingController symptomsDuringTreatmentController;
  final TextEditingController actionTakenController;
  final TextEditingController complicationsDetailsController;
  final TextEditingController remarksController;
  final VoidCallback? onSave;
  final VoidCallback? onComplete;
  final VoidCallback? onNext;
  final VoidCallback? onCancel;
  final bool readOnly;

  const ClinicalNotesPage({
    super.key,
    required this.machineAlarmsController,
    required this.nursingInterventionsController,
    required this.patientToleranceController,
    required this.symptomsDuringTreatmentController,
    required this.actionTakenController,
    required this.complicationsDetailsController,
    required this.remarksController,
    this.onSave,
    this.onComplete,
    this.onNext,
    this.onCancel,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.blue.shade100,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: machineAlarmsController,
                    maxLines: 3,
                    readOnly: readOnly,
                    decoration: const InputDecoration(
                      labelText: "Machine Alarms",
                      hintText: "Document any machine alarms...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nursingInterventionsController,
                    maxLines: 3,
                    readOnly: readOnly,
                    decoration: const InputDecoration(
                      labelText: "Nursing Interventions",
                      hintText: "Document interventions performed...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: patientToleranceController.text.isNotEmpty
                        ? patientToleranceController.text
                        : null,
                    decoration: const InputDecoration(
                      labelText: "Patient Tolerance",
                      border: OutlineInputBorder(),
                    ),
                    items: ["Good", "Moderate", "Poor"]
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: readOnly
                        ? null
                        : (String? value) {
                            if (value != null) {
                              patientToleranceController.text = value;
                            }
                          },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: symptomsDuringTreatmentController,
                    maxLines: 3,
                    readOnly: readOnly,
                    decoration: const InputDecoration(
                      labelText: "Symptoms During Treatment",
                      hintText: "Document any symptoms reported...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: complicationsDetailsController,
                    maxLines: 3,
                    readOnly: readOnly,
                    decoration: const InputDecoration(
                      labelText: "Complications Details",
                      hintText: "Document any complications...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: actionTakenController,
                    maxLines: 3,
                    readOnly: readOnly,
                    decoration: const InputDecoration(
                      labelText: "Action Taken",
                      hintText: "Document actions taken...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: remarksController,
                    maxLines: 3,
                    readOnly: readOnly,
                    decoration: const InputDecoration(
                      labelText: "Remarks",
                      hintText: "Any additional remarks...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          actionButtons(context,
              onSave: onSave,
              onComplete: onComplete,
              onNext: onNext,
              onCancel: onCancel,
              readOnly: readOnly),
        ],
      ),
    );
  }
}
