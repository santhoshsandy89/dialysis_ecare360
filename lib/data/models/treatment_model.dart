import 'package:ecare360/data/models/patient_model.dart';
import 'package:ecare360/features/schedule_treatment/presentation/pages/schedule_treatment_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecare360/data/models/session_data_model.dart';

class Treatment {
  final PatientModel patient;
  final DateTime scheduledDate;
  final TimeOfDay scheduledTime;
  final int durationMinutes;
  final String location;
  final String nurse;
  final BloodAccessType accessType;
  final int? ufGoal;
  final String notes;
  final TreatmentMainType treatmentMainType;
  final CrrtSubType? crrtSubType;
  final SessionStatus status;

  Treatment({
    required this.patient,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.durationMinutes,
    required this.location,
    required this.nurse,
    required this.accessType,
    this.ufGoal,
    required this.notes,
    required this.treatmentMainType,
    this.crrtSubType,
    this.status = SessionStatus.pending,
  });

  Treatment copyWith({
    PatientModel? patient,
    DateTime? scheduledDate,
    TimeOfDay? scheduledTime,
    int? durationMinutes,
    String? location,
    String? nurse,
    BloodAccessType? accessType,
    int? ufGoal,
    String? notes,
    TreatmentMainType? treatmentMainType,
    CrrtSubType? crrtSubType,
    SessionStatus? status,
  }) {
    return Treatment(
      patient: patient ?? this.patient,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      location: location ?? this.location,
      nurse: nurse ?? this.nurse,
      accessType: accessType ?? this.accessType,
      ufGoal: ufGoal ?? this.ufGoal,
      notes: notes ?? this.notes,
      treatmentMainType: treatmentMainType ?? this.treatmentMainType,
      crrtSubType: crrtSubType ?? this.crrtSubType,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient': patient.toJson(),
      'treatmentMainType': treatmentMainType.name,
      'crrtSubType': crrtSubType?.name,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledTime': '${scheduledTime.hour}:${scheduledTime.minute}',
      'durationMinutes': durationMinutes,
      'location': location,
      'nurse': nurse,
      'accessType': accessType.name,
      'ufGoal': ufGoal,
      'notes': notes,
      'status': status.name,
    };
  }

  static Treatment fromJson(Map<String, dynamic> json) {
    final timeParts = (json['scheduledTime'] as String).split(':');

    return Treatment(
      patient: PatientModel.fromJson(json['patient']),
      treatmentMainType: TreatmentMainType.values
          .firstWhere((e) => e.name == json['treatmentMainType']),
      crrtSubType: json['crrtSubType'] == null
          ? null
          : CrrtSubType.values.firstWhere((e) => e.name == json['crrtSubType']),
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
      status: SessionStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? SessionStatus.pending.name),
        orElse: () => SessionStatus.pending,
      ),
    );
  }
}
