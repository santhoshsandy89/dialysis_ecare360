import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:ecare360/data/models/session_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart'; // For firstWhereOrNull
import 'package:ecare360/features/session_management/presentation/providers/serology_provider.dart';

class LaboratoryValuesPage extends ConsumerStatefulWidget {
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
  final Function(LaboratoryValues) onLaboratoryValuesChanged;
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
    required this.onLaboratoryValuesChanged,
    this.onSave,
    this.onComplete,
    this.onNext,
    this.onCancel,
    this.readOnly = false,
  });

  @override
  ConsumerState<LaboratoryValuesPage> createState() =>
      _LaboratoryValuesPageState();
}

class _LaboratoryValuesPageState extends ConsumerState<LaboratoryValuesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Initial loading of Serology results will be handled by the provider itself
  }

  void _updateSerologyValue<T>(String key, T? value) {
    final serologyNotifier = ref.read(serologyProvider.notifier);
    serologyNotifier.updateSerologyResult(key, value?.toString());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final serologyResults = ref.watch(serologyProvider);

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
                value: BinaryResult.values.firstWhereOrNull((e) =>
                    e.toString() == serologyResults.hcvResult), // Use firstWhereOrNull
                options: BinaryResult.values,
                optionLabel: (v) => v == BinaryResult.positive ? "+ve" : "-ve",
                onChanged: widget.readOnly
                    ? null
                    : (v) => _updateSerologyValue('hcvResult', v),
              ),
              resultRow<BinaryResult>(
                label: "HBsAg",
                value: BinaryResult.values.firstWhereOrNull((e) =>
                    e.toString() == serologyResults.hbsagResult),
                options: BinaryResult.values,
                optionLabel: (v) => v == BinaryResult.positive ? "+ve" : "-ve",
                onChanged: widget.readOnly
                    ? null
                    : (v) => _updateSerologyValue('hbsagResult', v),
              ),
              resultRow<ReactiveResult>(
                label: "HIV",
                value: ReactiveResult.values.firstWhereOrNull((e) =>
                    e.toString() == serologyResults.hivResult),
                options: ReactiveResult.values,
                optionLabel: (v) =>
                    v == ReactiveResult.reactive ? "Reactive" : "Non-Reactive",
                onChanged: widget.readOnly
                    ? null
                    : (v) => _updateSerologyValue('hivResult', v),
              ),
              resultRow<ReactiveResult>(
                label: "HCV RNA",
                value: ReactiveResult.values.firstWhereOrNull((e) =>
                    e.toString() == serologyResults.hcvRnaResult),
                options: ReactiveResult.values,
                optionLabel: (v) =>
                    v == ReactiveResult.reactive ? "Reactive" : "Non-Reactive",
                onChanged: widget.readOnly
                    ? null
                    : (v) => _updateSerologyValue('hcvRnaResult', v),
              ),
              resultRow<ReactiveResult>(
                label: "PCR",
                value: ReactiveResult.values.firstWhereOrNull((e) =>
                    e.toString() == serologyResults.pcrResult),
                options: ReactiveResult.values,
                optionLabel: (v) =>
                    v == ReactiveResult.reactive ? "Reactive" : "Non-Reactive",
                onChanged: widget.readOnly
                    ? null
                    : (v) => _updateSerologyValue('pcrResult', v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          actionButtons(context, onSave: () {
            final currentSerologyResults = ref.read(serologyProvider);
            final laboratoryValues = LaboratoryValues(
              preBun: widget.preBunController.text,
              preCreatinine: widget.preCreatinineController.text,
              prePotassium: widget.prePotassiumController.text,
              preSodium: widget.preSodiumController.text,
              preHaemoglobin: widget.preHaemoglobinController.text,
              preSGOT: widget.preSGOTController.text,
              preSGPT: widget.preSGPTController.text,
              postBun: widget.postBunController.text,
              postCreatinine: widget.postCreatinineController.text,
              postPotassium: widget.postPotassiumController.text,
              postSodium: widget.postSodiumController.text,
              postHaemoglobin: widget.postHaemoglobinController.text,
              postSGOT: widget.postSGOTController.text,
              postSGPT: widget.postSGPTController.text,
              serologyResults: currentSerologyResults,
            );
            widget.onLaboratoryValuesChanged(laboratoryValues);
            widget.onSave?.call();
          }, onComplete: () {
            final currentSerologyResults = ref.read(serologyProvider);
            final laboratoryValues = LaboratoryValues(
              preBun: widget.preBunController.text,
              preCreatinine: widget.preCreatinineController.text,
              prePotassium: widget.postPotassiumController.text, // Corrected to use postPotassiumController
              preSodium: widget.postSodiumController.text, // Corrected to use postSodiumController
              preHaemoglobin: widget.preHaemoglobinController.text,
              preSGOT: widget.preSGOTController.text,
              preSGPT: widget.preSGPTController.text,
              postBun: widget.postBunController.text,
              postCreatinine: widget.postCreatinineController.text,
              postPotassium: widget.postPotassiumController.text,
              postSodium: widget.postSodiumController.text,
              postHaemoglobin: widget.postHaemoglobinController.text,
              postSGOT: widget.postSGOTController.text,
              postSGPT: widget.postSGPTController.text,
              serologyResults: currentSerologyResults,
            );
            widget.onLaboratoryValuesChanged(laboratoryValues);
            widget.onComplete?.call();
          },
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
    required void Function(T?)? onChanged, // Make onChanged nullable
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
                onChanged: onChanged,
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
