import 'package:ecare360/data/models/patient_model.dart';
import 'package:ecare360/data/models/session_data_model.dart';
import 'package:ecare360/data/models/treatment_model.dart';
import 'package:ecare360/data/services/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageProvider =
    StateNotifierProvider<LocalStorageController, LocalStorageState>(
  (ref) => LocalStorageController()..loadData(),
);

class LocalStorageController extends StateNotifier<LocalStorageState> {
  LocalStorageController() : super(LocalStorageState.initial());

  Future<void> loadData() async {
    final patients = await LocalStorageService.getPatients();
    final treatments = await LocalStorageService.getTreatments();

    state = state.copyWith(
      patients: patients,
      treatments: treatments,
    );
  }

  Future<void> addPatient(PatientModel patient) async {
    await LocalStorageService.savePatient(patient);

    final updated = await LocalStorageService.getPatients();
    state = state.copyWith(patients: updated);
  }

  Future<void> addTreatment(Treatment treatment) async {
    await LocalStorageService.saveTreatment(treatment);

    final updated = await LocalStorageService.getTreatments();
    state = state.copyWith(treatments: updated);
  }

  // Refreshes a single treatment's status in the state
  Future<void> refreshTreatmentStatus(String patientId, DateTime scheduledDate) async {
    final updatedTreatment = await LocalStorageService.getTreatment(patientId, scheduledDate);
    if (updatedTreatment != null) {
      final List<Treatment> currentTreatments = List.from(state.treatments);
      final int index = currentTreatments.indexWhere(
        (t) => t.patient.mrnNo == patientId && 
               t.scheduledDate.toIso8601String().split('T').first == scheduledDate.toIso8601String().split('T').first
      );

      if (index != -1) {
        currentTreatments[index] = updatedTreatment;
        state = state.copyWith(treatments: currentTreatments);
      }
    }
  }
}

class LocalStorageState {
  final List<PatientModel> patients;
  final List<Treatment> treatments;

  LocalStorageState({
    required this.patients,
    required this.treatments,
  });

  factory LocalStorageState.initial() => LocalStorageState(
        patients: [],
        treatments: [],
      );

  LocalStorageState copyWith({
    List<PatientModel>? patients,
    List<Treatment>? treatments,
  }) {
    return LocalStorageState(
      patients: patients ?? this.patients,
      treatments: treatments ?? this.treatments,
    );
  }

  int get totalTreatments => treatments.length;

  int get scheduledCount =>
      treatments.where((t) => t.status == SessionStatus.pending).length;

  int get inProgressCount =>
      treatments.where((t) => t.status == SessionStatus.in_progress).length;

  int get completedCount => treatments.where((t) => t.status == SessionStatus.completed).length;
}
