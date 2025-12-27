import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:flutter/material.dart';

class LaboratoryValuesPage extends StatefulWidget {
  final TextEditingController preBunController;
  final TextEditingController preCreatinineController;
  final TextEditingController prePotassiumController;
  final TextEditingController preSodiumController;
  final TextEditingController preHaemoglobinController;
  final TextEditingController preSGOTController;
  final TextEditingController preSGPTController;
  final TextEditingController postBunController;
  final TextEditingController postCreatinineController;
  final TextEditingController postPotassiumController;
  final TextEditingController postSodiumController;
  final TextEditingController postHaemoglobinController;
  final TextEditingController postSGOTController;
  final TextEditingController postSGPTController;
  final VoidCallback? onSave;
  final VoidCallback? onComplete;
  final VoidCallback? onNext;
  final VoidCallback? onCancel;
  final bool readOnly;

  // Serology Props
  final String hcv;
  final String hbsag;
  final String hiv;
  final String hcvRna;
  final String pcr;
  final ValueChanged<String?>? onHcvChanged;
  final ValueChanged<String?>? onHbsagChanged;
  final ValueChanged<String?>? onHivChanged;
  final ValueChanged<String?>? onHcvRnaChanged;
  final ValueChanged<String?>? onPcrChanged;

  const LaboratoryValuesPage({
    super.key,
    required this.preBunController,
    required this.preCreatinineController,
    required this.prePotassiumController,
    required this.preSodiumController,
    required this.preHaemoglobinController,
    required this.preSGOTController,
    required this.preSGPTController,
    required this.postBunController,
    required this.postCreatinineController,
    required this.postPotassiumController,
    required this.postSodiumController,
    required this.postHaemoglobinController,
    required this.postSGOTController,
    required this.postSGPTController,
    this.onSave,
    this.onComplete,
    this.onNext,
    this.onCancel,
    this.readOnly = false,
    this.hcv = '',
    this.hbsag = '',
    this.hiv = '',
    this.hcvRna = '',
    this.pcr = '',
    this.onHcvChanged,
    this.onHbsagChanged,
    this.onHivChanged,
    this.onHcvRnaChanged,
    this.onPcrChanged,
  });

  @override
  State<LaboratoryValuesPage> createState() => _LaboratoryValuesPageState();
}

class _LaboratoryValuesPageState extends State<LaboratoryValuesPage> {
  // Helpers to convert String <-> Enum
  BinaryResult? _parseBinary(String val) {
    if (val == 'Positive') return BinaryResult.positive;
    if (val == 'Negative') return BinaryResult.negative;
    return null;
  }

  String _binaryToString(BinaryResult? val) {
    if (val == BinaryResult.positive) return 'Positive';
    if (val == BinaryResult.negative) return 'Negative';
    return '';
  }

  ReactiveResult? _parseReactive(String val) {
    if (val == 'Reactive') return ReactiveResult.reactive;
    if (val == 'Non-Reactive') return ReactiveResult.nonReactive;
    return null;
  }

