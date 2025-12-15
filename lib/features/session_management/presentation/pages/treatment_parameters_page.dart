import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:ecare360/data/models/session_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecare360/features/session_management/presentation/providers/bp_entry_list_provider.dart';
import 'package:flutter/services.dart';

class TreatmentParametersPage extends ConsumerStatefulWidget {
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
  });

  @override
  ConsumerState<TreatmentParametersPage> createState() =>
      _TreatmentParametersPageState();
}

class _TreatmentParametersPageState
    extends ConsumerState<TreatmentParametersPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Map<String, TextEditingController> _bpEntryControllers = {};

  @override
  void initState() {
    super.initState();
    // Initial setup handled by Riverpod and _addInitialHours if needed
  }

  @override
  void dispose() {
    _bpEntryControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _addHour(WidgetRef ref) {
    final bpEntryListNotifier = ref.read(bpEntryListProvider.notifier);
    final currentBpEntries = ref.read(bpEntryListProvider);
    final int currentMinutes = currentBpEntries.length * 15;

    List<BloodPressureEntry> newEntries = [];
    for (int i = 0; i < 4; i++) {
      int minutes = currentMinutes + ((i + 1) * 15);
      if (minutes <= 24 * 60) {
        newEntries
            .add(BloodPressureEntry(time: "$minutes min BP", bpValue: ""));
      }
    }
    bpEntryListNotifier.setBpEntries([...currentBpEntries, ...newEntries]);
  }

  void _removeHour(WidgetRef ref, int startIndex) {
    final bpEntryListNotifier = ref.read(bpEntryListProvider.notifier);
    final currentBpEntries =
        List<BloodPressureEntry>.from(ref.read(bpEntryListProvider));
    currentBpEntries.removeRange(startIndex, startIndex + 4);
    bpEntryListNotifier.setBpEntries(currentBpEntries);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final bpEntries = ref.watch(bpEntryListProvider);
    final bpEntryListNotifier = ref.read(bpEntryListProvider.notifier);

    // If initialBpEntries are provided and the Riverpod state is empty,
    // populate the Riverpod state. This handles the initial load from existing session data.
    if (widget.initialBpEntries.isNotEmpty && bpEntries.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        bpEntryListNotifier.setBpEntries(widget.initialBpEntries);
      });
    }

    if (bpEntries.isEmpty && !widget.readOnly) {
      // Only add initial hour if no data and not read-only
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _addHour(ref);
      });
    }

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
                      ..._buildBPFields(ref, bpEntries),
                      const SizedBox(height: 12),
                      if (!widget
                          .readOnly) // Only show add hour if not read-only
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text("Add Hour"),
                            onPressed: () => _addHour(ref),
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
            final bpEntries = ref.read(bpEntryListProvider);
            widget.onBpEntriesChanged(bpEntries);
            widget.onSave?.call();
          }, onComplete: () {
            final bpEntries = ref.read(bpEntryListProvider);
            widget.onBpEntriesChanged(bpEntries);
            widget.onComplete?.call();
          },
              onNext: widget.onNext,
              onCancel: widget.onCancel,
              readOnly: widget.readOnly),
        ],
      ),
    );
  }

  List<Widget> _buildBPFields(WidgetRef ref, List<BloodPressureEntry> bpEntries) {
    final List<Widget> widgets = [];
    final bpEntryListNotifier = ref.read(bpEntryListProvider.notifier);

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
                  onPressed: () => _removeHour(ref, i),
                ),
            ],
          ),
        ),
      );

      List<Widget> rowChildren = [];
      for (int j = 0; j < 4; j++) {
        if (i + j < bpEntries.length) {
          final entry = bpEntries[i + j];
          final controller = _bpEntryControllers.putIfAbsent(
              entry.time,
              () => TextEditingController(
                  text: entry.bpValue)); // Ensure unique key for controller

          controller.addListener(() {
            final updatedEntry = BloodPressureEntry(
              time: entry.time,
              bpValue: controller.text,
            );
            bpEntryListNotifier.updateBpEntry(i + j, updatedEntry);
          });

          rowChildren.add(
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: rowInput(
                  entry.time,
                  controller: controller,
                  readOnly: widget.readOnly,
                  isBPField: true,
                  hintText: "120/80",
                  inputFormatters: [BPFormatter()],
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
