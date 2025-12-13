import 'dart:convert';

enum SessionStatus {
  pending, // Session not yet started or explicitly saved as pending
  in_progress, // Session started and saved, but not completed
  completed, // Session fully completed
}

class SessionData {
  final String patientId;
  final DateTime sessionDate;
  final VitalSigns vitalSigns;
  final TreatmentParameters treatmentParameters;
  final LaboratoryValues laboratoryValues;
  final ClinicalNotes clinicalNotes;
  final SessionStatus status;
  final int lastActiveTabIndex;

  SessionData({
    required this.patientId,
    required this.sessionDate,
    required this.vitalSigns,
    required this.treatmentParameters,
    required this.laboratoryValues,
    required this.clinicalNotes,
    this.status = SessionStatus.pending,
    this.lastActiveTabIndex = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'sessionDate': sessionDate.toIso8601String(),
      'vitalSigns': vitalSigns.toMap(),
      'treatmentParameters': treatmentParameters.toMap(),
      'laboratoryValues': laboratoryValues.toMap(),
      'clinicalNotes': clinicalNotes.toMap(),
      'status': status.name,
      'lastActiveTabIndex': lastActiveTabIndex,
    };
  }

  factory SessionData.fromMap(Map<String, dynamic> map) {
    return SessionData(
      patientId: map['patientId'] ?? '',
      sessionDate: DateTime.parse(map['sessionDate']),
      vitalSigns: VitalSigns.fromMap(map['vitalSigns'] ?? {}),
      treatmentParameters:
          TreatmentParameters.fromMap(map['treatmentParameters'] ?? {}),
      laboratoryValues: LaboratoryValues.fromMap(map['laboratoryValues'] ?? {}),
      clinicalNotes: ClinicalNotes.fromMap(map['clinicalNotes'] ?? {}),
      status: SessionStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? SessionStatus.pending.name),
        orElse: () => SessionStatus.pending,
      ),
      lastActiveTabIndex: map['lastActiveTabIndex'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionData.fromJson(String source) =>
      SessionData.fromMap(json.decode(source));
}

class VitalSigns {
  final String bloodPressure;
  final String heartRate;
  final String temperature;

  VitalSigns({
    required this.bloodPressure,
    required this.heartRate,
    required this.temperature,
  });

  Map<String, dynamic> toMap() {
    return {
      'bloodPressure': bloodPressure,
      'heartRate': heartRate,
      'temperature': temperature,
    };
  }

  factory VitalSigns.fromMap(Map<String, dynamic> map) {
    return VitalSigns(
      bloodPressure: map['bloodPressure'] ?? '',
      heartRate: map['heartRate'] ?? '',
      temperature: map['temperature'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VitalSigns.fromJson(String source) =>
      VitalSigns.fromMap(json.decode(source));
}

class TreatmentParameters {
  final String dialysisDuration;
  final String dialyzerType;
  final String flowRate;

  TreatmentParameters({
    required this.dialysisDuration,
    required this.dialyzerType,
    required this.flowRate,
  });

  Map<String, dynamic> toMap() {
    return {
      'dialysisDuration': dialysisDuration,
      'dialyzerType': dialyzerType,
      'flowRate': flowRate,
    };
  }

  factory TreatmentParameters.fromMap(Map<String, dynamic> map) {
    return TreatmentParameters(
      dialysisDuration: map['dialysisDuration'] ?? '',
      dialyzerType: map['dialyzerType'] ?? '',
      flowRate: map['flowRate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TreatmentParameters.fromJson(String source) =>
      TreatmentParameters.fromMap(json.decode(source));
}

class LaboratoryValues {
  final String hemoglobin;
  final String creatinine;
  final String potassium;
  final String sodium;
  final String preHaemoglobin;
  final String preSGOT;
  final String preSGPT;
  final String postHaemoglobin;
  final String postSGOT;
  final String postSGPT;

  LaboratoryValues({
    required this.hemoglobin,
    required this.creatinine,
    required this.potassium,
    required this.sodium,
    required this.preHaemoglobin,
    required this.preSGOT,
    required this.preSGPT,
    required this.postHaemoglobin,
    required this.postSGOT,
    required this.postSGPT,
  });

  Map<String, dynamic> toMap() {
    return {
      'hemoglobin': hemoglobin,
      'creatinine': creatinine,
      'potassium': potassium,
      'sodium': sodium,
      'preHaemoglobin': preHaemoglobin,
      'preSGOT': preSGOT,
      'preSGPT': preSGPT,
      'postHaemoglobin': postHaemoglobin,
      'postSGOT': postSGOT,
      'postSGPT': postSGPT,
    };
  }

  factory LaboratoryValues.fromMap(Map<String, dynamic> map) {
    return LaboratoryValues(
      hemoglobin: map['hemoglobin'] ?? '',
      creatinine: map['creatinine'] ?? '',
      potassium: map['potassium'] ?? '',
      sodium: map['sodium'] ?? '',
      preHaemoglobin: map['preHaemoglobin'] ?? '',
      preSGOT: map['preSGOT'] ?? '',
      preSGPT: map['preSGPT'] ?? '',
      postHaemoglobin: map['postHaemoglobin'] ?? '',
      postSGOT: map['postSGOT'] ?? '',
      postSGPT: map['postSGPT'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LaboratoryValues.fromJson(String source) =>
      LaboratoryValues.fromMap(json.decode(source));
}

class ClinicalNotes {
  final String notes;
  final String patientTolerance;
  final String nursingInterventions;
  final String symptomsDuringTreatment;
  final String complicationsDetails;
  final String actionTaken;
  final String remarks;

  ClinicalNotes({
    required this.notes,
    required this.patientTolerance,
    required this.nursingInterventions,
    required this.symptomsDuringTreatment,
    required this.complicationsDetails,
    required this.actionTaken,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'notes': notes,
      'patientTolerance': patientTolerance,
      'nursingInterventions': nursingInterventions,
      'symptomsDuringTreatment': symptomsDuringTreatment,
      'complicationsDetails': complicationsDetails,
      'actionTaken': actionTaken,
      'remarks': remarks,
    };
  }

  factory ClinicalNotes.fromMap(Map<String, dynamic> map) {
    return ClinicalNotes(
      notes: map['notes'] ?? '',
      patientTolerance: map['patientTolerance'] ?? '',
      nursingInterventions: map['nursingInterventions'] ?? '',
      symptomsDuringTreatment: map['symptomsDuringTreatment'] ?? '',
      complicationsDetails: map['complicationsDetails'] ?? '',
      actionTaken: map['actionTaken'] ?? '',
      remarks: map['remarks'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClinicalNotes.fromJson(String source) =>
      ClinicalNotes.fromMap(json.decode(source));
}
