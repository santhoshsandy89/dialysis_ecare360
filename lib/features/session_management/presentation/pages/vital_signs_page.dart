import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:flutter/material.dart';

class VitalSignsPage extends StatelessWidget {
  const VitalSignsPage({super.key});

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
              rowInput("Pre-Weight (kg)"),
              rowInput("Post-Weight (kg)"),
            ],
          ),
          sectionCard(
            color: Colors.greenAccent.shade100,
            title: "Heart Rate",
            icon: Icons.favorite,
            children: [
              rowInput("Pre-Pulse"),
              rowInput("Mid-Pulse"),
              rowInput("Post-Pulse"),
            ],
          ),
          sectionCard(
            color: Colors.blue.shade100,
            title: "Blood Pressure",
            icon: Icons.compress,
            children: [
              rowInput("Pre-Systolic"),
              rowInput("Mid-Systolic"),
              rowInput("Post-Systolic"),
              rowInput("Pre-Diastolic"),
              rowInput("Mid-Diastolic"),
              rowInput("Post-Diastolic"),
            ],
          ),
          sectionCard(
            color: Colors.yellow.shade100,
            title: "Temperature & SpO₂",
            icon: Icons.local_fire_department,
            children: [
              rowInput("Pre-Temp (°C)"),
              rowInput("Post-Temp (°C)"),
              rowInput("Pre-SpO₂ (%)"),
              rowInput("Post-SpO₂ (%)"),
            ],
          ),
          const SizedBox(height: 20),
          actionButtons(context),
        ],
      ),
    );
  }
}
