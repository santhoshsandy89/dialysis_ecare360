import 'package:ecare360/core/providers/admission_notifier.dart';
import 'package:ecare360/core/providers/admission_state.dart';
import 'package:ecare360/data/models/admission_model.dart';
import 'package:ecare360/data/services/admission_service.dart';
import 'package:ecare360/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final admissionServiceProvider = Provider((ref) => AdmissionService());

final admissionNotifierProvider =
    StateNotifierProvider<AdmissionNotifier, AdmissionState>(
  (ref) => AdmissionNotifier(ref),
);

final createAdmissionProvider =
    FutureProvider.family.autoDispose<Map<String, dynamic>, AdmissionModel>(
  (ref, admission) async {
    final auth = ref.read(authProvider);
    final token = auth.authModel?.accessToken ?? "";

    if (token.isEmpty) {
      throw Exception("Access token missing");
    }

    final service = ref.read(admissionServiceProvider);

    return await service.createAdmission(
      admission: admission,
      token: token,
    );
  },
);
