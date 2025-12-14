import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TreatmentParametersPage extends StatefulWidget {
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
  final VoidCallback? onNext;
  final VoidCallback? onCancel;
  final bool readOnly;

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
    this.onNext,
    this.onCancel,
    this.readOnly = false,
  });

  @override
  State<TreatmentParametersPage> createState() =>
      _TreatmentParametersPageState();
}

class _TreatmentParametersPageState extends State<TreatmentParametersPage> {
  List<BPEntry> bpEntries = [];
  int hoursAdded = 1;

  @override
  void initState() {
    super.initState();
    _addHour();
  }

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
                  sectionCard(
                    color: Colors.orange.shade100,
                    title: "Blood Pressure Monitoring",
                    icon: Icons.monitor_heart,
                    children: [
                      ..._buildBPFields(),
                      const SizedBox(height: 12),
                      if (hoursAdded < 24) // allow long sessions
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text("Add Hour"),
                            onPressed: _addHour,
                          ),
                        ),
                    ],
                  ),
                  rowInput("Actual Blood Flow Rate (mL/min)",
                      controller: widget.actualBloodFlowRateController,
                      readOnly: widget.readOnly),
                  const SizedBox(height: 12),
                  rowInput("Total Blood Processed (mL)",
                      controller: widget.totalBloodProcessedController,
                      readOnly: widget.readOnly),
                  const SizedBox(height: 12),
                  rowInput("Dialyzer Type",
                      controller: widget.dialyzerTypeController,
                      readOnly: widget.readOnly),
                  const SizedBox(height: 12),
                  rowInput("Arterial Pressure (mmHg)",
                      controller: widget.arterialPressureController,
                      readOnly: widget.readOnly),
                  const SizedBox(height: 12),
                  rowInput("Actual Dialysate Flow Rate (mL/min)",
                      controller: widget.actualDialysateFlowRateController,
                      readOnly: widget.readOnly),
                  const SizedBox(height: 12),
                  rowInput("Heparin Bolus (units)",
                      controller: widget.heparinBolusController,
                      readOnly: widget.readOnly),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: "Access Condition",
                      border: OutlineInputBorder(),
                    ),
                    items: ["Good", "Fair", "Poor"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: widget.readOnly ? null : (_) {},
                  ),
                  const SizedBox(height: 12),
                  rowInput("Venous Pressure (mmHg)",
                      controller: widget.venousPressureController,
                      readOnly: widget.readOnly),
                  const SizedBox(height: 12),
                  rowInput("Actual Ultrafiltration (mL)",
                      controller: widget.actualUltrafiltrationController,
                      readOnly: widget.readOnly),
                  const SizedBox(height: 12),
                  rowInput("Heparin Rate (units/hr)",
                      controller: widget.heparinRateController,
                      readOnly: widget.readOnly),
                  const SizedBox(height: 12),
                  rowInput("Needle Size (Gauge)",
                      controller: widget.needleSizeController,
                      readOnly: widget.readOnly),
                  const SizedBox(height: 12),
                  rowInput("TMP (mmHg)",
                      controller: widget.tmpController,
                      readOnly: widget.readOnly),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          actionButtons(context,
              onSave: widget.onSave,
              onComplete: widget.onComplete,
              onNext: widget.onNext,
              onCancel: widget.onCancel,
              readOnly: widget.readOnly),
        ],
      ),
    );
  }

  void _addHour() {
    final startMinute = bpEntries.length * 15;

    for (int i = 1; i <= 4; i++) {
      bpEntries.add(BPEntry(startMinute + i * 15));
    }

    setState(() {
      hoursAdded++;
    });
  }

  List<Widget> _buildBPFields() {
    final List<Widget> widgets = [];

    for (int i = 0; i < bpEntries.length; i += 4) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Text(
            "Hour ${(i ~/ 4) + 1}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );

      List<Widget> rowChildren = [];
      for (int j = 0; j < 4; j++) {
        if (i + j < bpEntries.length) {
          rowChildren.add(
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: rowInput(
                  "${bpEntries[i + j].minutes} min BP",
                  controller: bpEntries[i + j].controller,
                  readOnly: widget.readOnly,
                  keyboardType: TextInputType.number,
                  inputFormatters: [BPFormatter()],
                  hintText: "120/80",
                ),
              ),
            ),
          );
        } else {
          rowChildren.add(const Expanded(child: SizedBox()));
        }
      }

      widgets.add(Row(children: rowChildren));
    }

    return widgets;
  }
}

class BPEntry {
  final int minutes;
  final TextEditingController controller;

  BPEntry(this.minutes) : controller = TextEditingController();
}

class BPFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', '');

    if (text.length > 5) text = text.substring(0, 5);

    if (text.length >= 4) {
      if (text.length == 4) {
        text = '${text.substring(0, 2)}/${text.substring(2)}';
      } else {
        text = '${text.substring(0, 3)}/${text.substring(3)}';
      }
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
