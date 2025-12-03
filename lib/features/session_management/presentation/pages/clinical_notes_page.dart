import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:flutter/material.dart';

class ClinicalNotesPage extends StatelessWidget {
  const ClinicalNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "Machine Alarms",
              hintText: "Document any machine alarms...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "Nursing Interventions",
              hintText: "Document interventions performed...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: "Patient Tolerance",
              border: OutlineInputBorder(),
            ),
            items: ["Good", "Moderate", "Poor"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "Symptoms During Treatment",
              hintText: "Document any symptoms reported...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "Complications Details",
              hintText: "Document any complications...",
              border: OutlineInputBorder(),
            ),
          ),
          actionButtons(context),
        ],
      ),
    );
  }
}
