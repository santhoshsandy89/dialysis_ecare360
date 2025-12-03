import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:flutter/material.dart';

class LaboratoryValuesPage extends StatelessWidget {
  const LaboratoryValuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionCard(
            color: Colors.red.shade100,
            title: "Pre-Treatment Labs",
            icon: Icons.preview_outlined,
            children: [
              rowInput("BUN (mg/dL)"),
              rowInput("Creatinine (mg/dL)"),
              rowInput("Potassium (mEq/L)"),
              rowInput("Sodium (mEq/L)"),
            ],
          ),
          sectionCard(
            color: Colors.greenAccent.shade100,
            title: "Post-Treatment Labs",
            icon: Icons.post_add_outlined,
            children: [
              rowInput("BUN (mg/dL)"),
              rowInput("Creatinine (mg/dL)"),
              rowInput("Potassium (mEq/L)"),
              rowInput("Sodium (mEq/L)"),
            ],
          ),
          const SizedBox(height: 20),
          actionButtons(context),
        ],
      ),
    );
  }
}
