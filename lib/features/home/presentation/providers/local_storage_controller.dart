import 'package:ecare360/data/models/patient_model.dart';
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
      treatments.where((t) => !t.isInProgress && !t.isCompleted).length;

  int get inProgressCount =>
      treatments.where((t) => t.isInProgress && !t.isCompleted).length;

  int get completedCount => treatments.where((t) => t.isCompleted).length;
}
