import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:flutter/material.dart';

class TreatmentParametersPage extends StatelessWidget {
  const TreatmentParametersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowInput("Actual Blood Flow Rate (mL/min)"),
          rowInput("Total Blood Processed (mL)"),
          rowInput("Dialyzer Type"),
          rowInput("Arterial Pressure (mmHg)"),
          rowInput("Actual Dialysate Flow Rate (mL/min)"),
          rowInput("Heparin Bolus (units)"),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: "Access Condition",
              border: OutlineInputBorder(),
            ),
            items: ["Good", "Fair", "Poor"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (_) {},
          ),
          const SizedBox(height: 14),
          rowInput("Venous Pressure (mmHg)"),
          rowInput("Actual Ultrafiltration (mL)"),
          rowInput("Heparin Rate (units/hr)"),
          rowInput("Needle Size (Gauge)"),
          rowInput("TMP (mmHg)"),
          actionButtons(context),
        ],
      ),
    );
  }
}
