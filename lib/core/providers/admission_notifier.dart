import 'package:ecare360/core/providers/admission_provider.dart';
import 'package:ecare360/core/providers/admission_state.dart';
import 'package:ecare360/data/models/admission_model.dart';
import 'package:ecare360/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdmissionNotifier extends StateNotifier<AdmissionState> {
  final Ref ref;

  AdmissionNotifier(this.ref) : super(AdmissionState.initial());

  Future<void> createAdmission(AdmissionModel model) async {
    try {
      state = state.copyWith(isLoading: true);

      final token = ref.read(authProvider).authModel?.accessToken ?? "";

      final service = ref.read(admissionServiceProvider);

      final response =
          await service.createAdmission(admission: model, token: token);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        message: response["message"] ?? "Admission created successfully",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString(),
      );
    }
  }
}
