import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:flutter/material.dart';

class LaboratoryValuesPage extends StatelessWidget {
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

  const LaboratoryValuesPage(
      {super.key,
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
      this.onCancel});

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
              rowInput("BUN (mg/dL)", controller: preBunController),
              rowInput("Creatinine (mg/dL)",
                  controller: preCreatinineController),
              rowInput("Potassium (mEq/L)", controller: prePotassiumController),
              rowInput("Sodium (mEq/L)", controller: preSodiumController),
              rowInput("Haemoglobin (HB)",
                  controller: preHaemoglobinController),
              rowInput("SGOT", controller: preSGOTController),
              rowInput("SGPT", controller: preSGPTController),
            ],
          ),
          sectionCard(
            color: Colors.greenAccent.shade100,
            title: "Post-Treatment Labs",
            icon: Icons.post_add_outlined,
            children: [
              rowInput("BUN (mg/dL)", controller: postBunController),
              rowInput("Creatinine (mg/dL)",
                  controller: postCreatinineController),
              rowInput("Potassium (mEq/L)",
                  controller: postPotassiumController),
              rowInput("Sodium (mEq/L)", controller: postSodiumController),
              rowInput("Haemoglobin (HB)",
                  controller: postHaemoglobinController),
              rowInput("SGOT", controller: postSGOTController),
              rowInput("SGPT", controller: postSGPTController),
            ],
          ),
          const SizedBox(height: 20),
          actionButtons(
            context,
            onCancel: onCancel,
            onSave: onSave,
            onComplete: onComplete,
            onNext: onNext,
          )
        ],
      ),
    );
  }
}
