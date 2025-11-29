import 'package:ecare360/data/models/doctor_model.dart';
import 'package:ecare360/data/services/local_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorNotifier extends StateNotifier<List<DoctorModel>> {
  DoctorNotifier() : super([]);

  Future<void> loadDoctors() async {
    state = await LocalStorageService.getDoctorsList();
  }

  void setDoctors(List<DoctorModel> doctors) {
    state = doctors;
  }
}

final doctorProvider = StateNotifierProvider<DoctorNotifier, List<DoctorModel>>((ref) {
  return DoctorNotifier();
});
