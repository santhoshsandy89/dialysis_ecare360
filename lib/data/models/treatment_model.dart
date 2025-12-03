import 'package:ecare360/data/models/patient_model.dart';
import 'package:ecare360/features/schedule_treatment/presentation/pages/schedule_treatment_screen.dart';
import 'package:flutter/material.dart';

class Treatment {
  final PatientModel patient;
  final TreatmentType treatmentType;
  final DateTime scheduledDate;
  final TimeOfDay scheduledTime;
  final int durationMinutes;
  final String location;
  final String nurse;
  final BloodAccessType accessType;
  final int? ufGoal;
  final String notes;
  final bool isCompleted;
  final bool isInProgress;

  Treatment({
    required this.patient,
    required this.treatmentType,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.durationMinutes,
    required this.location,
    required this.nurse,
    required this.accessType,
    this.ufGoal,
    required this.notes,
    this.isCompleted = false,
    this.isInProgress = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'patient': patient.toJson(), // FIXED
      'treatmentType': treatmentType.name,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledTime': '${scheduledTime.hour}:${scheduledTime.minute}',
      'durationMinutes': durationMinutes,
      'location': location,
      'nurse': nurse,
      'accessType': accessType.name,
      'ufGoal': ufGoal,
      'notes': notes,
      'completed': isCompleted,
      'inProgress': isInProgress,
    };
  }

  static Treatment fromJson(Map<String, dynamic> json) {
    final timeParts = (json['scheduledTime'] as String).split(':');

    return Treatment(
      patient: PatientModel.fromJson(json['patient']),
      // FIXED
      treatmentType: TreatmentType.values
          .firstWhere((e) => e.name == json['treatmentType']),
      scheduledDate: DateTime.parse(json['scheduledDate']),
      scheduledTime: TimeOfDay(
        hour: int.tryParse(timeParts[0]) ?? 0,
        minute: int.tryParse(timeParts[1]) ?? 0,
      ),
      durationMinutes: json['durationMinutes'],
      location: json['location'],
      nurse: json['nurse'],
      accessType: BloodAccessType.values
          .firstWhere((e) => e.name == json['accessType']),
      ufGoal: json['ufGoal'],
      notes: json['notes'],
      isInProgress: json['inProgress'] ?? false,
      isCompleted: json['completed'] ?? false,
    );
  }
}
