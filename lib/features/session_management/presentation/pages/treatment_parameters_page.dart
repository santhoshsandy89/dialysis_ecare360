import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:ecare360/data/models/session_data_model.dart';
import 'package:ecare360/features/schedule_treatment/presentation/pages/schedule_treatment_screen.dart';
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
  final List<BloodPressureEntry> initialBpEntries;
  final Function(List<BloodPressureEntry>) onBpEntriesChanged;
  final VoidCallback? onSave;
  final VoidCallback? onComplete;
  final VoidCallback? onNext;
  final VoidCallback? onCancel;
  final bool readOnly;
  final TreatmentMainType? treatmentType;

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
    required this.initialBpEntries,
    required this.onBpEntriesChanged,
    this.onSave,
    this.onComplete,
    this.onNext,
    this.onCancel,
    this.readOnly = false,
    this.treatmentType,
  });

  @override
  State<TreatmentParametersPage> createState() =>
      _TreatmentParametersPageState();
}

class _TreatmentParametersPageState extends State<TreatmentParametersPage>
    with AutomaticKeepAliveClientMixin {
  List<BPEntry> bpEntries = [];
  bool _isInitializedFromParent = false;

  /*@override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bpEntries.isEmpty && widget.initialBpEntries.isEmpty) {
        _addHour();
      }
    });
  }*/

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialBpEntries.isNotEmpty) {
        // Restore from existing entries
        setState(() {
          if (widget.treatmentType == TreatmentMainType.slud) {
            _restoreSludEntries(widget.initialBpEntries);
            _isInitializedFromParent = true;
          } else {
            _initializeBPEntriesFromPreferences(widget.initialBpEntries);
            _isInitializedFromParent = true;
          }
        });
      } else if (bpEntries.isEmpty) {
        // Initialize default empty rows
        final int totalHours = (widget.treatmentType != null &&
                widget.treatmentType == TreatmentMainType.slud)
            ? 6
            : 1;
        _addMultipleHours(totalHours);
      }
    });
  }

  @override
  void didUpdateWidget(covariant TreatmentParametersPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_isInitializedFromParent || widget.initialBpEntries.isEmpty) return;

    for (var entry in bpEntries) {
      entry.controller.dispose();
    }

    setState(() {
      if (widget.treatmentType == TreatmentMainType.slud) {
        _restoreSludEntries(widget.initialBpEntries);
      } else {
        _initializeBPEntriesFromPreferences(widget.initialBpEntries);
      }

      _isInitializedFromParent = true;
    });
  }

  /*@override
  void didUpdateWidget(covariant TreatmentParametersPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isInitializedFromParent && widget.initialBpEntries.isNotEmpty) {
      for (var entry in bpEntries) {
        entry.controller.dispose();
      }

      setState(() {
        bpEntries = _buildFullBpGrid(widget.initialBpEntries);
        _isInitializedFromParent = true;
      });
    }
  }*/

  @override
  void dispose() {
    for (var entry in bpEntries) {
      entry.controller.dispose();
    }
    super.dispose();
  }

  void _addHour() {
    setState(() {
      final int currentMinutes = bpEntries.isEmpty ? 0 : bpEntries.last.minutes;
      for (int i = 0; i < 4; i++) {
        int minutes = currentMinutes + ((i + 1) * 15);
        if (minutes <= 24 * 60) {
          bpEntries.add(BPEntry(minutes, null, _notifyBpEntriesChanged));
        }
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifyBpEntriesChanged();
      });
    });
  }

  void _initializeBPEntriesFromPreferences(
    List<BloodPressureEntry> savedEntries,
  ) {
    bpEntries.clear();

    if (savedEntries.isEmpty) return;

    final Map<int, String?> valueByMinute = {
      for (var e in savedEntries) e.time: e.bpValue,
    };

    final int maxMinute =
        savedEntries.map((e) => e.time).reduce((a, b) => a > b ? a : b);

    for (int minute = 15; minute <= maxMinute; minute += 15) {
      bpEntries.add(
        BPEntry(
          minute,
          valueByMinute[minute],
          _notifyBpEntriesChanged,
        ),
      );
    }
  }

  void _removeHour(int startIndex) {
    setState(() {
      bpEntries.removeRange(startIndex, startIndex + 4);
      _notifyBpEntriesChanged();
    });
  }

  void _notifyBpEntriesChanged() {
    final List<BloodPressureEntry> currentEntries = bpEntries
        .map(
          (e) => BloodPressureEntry(
            time: e.minutes,
            bpValue: e.controller.text,
          ),
        )
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onBpEntriesChanged(currentEntries);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 300),
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
                      if (!widget
                          .readOnly) // Only show add hour if not read-only
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
                      readOnly: widget.readOnly,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  rowInput("Total Blood Processed (mL)",
                      controller: widget.totalBloodProcessedController,
                      readOnly: widget.readOnly,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  rowInput("Dialyzer Type",
                      controller: widget.dialyzerTypeController,
                      readOnly: widget.readOnly),
                  const SizedBox(height: 12),
                  rowInput("Arterial Pressure (mmHg)",
                      controller: widget.arterialPressureController,
                      readOnly: widget.readOnly,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  rowInput("Actual Dialysate Flow Rate (mL/min)",
                      controller: widget.actualDialysateFlowRateController,
                      readOnly: widget.readOnly,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  rowInput("Heparin Bolus (units)",
                      controller: widget.heparinBolusController,
                      readOnly: widget.readOnly,
                      keyboardType: TextInputType.number),
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
                      readOnly: widget.readOnly,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  rowInput("Actual Ultrafiltration (mL)",
                      controller: widget.actualUltrafiltrationController,
                      readOnly: widget.readOnly,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  rowInput("Heparin Rate (units/hr)",
                      controller: widget.heparinRateController,
                      readOnly: widget.readOnly,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  rowInput("Needle Size (Gauge)",
                      controller: widget.needleSizeController,
                      readOnly: widget.readOnly,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  rowInput("TMP (mmHg)",
                      controller: widget.tmpController,
                      readOnly: widget.readOnly,
                      keyboardType: TextInputType.number),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          actionButtons(context, onSave: () {
            _notifyBpEntriesChanged();
            widget.onSave?.call();
          }, onComplete: () {
            _notifyBpEntriesChanged();
            widget.onComplete?.call();
          },
              onNext: widget.onNext,
              onCancel: widget.onCancel,
              readOnly: widget.readOnly),
        ],
      ),
    );
  }

  List<Widget> _buildBPFields() {
    final List<Widget> widgets = [];

    for (int i = 0; i < bpEntries.length; i += 4) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hour ${(i ~/ 4) + 1}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (!widget.readOnly) // Only show remove button if not read-only
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.red),
                  onPressed: () => _removeHour(i),
                ),
            ],
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
                  isBPField: true,
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

  @override
  bool get wantKeepAlive => true;

  List<BPEntry> _buildFullBpGrid(List<BloodPressureEntry> savedEntries) {
    final Map<int, String> valueByMinute = {
      for (var e in savedEntries) e.time: e.bpValue,
    };

    final int maxMinute =
        savedEntries.map((e) => e.time).reduce((a, b) => a > b ? a : b);

    final List<BPEntry> result = [];

    for (int minute = 15; minute <= maxMinute; minute += 15) {
      result.add(
        BPEntry(
          minute,
          valueByMinute[minute],
          _notifyBpEntriesChanged,
        ),
      );
    }

    return result;
  }

  void _addMultipleHours(int hours) {
    setState(() {
      int startMinutes = bpEntries.isEmpty ? 0 : bpEntries.last.minutes;
      for (int h = 0; h < hours; h++) {
        for (int i = 1; i <= 4; i++) {
          int minutes = startMinutes + (h * 60) + (i * 15);
          bpEntries.add(
            BPEntry(minutes, null, _notifyBpEntriesChanged),
          );
        }
      }
    });
  }

  void _restoreSludEntries(List<BloodPressureEntry> savedEntries) {
    // Always build full 6×4 grid
    bpEntries.clear();

    for (int i = 1; i <= 24; i++) {
      bpEntries.add(
        BPEntry(i * 15, null, _notifyBpEntriesChanged),
      );
    }

    // Map saved values
    final Map<int, String?> valueByMinute = {
      for (var e in savedEntries) e.time: e.bpValue,
    };

    // Patch values into existing controllers
    for (var entry in bpEntries) {
      if (valueByMinute.containsKey(entry.minutes)) {
        entry.controller.text = valueByMinute[entry.minutes]!;
      }
    }
  }
}

class BPEntry {
  final int minutes;
  final TextEditingController controller;

  BPEntry(this.minutes, [String? initialValue, VoidCallback? onChanged])
      : controller = TextEditingController(text: initialValue) {
    if (onChanged != null) {
      controller.addListener(onChanged);
    }
  }
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
