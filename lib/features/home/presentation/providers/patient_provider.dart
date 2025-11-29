import 'package:ecare360/data/models/patient_model.dart';
import 'package:ecare360/data/services/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientNotifier extends StateNotifier<List<PatientModel>> {
  PatientNotifier() : super([]);

  Future<void> loadPatients() async {
    state = await LocalStorageService.getPatientsList();
  }

  void setPatients(List<PatientModel> patients) {
    state = patients;
  }
}

final patientProvider = StateNotifierProvider<PatientNotifier, List<PatientModel>>((ref) {
  return PatientNotifier();
});
