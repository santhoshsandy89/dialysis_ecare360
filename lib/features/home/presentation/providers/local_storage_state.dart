import 'package:ecare360/data/models/patient_model.dart';
import 'package:ecare360/data/models/treatment_model.dart';

class LocalStorageState {
  final List<PatientModel> patients;
  final List<Treatment> treatments;

  const LocalStorageState({
    required this.patients,
    required this.treatments,
  });

  LocalStorageState copyWith({
    List<PatientModel>? patients,
    List<Treatment>? treatments,
  }) {
    return LocalStorageState(
      patients: patients ?? this.patients,
      treatments: treatments ?? this.treatments,
    );
  }

  factory LocalStorageState.initial() => const LocalStorageState(
        patients: [],
        treatments: [],
      );
}
