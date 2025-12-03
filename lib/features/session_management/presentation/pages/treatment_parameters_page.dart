import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:flutter/material.dart';

class TreatmentParametersPage extends StatelessWidget {
  const TreatmentParametersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.red.shade100,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  rowInput("Actual Blood Flow Rate (mL/min)"),
                  const SizedBox(height: 12),
                  rowInput("Total Blood Processed (mL)"),
                  const SizedBox(height: 12),
                  rowInput("Dialyzer Type"),
                  const SizedBox(height: 12),
                  rowInput("Arterial Pressure (mmHg)"),
                  const SizedBox(height: 12),
                  rowInput("Actual Dialysate Flow Rate (mL/min)"),
                  const SizedBox(height: 12),
                  rowInput("Heparin Bolus (units)"),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
                  rowInput("Venous Pressure (mmHg)"),
                  const SizedBox(height: 12),
                  rowInput("Actual Ultrafiltration (mL)"),
                  const SizedBox(height: 12),
                  rowInput("Heparin Rate (units/hr)"),
                  const SizedBox(height: 12),
                  rowInput("Needle Size (Gauge)"),
                  const SizedBox(height: 12),
                  rowInput("TMP (mmHg)"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          actionButtons(context),
        ],
      ),
    );
  }
}
