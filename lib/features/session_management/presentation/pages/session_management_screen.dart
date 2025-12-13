import 'package:ecare360/data/models/patient_model.dart';
import 'package:ecare360/data/models/session_data_model.dart';
import 'package:ecare360/data/services/local_storage_service.dart';
import 'package:ecare360/features/session_management/presentation/pages/clinical_notes_page.dart';
import 'package:ecare360/features/session_management/presentation/pages/laboratory_values_page.dart';
import 'package:ecare360/features/session_management/presentation/pages/treatment_parameters_page.dart';
import 'package:ecare360/features/session_management/presentation/pages/vital_signs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SessionManagementScreen extends StatefulWidget {
  final PatientModel patient;
  final String treatmentType;
  final DateTime scheduledDate;
  final SessionStatus initialStatus;
  final int initialTabIndex;

  const SessionManagementScreen({
    super.key,
    required this.patient,
    required this.treatmentType,
    required this.scheduledDate,
    this.initialStatus = SessionStatus.pending,
    this.initialTabIndex = 0,
  });

  @override
  State<SessionManagementScreen> createState() =>
      _SessionManagementScreenState();
}

class _SessionManagementScreenState extends State<SessionManagementScreen>
    with TickerProviderStateMixin {
  // Vital Signs Controllers
  final TextEditingController _preWeightController = TextEditingController();
  final TextEditingController _postWeightController = TextEditingController();
  final TextEditingController _prePulseController = TextEditingController();
  final TextEditingController _midPulseController = TextEditingController();
  final TextEditingController _postPulseController = TextEditingController();
  final TextEditingController _preSystolicController = TextEditingController();
  final TextEditingController _midSystolicController = TextEditingController();
  final TextEditingController _postSystolicController = TextEditingController();
  final TextEditingController _preDiastolicController = TextEditingController();
  final TextEditingController _midDiastolicController = TextEditingController();
  final TextEditingController _postDiastolicController =
      TextEditingController();
  final TextEditingController _preTempController = TextEditingController();
  final TextEditingController _postTempController = TextEditingController();
  final TextEditingController _preSpo2Controller = TextEditingController();
  final TextEditingController _postSpo2Controller = TextEditingController();

  // Treatment Parameters Controllers
  final TextEditingController _actualBloodFlowRateController =
      TextEditingController();
  final TextEditingController _totalBloodProcessedController =
      TextEditingController();
  final TextEditingController _dialyzerTypeController = TextEditingController();
  final TextEditingController _arterialPressureController =
      TextEditingController();
  final TextEditingController _actualDialysateFlowRateController =
      TextEditingController();
  final TextEditingController _heparinBolusController = TextEditingController();
  final TextEditingController _venousPressureController =
      TextEditingController();
  final TextEditingController _actualUltrafiltrationController =
      TextEditingController();
  final TextEditingController _heparinRateController = TextEditingController();
  final TextEditingController _needleSizeController = TextEditingController();
  final TextEditingController _tmpController = TextEditingController();

  // Laboratory Values Controllers
  final TextEditingController _preBunController = TextEditingController();
  final TextEditingController _preCreatinineController =
      TextEditingController();
  final TextEditingController _prePotassiumController = TextEditingController();
  final TextEditingController _preSodiumController = TextEditingController();
  final TextEditingController _preHaemoglobinController =
      TextEditingController();
  final TextEditingController _preSGOTController = TextEditingController();
  final TextEditingController _preSGPTController = TextEditingController();
  final TextEditingController _postBunController = TextEditingController();
  final TextEditingController _postCreatinineController =
      TextEditingController();
  final TextEditingController _postPotassiumController =
      TextEditingController();
  final TextEditingController _postSodiumController = TextEditingController();
  final TextEditingController _postHaemoglobinController =
      TextEditingController();
  final TextEditingController _postSGOTController = TextEditingController();
  final TextEditingController _postSGPTController = TextEditingController();

  // Clinical Notes Controllers
  final TextEditingController _machineAlarmsController =
      TextEditingController();
  final TextEditingController _nursingInterventionsController =
      TextEditingController();
  final TextEditingController _patientToleranceController =
      TextEditingController();
  final TextEditingController _symptomsDuringTreatmentController =
      TextEditingController();
  final TextEditingController _actionController = TextEditingController();
  final TextEditingController _complicationsDetailsController =
      TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  late TabController _tabController;
  late SessionStatus _currentSessionStatus;

  @override
  void initState() {
    super.initState();
    _currentSessionStatus = widget.initialStatus;
    _tabController = TabController(
        length: 4, vsync: this, initialIndex: widget.initialTabIndex);
    _loadSessionData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _loadSessionData() async {
    final sessionData = await LocalStorageService.fetchSessionData(
        widget.patient.mrnNo, widget.scheduledDate);
    if (sessionData != null) {
      // Update the current status if data is loaded
      setState(() {
        _currentSessionStatus = sessionData.status;
        _tabController.animateTo(sessionData.lastActiveTabIndex);
      });

      // Vital Signs
      _preWeightController.text = sessionData.vitalSigns.bloodPressure;
      _postWeightController.text = sessionData.vitalSigns.heartRate;
      _prePulseController.text = sessionData.vitalSigns.temperature;
      // ... populate other vital signs

      // Treatment Parameters
      _actualBloodFlowRateController.text =
          sessionData.treatmentParameters.dialysisDuration;
      _totalBloodProcessedController.text =
          sessionData.treatmentParameters.dialyzerType;
      _dialyzerTypeController.text = sessionData.treatmentParameters.flowRate;
      // ... populate other treatment parameters

      // Laboratory Values
      _preBunController.text = sessionData.laboratoryValues.hemoglobin;
      _preCreatinineController.text = sessionData.laboratoryValues.creatinine;
      _prePotassiumController.text = sessionData.laboratoryValues.potassium;
      // ... populate other laboratory values

      // Clinical Notes
      _machineAlarmsController.text = sessionData.clinicalNotes.notes;
      _patientToleranceController.text =
          sessionData.clinicalNotes.patientTolerance;
      _nursingInterventionsController.text =
          sessionData.clinicalNotes.nursingInterventions;
      _symptomsDuringTreatmentController.text =
          sessionData.clinicalNotes.symptomsDuringTreatment;
      _complicationsDetailsController.text =
          sessionData.clinicalNotes.complicationsDetails;
    }
  }

  @override
  void dispose() {
    _preWeightController.dispose();
    _postWeightController.dispose();
    _prePulseController.dispose();
    _midPulseController.dispose();
    _postPulseController.dispose();
    _preSystolicController.dispose();
    _midSystolicController.dispose();
    _postSystolicController.dispose();
    _preDiastolicController.dispose();
    _midDiastolicController.dispose();
    _postDiastolicController.dispose();
    _preTempController.dispose();
    _postTempController.dispose();
    _preSpo2Controller.dispose();
    _postSpo2Controller.dispose();

    _actualBloodFlowRateController.dispose();
    _totalBloodProcessedController.dispose();
    _dialyzerTypeController.dispose();
    _arterialPressureController.dispose();
    _actualDialysateFlowRateController.dispose();
    _heparinBolusController.dispose();
    _venousPressureController.dispose();
    _actualUltrafiltrationController.dispose();
    _heparinRateController.dispose();
    _needleSizeController.dispose();
    _tmpController.dispose();

    _preBunController.dispose();
    _preCreatinineController.dispose();
    _prePotassiumController.dispose();
    _preSodiumController.dispose();
    _postBunController.dispose();
    _postCreatinineController.dispose();
    _postPotassiumController.dispose();
    _postSodiumController.dispose();

    _machineAlarmsController.dispose();
    _nursingInterventionsController.dispose();
    _patientToleranceController.dispose();
    _symptomsDuringTreatmentController.dispose();
    _complicationsDetailsController.dispose();
    _actionController.dispose();
    _remarksController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _saveSessionData(SessionStatus statusToSave) async {
    final vitalSigns = VitalSigns(
      bloodPressure: _preWeightController.text,
      heartRate: _postWeightController.text,
      temperature: _prePulseController.text,
    );

    final treatmentParameters = TreatmentParameters(
      dialysisDuration: _actualBloodFlowRateController.text,
      dialyzerType: _totalBloodProcessedController.text,
      flowRate: _dialyzerTypeController.text,
    );

    final laboratoryValues = LaboratoryValues(
      hemoglobin: _preBunController.text,
      creatinine: _preCreatinineController.text,
      potassium: _prePotassiumController.text,
      sodium: _preSodiumController.text,
      preHaemoglobin: _preHaemoglobinController.text,
      preSGOT: _preSGOTController.text,
      preSGPT: _preSGPTController.text,
      postHaemoglobin: _postHaemoglobinController.text,
      postSGOT: _postSGOTController.text,
      postSGPT: _postSGPTController.text,
    );

    final clinicalNotes = ClinicalNotes(
      notes: _machineAlarmsController.text,
      patientTolerance: _patientToleranceController.text,
      nursingInterventions: _nursingInterventionsController.text,
      symptomsDuringTreatment: _symptomsDuringTreatmentController.text,
      complicationsDetails: _complicationsDetailsController.text,
      actionTaken: '',
      remarks: '',
    );

    final sessionData = SessionData(
      patientId: widget.patient.mrnNo,
      sessionDate: widget.scheduledDate,
      vitalSigns: vitalSigns,
      treatmentParameters: treatmentParameters,
      laboratoryValues: laboratoryValues,
      clinicalNotes: clinicalNotes,
      status: statusToSave,
      lastActiveTabIndex: _tabController.index,
    );

    await LocalStorageService.saveSessionData(sessionData);
    await LocalStorageService.updateTreatmentStatus(
        widget.patient.mrnNo, widget.scheduledDate, statusToSave);

    if (mounted) {
      Navigator.pop(context, statusToSave); // Pop with the new session status
    }
  }

  Future<void> _onSaveProgressPressed() async {
    final confirm = await _showConfirmDialog(
      "Save Progress?",
      "Are you sure you want to save your progress and exit?",
    );
    if (confirm != null) {
      await _saveSessionData(SessionStatus.in_progress);
    }
  }

  Future<void> _onCompleteSessionPressed() async {
    final confirm = await _showConfirmDialog(
      "Complete Session?",
      "Are you sure you want to complete this session? This action cannot be undone.",
    );
    if (confirm != null) {
      await _saveSessionData(SessionStatus.completed);
    }
  }

  void _goToNextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  Future<void> _onCancelPressed() async {
    final confirm = await _showConfirmDialog(
      "Cancel Session?",
      "Are you sure you want to cancel and exit without saving?",
    );
    if (confirm != null)
      Navigator.pop(context, _currentSessionStatus); // Pop with current status
  }

  Future<SessionStatus?> _showConfirmDialog(
      String title, String message) async {
    return await showDialog<SessionStatus?>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null), // Cancel dialog
                child: const Text("No"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, _currentSessionStatus),
                // Confirm action, return current status
                child: const Text("Yes"),
              ),
            ],
          ),
        ) ??
        null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isSessionCompleted =
        _currentSessionStatus == SessionStatus.completed;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Dark Green
      ),
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
                "${widget.patient.firstName} • MRN: ${widget.patient.mrnNo} • ${widget.treatmentType} • ${DateFormat('dd MMM yyyy').format(widget.scheduledDate)}",
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
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
                controller: _tabController,
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
        body: TabBarView(
          controller: _tabController,
          children: [
            VitalSignsPage(
              preWeightController: _preWeightController,
              postWeightController: _postWeightController,
              prePulseController: _prePulseController,
              midPulseController: _midPulseController,
              postPulseController: _postPulseController,
              preSystolicController: _preSystolicController,
              midSystolicController: _midSystolicController,
              postSystolicController: _postSystolicController,
              preDiastolicController: _preDiastolicController,
              midDiastolicController: _midDiastolicController,
              postDiastolicController: _postDiastolicController,
              preTempController: _preTempController,
              postTempController: _postTempController,
              preSpo2Controller: _preSpo2Controller,
              postSpo2Controller: _postSpo2Controller,
              onSave: _onSaveProgressPressed,
              onComplete: _onCompleteSessionPressed,
              onNext: _goToNextTab,
              onCancel: _onCancelPressed,
              readOnly: isSessionCompleted,
            ),
            TreatmentParametersPage(
              actualBloodFlowRateController: _actualBloodFlowRateController,
              totalBloodProcessedController: _totalBloodProcessedController,
              dialyzerTypeController: _dialyzerTypeController,
              arterialPressureController: _arterialPressureController,
              actualDialysateFlowRateController:
                  _actualDialysateFlowRateController,
              heparinBolusController: _heparinBolusController,
              venousPressureController: _venousPressureController,
              actualUltrafiltrationController: _actualUltrafiltrationController,
              heparinRateController: _heparinRateController,
              needleSizeController: _needleSizeController,
              tmpController: _tmpController,
              onSave: _onSaveProgressPressed,
              onComplete: _onCompleteSessionPressed,
              onNext: _goToNextTab,
              onCancel: _onCancelPressed,
              readOnly: isSessionCompleted,
            ),
            LaboratoryValuesPage(
              preBunController: _preBunController,
              preCreatinineController: _preCreatinineController,
              prePotassiumController: _prePotassiumController,
              preSodiumController: _preSodiumController,
              preHaemoglobinController: _preHaemoglobinController,
              preSGOTController: _preSGOTController,
              preSGPTController: _preSGPTController,
              postBunController: _postBunController,
              postCreatinineController: _postCreatinineController,
              postPotassiumController: _postPotassiumController,
              postSodiumController: _postSodiumController,
              postHaemoglobinController: _postHaemoglobinController,
              postSGOTController: _postSGOTController,
              postSGPTController: _postSGPTController,
              onSave: _onSaveProgressPressed,
              onComplete: _onCompleteSessionPressed,
              onNext: _goToNextTab,
              onCancel: _onCancelPressed,
              readOnly: isSessionCompleted,
            ),
            ClinicalNotesPage(
              machineAlarmsController: _machineAlarmsController,
              nursingInterventionsController: _nursingInterventionsController,
              patientToleranceController: _patientToleranceController,
              symptomsDuringTreatmentController:
                  _symptomsDuringTreatmentController,
              actionTakenController: _actionController,
              complicationsDetailsController: _complicationsDetailsController,
              remarksController: _remarksController,
              onSave: _onSaveProgressPressed,
              onComplete: _onCompleteSessionPressed,
              onCancel: _onCancelPressed,
              readOnly: isSessionCompleted,
            ),
          ],
        ),
      ),
    );
  }
}
