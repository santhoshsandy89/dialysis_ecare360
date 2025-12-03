import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:flutter/material.dart';

class TreatmentParametersPage extends StatelessWidget {
  final TextEditingController actualBloodFlowRateController;
  final TextEditingController totalBloodProcessedController;
  final TextEditingController dialyzerTypeController;
  final TextEditingController arterialPressureController;
  final TextEditingController actualDialysateFlowRateController;
  final TextEditingController heparinBolusController;
  final TextEditingController venousPressureController;
  final TextEditingController actualUltrafiltrationController;
  final TextEditingController heparinRateController;
  final TextEditingController needleSizeController;
  final TextEditingController tmpController;
  final VoidCallback? onSave;
  final VoidCallback? onComplete;

  const TreatmentParametersPage({
    super.key,
    required this.actualBloodFlowRateController,
    required this.totalBloodProcessedController,
    required this.dialyzerTypeController,
    required this.arterialPressureController,
    required this.actualDialysateFlowRateController,
    required this.heparinBolusController,
    required this.venousPressureController,
    required this.actualUltrafiltrationController,
    required this.heparinRateController,
    required this.needleSizeController,
    required this.tmpController,
    this.onSave,
    this.onComplete,
  });

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
                  rowInput("Actual Blood Flow Rate (mL/min)",
                      controller: actualBloodFlowRateController),
                  const SizedBox(height: 12),
                  rowInput("Total Blood Processed (mL)",
                      controller: totalBloodProcessedController),
                  const SizedBox(height: 12),
                  rowInput("Dialyzer Type", controller: dialyzerTypeController),
                  const SizedBox(height: 12),
                  rowInput("Arterial Pressure (mmHg)",
                      controller: arterialPressureController),
                  const SizedBox(height: 12),
                  rowInput("Actual Dialysate Flow Rate (mL/min)",
                      controller: actualDialysateFlowRateController),
                  const SizedBox(height: 12),
                  rowInput("Heparin Bolus (units)",
                      controller: heparinBolusController),
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
                  rowInput("Venous Pressure (mmHg)",
                      controller: venousPressureController),
                  const SizedBox(height: 12),
                  rowInput("Actual Ultrafiltration (mL)",
                      controller: actualUltrafiltrationController),
                  const SizedBox(height: 12),
                  rowInput("Heparin Rate (units/hr)",
                      controller: heparinRateController),
                  const SizedBox(height: 12),
                  rowInput("Needle Size (Gauge)",
                      controller: needleSizeController),
                  const SizedBox(height: 12),
                  rowInput("TMP (mmHg)", controller: tmpController),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          actionButtons(context, onSave: onSave, onComplete: onComplete),
        ],
      ),
    );
  }
}
