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
  });

  @override
  State<LaboratoryValuesPage> createState() => _LaboratoryValuesPageState();
}

class _LaboratoryValuesPageState extends State<LaboratoryValuesPage> {
  BinaryResult? hcvResult;
  BinaryResult? hbsagResult;
  ReactiveResult? hivResult;
  ReactiveResult? hcvRnaResult;
  ReactiveResult? pcrResult;

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
                value: hcvResult,
                options: BinaryResult.values,
                optionLabel: (v) => v == BinaryResult.positive ? "+ve" : "-ve",
                onChanged: (v) => setState(() => hcvResult = v),
              ),
              resultRow<BinaryResult>(
                label: "HBsAg",
                value: hbsagResult,
                options: BinaryResult.values,
                optionLabel: (v) => v == BinaryResult.positive ? "+ve" : "-ve",
                onChanged: (v) => setState(() => hbsagResult = v),
              ),
              resultRow<ReactiveResult>(
                label: "HIV",
                value: hivResult,
                options: ReactiveResult.values,
                optionLabel: (v) =>
                    v == ReactiveResult.reactive ? "Reactive" : "Non-Reactive",
                onChanged: (v) => setState(() => hivResult = v),
              ),
              resultRow<ReactiveResult>(
                label: "HCV RNA",
                value: hcvRnaResult,
                options: ReactiveResult.values,
                optionLabel: (v) =>
                    v == ReactiveResult.reactive ? "Reactive" : "Non-Reactive",
                onChanged: (v) => setState(() => hcvRnaResult = v),
              ),
              resultRow<ReactiveResult>(
                label: "PCR",
                value: pcrResult,
                options: ReactiveResult.values,
                optionLabel: (v) =>
                    v == ReactiveResult.reactive ? "Reactive" : "Non-Reactive",
                onChanged: (v) => setState(() => pcrResult = v),
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
