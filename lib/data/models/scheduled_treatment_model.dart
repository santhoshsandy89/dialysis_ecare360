import 'package:ecare360/features/schedule_treatment/presentation/pages/schedule_treatment_screen.dart';
import 'package:flutter/material.dart';

class ScheduledTreatment {
  final TempPatientName patient;
  final TreatmentType treatmentType;
  final DateTime scheduledDate;
  final TimeOfDay scheduledTime;
  final int durationMinutes;
  final String location;
  final String nurse;
  final BloodAccessType? accessType;
  final int? ufGoal;
  final String notes;

  ScheduledTreatment({
    required this.patient,
    required this.treatmentType,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.durationMinutes,
    required this.location,
    required this.nurse,
    this.accessType,
    this.ufGoal,
    this.notes = "",
  });
}
