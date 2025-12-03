import 'package:ecare360/common/widgets/helper_widget.dart';
import 'package:flutter/material.dart';

class LaboratoryValuesPage extends StatelessWidget {
  final TextEditingController preBunController;
  final TextEditingController preCreatinineController;
  final TextEditingController prePotassiumController;
  final TextEditingController preSodiumController;
  final TextEditingController postBunController;
  final TextEditingController postCreatinineController;
  final TextEditingController postPotassiumController;
  final TextEditingController postSodiumController;

  const LaboratoryValuesPage({
    super.key,
    required this.preBunController,
    required this.preCreatinineController,
    required this.prePotassiumController,
    required this.preSodiumController,
    required this.postBunController,
    required this.postCreatinineController,
    required this.postPotassiumController,
    required this.postSodiumController,
  });

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
              rowInput("Creatinine (mg/dL)", controller: preCreatinineController),
              rowInput("Potassium (mEq/L)", controller: prePotassiumController),
              rowInput("Sodium (mEq/L)", controller: preSodiumController),
            ],
          ),
          sectionCard(
            color: Colors.greenAccent.shade100,
            title: "Post-Treatment Labs",
            icon: Icons.post_add_outlined,
            children: [
              rowInput("BUN (mg/dL)", controller: postBunController),
              rowInput("Creatinine (mg/dL)", controller: postCreatinineController),
              rowInput("Potassium (mEq/L)", controller: postPotassiumController),
              rowInput("Sodium (mEq/L)", controller: postSodiumController),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
