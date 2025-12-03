import 'package:ecare360/data/models/patient_model.dart';
import 'package:ecare360/data/models/scheduled_session.dart';
import 'package:ecare360/data/models/scheduled_treatment_model.dart';
import 'package:ecare360/features/schedule_treatment/data/models/patient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TreatmentStatus { Scheduled, InProgress, Completed, Cancelled }

class ScheduleTreatmentState {
  final DateTime selectedDate;
  final TreatmentStatus selectedStatus;
  final List<Patient> patientList;
  final List<ScheduledTreatment> scheduledTreatments;
  final List<ScheduledSession> activeSessions;

  ScheduleTreatmentState({
    required this.selectedDate,
    required this.selectedStatus,
    required this.patientList,
    required this.scheduledTreatments,
    required this.activeSessions,
  });

  ScheduleTreatmentState copyWith({
    DateTime? selectedDate,
    TreatmentStatus? selectedStatus,
    List<Patient>? patientList,
    List<ScheduledTreatment>? scheduledTreatments,
    List<ScheduledSession>? activeSessions,
  }) {
    return ScheduleTreatmentState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      patientList: patientList ?? this.patientList,
      scheduledTreatments: scheduledTreatments ?? this.scheduledTreatments,
      activeSessions: activeSessions ?? this.activeSessions,
    );
  }
}

class ScheduleTreatmentNotifier extends StateNotifier<ScheduleTreatmentState> {
  ScheduleTreatmentNotifier()
      : super(ScheduleTreatmentState(
          selectedDate: DateTime.now(),
          selectedStatus: TreatmentStatus.Scheduled,
          patientList: [],
          scheduledTreatments: [],
          activeSessions: [],
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

  /// NEW FUNCTION — Add scheduled treatment
  void addScheduledTreatment(ScheduledTreatment newTreatment) {
    state = state.copyWith(
      scheduledTreatments: [...state.scheduledTreatments, newTreatment],
    );
  }

  /// Remove ScheduledTreatment by index
  void removeScheduledTreatment(int index) {
    if (index >= 0 && index < state.scheduledTreatments.length) {
      final updatedList =
          List<ScheduledTreatment>.from(state.scheduledTreatments)
            ..removeAt(index);

      state = state.copyWith(scheduledTreatments: updatedList);
    }
  }

  void startSession(PatientModel patient, String treatmentType) {
    final session = ScheduledSession(
      patient: patient,
      treatmentType: treatmentType,
      startTime: DateTime.now(),
    );

    state = state.copyWith(activeSessions: [...state.activeSessions, session]);
  }
}

final scheduleTreatmentProvider =
    StateNotifierProvider<ScheduleTreatmentNotifier, ScheduleTreatmentState>(
  (ref) => ScheduleTreatmentNotifier(),
);
