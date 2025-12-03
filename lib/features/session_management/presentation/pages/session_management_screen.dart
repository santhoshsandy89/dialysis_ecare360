import 'package:ecare360/data/models/patient_model.dart';
import 'package:ecare360/features/session_management/presentation/pages/clinical_notes_page.dart';
import 'package:ecare360/features/session_management/presentation/pages/laboratory_values_page.dart';
import 'package:ecare360/features/session_management/presentation/pages/treatment_parameters_page.dart';
import 'package:ecare360/features/session_management/presentation/pages/vital_signs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SessionManagementScreen extends StatefulWidget {
  final PatientModel patient;
  final String treatmentType;

  const SessionManagementScreen({
    super.key,
    required this.patient,
    required this.treatmentType,
  });

  @override
  State<SessionManagementScreen> createState() =>
      _SessionManagementScreenState();
}

class _SessionManagementScreenState extends State<SessionManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Dark Green
      ),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            toolbarHeight: 70,
            automaticallyImplyLeading: true,
            centerTitle: false,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Session Management",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.patient.firstName} • MRN: ${widget.patient.mrnNo} • ${widget.treatmentType} ",
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 8, bottom: 6),
                child: TabBar(
                  isScrollable: true,
                  labelColor: Theme.of(context).colorScheme.onPrimary,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: "Vital Signs"),
                    Tab(text: "Treatment Parameters"),
                    Tab(text: "Laboratory Values"),
                    Tab(text: "Clinical Notes"),
                  ],
                ),
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              VitalSignsPage(),
              TreatmentParametersPage(),
              LaboratoryValuesPage(),
              ClinicalNotesPage(),
            ],
          ),
        ),
      ),
    );
  }
}
