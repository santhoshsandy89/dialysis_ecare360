import 'package:ecare360/data/models/patient_model.dart';

class ScheduledSession {
  final PatientModel patient;
  final String treatmentType;
  final DateTime startTime;

  ScheduledSession({
    required this.patient,
    required this.treatmentType,
    required this.startTime,
  });
}