  String _reactiveToString(ReactiveResult? val) {
    if (val == ReactiveResult.reactive) return 'Reactive';
    if (val == ReactiveResult.nonReactive) return 'Non-Reactive';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionCard(
            color: Colors.red.shade100,
            title: "Pre-Treatment Labs",
            icon: Icons.preview_outlined,
            children: [
              rowInput("BUN (mg/dL)",
                  controller: widget.preBunController,
                  readOnly: widget.readOnly),
              rowInput("Creatinine (mg/dL)",
                  controller: widget.preCreatinineController,
                  readOnly: widget.readOnly),
              rowInput("Potassium (mEq/L)",
                  controller: widget.prePotassiumController,
                  readOnly: widget.readOnly),
              rowInput("Sodium (mEq/L)",
                  controller: widget.preSodiumController,
                  readOnly: widget.readOnly),
              rowInput("Haemoglobin (g/dL)",
                  controller: widget.preHaemoglobinController,
                  readOnly: widget.readOnly),
              rowInput("SGOT (U/L)",
                  controller: widget.preSGOTController,
                  readOnly: widget.readOnly),
              rowInput("SGPT (U/L)",
                  controller: widget.preSGPTController,
                  readOnly: widget.readOnly),
            ],
          ),
          sectionCard(
            color: Colors.greenAccent.shade100,
            title: "Post-Treatment Labs",
            icon: Icons.post_add_outlined,
            children: [
              rowInput("BUN (mg/dL)",
                  controller: widget.postBunController,
                  readOnly: widget.readOnly),
              rowInput("Creatinine (mg/dL)",
                  controller: widget.postCreatinineController,
                  readOnly: widget.readOnly),
              rowInput("Potassium (mEq/L)",
                  controller: widget.postPotassiumController,
                  readOnly: widget.readOnly),
              rowInput("Sodium (mEq/L)",
                  controller: widget.postSodiumController,
                  readOnly: widget.readOnly),
              rowInput("Haemoglobin (g/dL)",
                  controller: widget.postHaemoglobinController,
                  readOnly: widget.readOnly),
              rowInput("SGOT (U/L)",
                  controller: widget.postSGOTController,
                  readOnly: widget.readOnly),
              rowInput("SGPT (U/L)",
                  controller: widget.postSGPTController,
                  readOnly: widget.readOnly),
            ],
          ),
          sectionCard(
            color: Colors.blue.shade100,
            title: "Serology",
            icon: Icons.science,
            children: [
              Text(
                "HHH",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              resultRow<BinaryResult>(
                label: "HCV",
                value: _parseBinary(widget.hcv),
                options: BinaryResult.values,
                optionLabel: (v) => v == BinaryResult.positive ? "Positive" : "Negative",
                onChanged: widget.readOnly
                    ? (v) {}
                    : (v) => widget.onHcvChanged?.call(_binaryToString(v)),
              ),
              resultRow<BinaryResult>(
                label: "HBsAg",
                value: _parseBinary(widget.hbsag),
                options: BinaryResult.values,
                optionLabel: (v) => v == BinaryResult.positive ? "Positive" : "Negative",
                onChanged: widget.readOnly
                    ? (v) {}
                    : (v) => widget.onHbsagChanged?.call(_binaryToString(v)),
              ),
              resultRow<ReactiveResult>(
                label: "HIV",
                value: _parseReactive(widget.hiv),
                options: ReactiveResult.values,
                optionLabel: (v) =>
                    v == ReactiveResult.reactive ? "Reactive" : "Non-Reactive",
                onChanged: widget.readOnly
                    ? (v) {}
                    : (v) => widget.onHivChanged?.call(_reactiveToString(v)),
              ),
              resultRow<ReactiveResult>(
                label: "HCV RNA",
                value: _parseReactive(widget.hcvRna),
                options: ReactiveResult.values,
                optionLabel: (v) =>
                    v == ReactiveResult.reactive ? "Reactive" : "Non-Reactive",
                onChanged: widget.readOnly
                    ? (v) {}
                    : (v) => widget.onHcvRnaChanged?.call(_reactiveToString(v)),
              ),
              resultRow<ReactiveResult>(
                label: "PCR",
                value: _parseReactive(widget.pcr),
                options: ReactiveResult.values,
                optionLabel: (v) =>
                    v == ReactiveResult.reactive ? "Reactive" : "Non-Reactive",
                onChanged: widget.readOnly
                    ? (v) {}
                    : (v) => widget.onPcrChanged?.call(_reactiveToString(v)),
              ),
            ],
          ),
          const SizedBox(height: 20),
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

  Widget resultRow<T>({
    required String label,
    required T? value,
    required List<T> options,
    required String Function(T) optionLabel,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Row(
          children: options.map((o) {
            return Expanded(
              child: RadioListTile<T>(
                dense: true,
                title: Text(optionLabel(o)),
                value: o,
                groupValue: value,
                onChanged: onChanged, // MUST NOT be null
              ),
            );
          }).toList(),
        ),
        const Divider(),
      ],
    );
  }
}

enum BinaryResult { positive, negative }

enum ReactiveResult { reactive, nonReactive }
