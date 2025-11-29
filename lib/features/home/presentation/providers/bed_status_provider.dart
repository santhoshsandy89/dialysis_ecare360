import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecare360/data/models/bed_status_model.dart';
import 'package:ecare360/data/services/local_storage_service.dart';
import 'package:ecare360/core/utils/logger.dart';

final bedStatusProvider = StateNotifierProvider<BedStatusNotifier, List<BedStatusModel>>((ref) {
  return BedStatusNotifier();
});

class BedStatusNotifier extends StateNotifier<List<BedStatusModel>> {
  BedStatusNotifier() : super([]) {
    _loadBedStatuses();
  }

  Future<void> _loadBedStatuses() async {
    try {
      final cachedStatuses = await LocalStorageService.getBedStatuses();
      state = cachedStatuses;
      AppLogger.debug('Bed statuses loaded into provider from local storage.');
    } catch (e) {
      AppLogger.error('Error loading bed statuses from local storage: $e');
      state = [];
    }
  }

  void setBedStatuses(List<BedStatusModel> statuses) {
    state = statuses;
    AppLogger.debug('Bed statuses updated in provider.');
  }
}
