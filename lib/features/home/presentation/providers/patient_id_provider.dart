import 'package:ecare360/data/models/patient_id_model.dart';
import 'package:ecare360/data/services/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientIdNotifier extends StateNotifier<List<PatientIDModel>> {
  PatientIdNotifier() : super([]);

  Future<void> loadPatientsId() async {
    state = await LocalStorageService.getPatientsIdList();
  }

  void setPatientsId(List<PatientIDModel> patients) {
    state = patients;
  }
}

final patientIdProvider =
    StateNotifierProvider<PatientIdNotifier, List<PatientIDModel>>((ref) {
  return PatientIdNotifier();
});
