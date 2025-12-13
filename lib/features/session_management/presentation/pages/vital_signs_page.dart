import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:flutter/material.dart';

class VitalSignsPage extends StatelessWidget {
  final TextEditingController preWeightController;
  final TextEditingController postWeightController;
  final TextEditingController prePulseController;
  final TextEditingController midPulseController;
  final TextEditingController postPulseController;
  final TextEditingController preSystolicController;
  final TextEditingController midSystolicController;
  final TextEditingController postSystolicController;
  final TextEditingController preDiastolicController;
  final TextEditingController midDiastolicController;
  final TextEditingController postDiastolicController;
  final TextEditingController preTempController;
  final TextEditingController postTempController;
  final TextEditingController preSpo2Controller;
  final TextEditingController postSpo2Controller;
  final VoidCallback? onSave;
  final VoidCallback? onComplete;
  final VoidCallback? onNext;
  final VoidCallback? onCancel;
  final bool readOnly;

  const VitalSignsPage({
    super.key,
    required this.preWeightController,
    required this.postWeightController,
    required this.prePulseController,
    required this.midPulseController,
    required this.postPulseController,
    required this.preSystolicController,
    required this.midSystolicController,
    required this.postSystolicController,
    required this.preDiastolicController,
    required this.midDiastolicController,
    required this.postDiastolicController,
    required this.preTempController,
    required this.postTempController,
    required this.preSpo2Controller,
    required this.postSpo2Controller,
    this.onSave,
    this.onComplete,
    this.onNext,
    this.onCancel,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionCard(
            color: Colors.red.shade100,
            title: "Weight Management",
            icon: Icons.line_weight_outlined,
            children: [
              rowInput("Pre-Weight (kg)", controller: preWeightController, readOnly: readOnly),
              rowInput("Post-Weight (kg)", controller: postWeightController, readOnly: readOnly),
            ],
          ),
          sectionCard(
            color: Colors.greenAccent.shade100,
            title: "Heart Rate",
            icon: Icons.favorite,
            children: [
              rowInput("Pre-Pulse", controller: prePulseController, readOnly: readOnly),
              rowInput("Mid-Pulse", controller: midPulseController, readOnly: readOnly),
              rowInput("Post-Pulse", controller: postPulseController, readOnly: readOnly),
            ],
          ),
          sectionCard(
            color: Colors.blue.shade100,
            title: "Blood Pressure",
            icon: Icons.compress,
            children: [
              rowInput("Pre-Systolic", controller: preSystolicController, readOnly: readOnly),
              rowInput("Mid-Systolic", controller: midSystolicController, readOnly: readOnly),
              rowInput("Post-Systolic", controller: postSystolicController, readOnly: readOnly),
              rowInput("Pre-Diastolic", controller: preDiastolicController, readOnly: readOnly),
              rowInput("Mid-Diastolic", controller: midDiastolicController, readOnly: readOnly),
              rowInput("Post-Diastolic", controller: postDiastolicController, readOnly: readOnly),
            ],
          ),
          sectionCard(
            color: Colors.yellow.shade100,
            title: "Temperature & SpO₂",
            icon: Icons.local_fire_department,
            children: [
              rowInput("Pre-Temp (°C)", controller: preTempController, readOnly: readOnly),
              rowInput("Post-Temp (°C)", controller: postTempController, readOnly: readOnly),
              rowInput("Pre-SpO₂ (%)", controller: preSpo2Controller, readOnly: readOnly),
              rowInput("Post-SpO₂ (%)", controller: postSpo2Controller, readOnly: readOnly),
            ],
          ),
          const SizedBox(height: 20),
          actionButtons(context, onSave: onSave, onComplete: onComplete, onNext: onNext, onCancel: onCancel, readOnly: readOnly),
        ],
      ),
    );
  }
}
