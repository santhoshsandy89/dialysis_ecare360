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
              rowInput("Pre-Weight (kg)", controller: preWeightController),
              rowInput("Post-Weight (kg)", controller: postWeightController),
            ],
          ),
          sectionCard(
            color: Colors.greenAccent.shade100,
            title: "Heart Rate",
            icon: Icons.favorite,
            children: [
              rowInput("Pre-Pulse", controller: prePulseController),
              rowInput("Mid-Pulse", controller: midPulseController),
              rowInput("Post-Pulse", controller: postPulseController),
            ],
          ),
          sectionCard(
            color: Colors.blue.shade100,
            title: "Blood Pressure",
            icon: Icons.compress,
            children: [
              rowInput("Pre-Systolic", controller: preSystolicController),
              rowInput("Mid-Systolic", controller: midSystolicController),
              rowInput("Post-Systolic", controller: postSystolicController),
              rowInput("Pre-Diastolic", controller: preDiastolicController),
              rowInput("Mid-Diastolic", controller: midDiastolicController),
              rowInput("Post-Diastolic", controller: postDiastolicController),
            ],
          ),
          sectionCard(
            color: Colors.yellow.shade100,
            title: "Temperature & SpO₂",
            icon: Icons.local_fire_department,
            children: [
              rowInput("Pre-Temp (°C)", controller: preTempController),
              rowInput("Post-Temp (°C)", controller: postTempController),
              rowInput("Pre-SpO₂ (%)", controller: preSpo2Controller),
              rowInput("Post-SpO₂ (%)", controller: postSpo2Controller),
            ],
          ),
          const SizedBox(height: 20),
          actionButtons(context, onSave: onSave, onComplete: onComplete),
        ],
      ),
    );
  }
}
