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
          sectionTitle("Pre-Treatment Labs"),
          rowInput("BUN (mg/dL)"),
          rowInput("Creatinine (mg/dL)"),
          rowInput("Potassium (mEq/L)"),
          rowInput("Sodium (mEq/L)"),
          sectionTitle("Post-Treatment Labs"),
          rowInput("BUN (mg/dL)"),
          rowInput("Creatinine (mg/dL)"),
          rowInput("Potassium (mEq/L)"),
          rowInput("Sodium (mEq/L)"),
          actionButtons(context),
        ],
      ),
    );
  }
}
