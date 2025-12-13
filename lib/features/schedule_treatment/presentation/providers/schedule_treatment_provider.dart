import 'package:ecare360/data/models/session_data_model.dart';
import 'package:ecare360/data/models/treatment_model.dart';
import 'package:ecare360/features/schedule_treatment/data/models/patient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleTreatmentState {
  final DateTime selectedDate;
  final SessionStatus selectedStatus;
  final List<Patient> patientList;
  final List<Treatment> scheduledTreatments;

  ScheduleTreatmentState({
    required this.selectedDate,
    required this.selectedStatus,
    required this.patientList,
    required this.scheduledTreatments,
  });

  ScheduleTreatmentState copyWith({
    DateTime? selectedDate,
    SessionStatus? selectedStatus,
    List<Patient>? patientList,
    List<Treatment>? scheduledTreatments,
  }) {
    return ScheduleTreatmentState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      patientList: patientList ?? this.patientList,
      scheduledTreatments: scheduledTreatments ?? this.scheduledTreatments,
    );
  }
}

class ScheduleTreatmentNotifier extends StateNotifier<ScheduleTreatmentState> {
  ScheduleTreatmentNotifier()
      : super(ScheduleTreatmentState(
          selectedDate: DateTime.now(),
          selectedStatus: SessionStatus.pending,
          patientList: [],
          scheduledTreatments: [],
        ));

  void updateSelectedDate(DateTime newDate) {
    state = state.copyWith(selectedDate: newDate);
  }

  void updateSelectedStatus(SessionStatus newStatus) {
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

  /// Add scheduled treatment
  void addScheduledTreatment(Treatment newTreatment) {
    state = state.copyWith(
      scheduledTreatments: [...state.scheduledTreatments, newTreatment],
    );
  }

  /// Remove ScheduledTreatment by index
  void removeScheduledTreatment(int index) {
    if (index >= 0 && index < state.scheduledTreatments.length) {
      final updatedList = List<Treatment>.from(state.scheduledTreatments)
        ..removeAt(index);

      state = state.copyWith(scheduledTreatments: updatedList);
    }
  }
}

final scheduleTreatmentProvider =
    StateNotifierProvider<ScheduleTreatmentNotifier, ScheduleTreatmentState>(
  (ref) => ScheduleTreatmentNotifier(),
);
