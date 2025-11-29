import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecare360/features/schedule_treatment/data/models/patient.dart';

enum TreatmentStatus {
  Scheduled, InProgress, Completed, Cancelled
}

class ScheduleTreatmentState {
  final DateTime selectedDate;
  final TreatmentStatus selectedStatus;
  final List<Patient> patientList;

  ScheduleTreatmentState({
    required this.selectedDate,
    required this.selectedStatus,
    required this.patientList,
  });

  ScheduleTreatmentState copyWith({
    DateTime? selectedDate,
    TreatmentStatus? selectedStatus,
    List<Patient>? patientList,
  }) {
    return ScheduleTreatmentState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      patientList: patientList ?? this.patientList,
    );
  }
}

class ScheduleTreatmentNotifier extends StateNotifier<ScheduleTreatmentState> {
  ScheduleTreatmentNotifier() : super(ScheduleTreatmentState(
    selectedDate: DateTime.now(),
    selectedStatus: TreatmentStatus.Scheduled,
    patientList: [],
  ));

  void updateSelectedDate(DateTime newDate) {
    state = state.copyWith(selectedDate: newDate);
  }

  void updateSelectedStatus(TreatmentStatus newStatus) {
    state = state.copyWith(selectedStatus: newStatus);
  }

  void addPatient(Patient patient) {
    state = state.copyWith(patientList: [...state.patientList, patient]);
  }

  void removePatient(String mrnNo) {
    state = state.copyWith(
      patientList: state.patientList.where((p) => p.mrnNo != mrnNo).toList(),
    );
  }
}

final scheduleTreatmentProvider = StateNotifierProvider<
    ScheduleTreatmentNotifier, ScheduleTreatmentState>(
  (ref) => ScheduleTreatmentNotifier(),
);
