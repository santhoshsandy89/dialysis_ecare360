import 'dart:convert';

class SessionData {
  final String patientId;
  final VitalSigns vitalSigns;
  final TreatmentParameters treatmentParameters;
  final LaboratoryValues laboratoryValues;
  final ClinicalNotes clinicalNotes;

  SessionData({
    required this.patientId,
    required this.vitalSigns,
    required this.treatmentParameters,
    required this.laboratoryValues,
    required this.clinicalNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'vitalSigns': vitalSigns.toMap(),
      'treatmentParameters': treatmentParameters.toMap(),
      'laboratoryValues': laboratoryValues.toMap(),
      'clinicalNotes': clinicalNotes.toMap(),
    };
  }

  factory SessionData.fromMap(Map<String, dynamic> map) {
    return SessionData(
      patientId: map['patientId'] ?? '',
      vitalSigns: VitalSigns.fromMap(map['vitalSigns'] ?? {}),
      treatmentParameters: TreatmentParameters.fromMap(map['treatmentParameters'] ?? {}),
      laboratoryValues: LaboratoryValues.fromMap(map['laboratoryValues'] ?? {}),
      clinicalNotes: ClinicalNotes.fromMap(map['clinicalNotes'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionData.fromJson(String source) => SessionData.fromMap(json.decode(source));
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

  factory VitalSigns.fromJson(String source) => VitalSigns.fromMap(json.decode(source));
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

  factory TreatmentParameters.fromJson(String source) => TreatmentParameters.fromMap(json.decode(source));
}

class LaboratoryValues {
  final String hemoglobin;
  final String creatinine;
  final String potassium;

  LaboratoryValues({
    required this.hemoglobin,
    required this.creatinine,
    required this.potassium,
  });

  Map<String, dynamic> toMap() {
    return {
      'hemoglobin': hemoglobin,
      'creatinine': creatinine,
      'potassium': potassium,
    };
  }

  factory LaboratoryValues.fromMap(Map<String, dynamic> map) {
    return LaboratoryValues(
      hemoglobin: map['hemoglobin'] ?? '',
      creatinine: map['creatinine'] ?? '',
      potassium: map['potassium'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LaboratoryValues.fromJson(String source) => LaboratoryValues.fromMap(json.decode(source));
}

class ClinicalNotes {
  final String notes;

  ClinicalNotes({
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'notes': notes,
    };
  }

  factory ClinicalNotes.fromMap(Map<String, dynamic> map) {
    return ClinicalNotes(
      notes: map['notes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClinicalNotes.fromJson(String source) => ClinicalNotes.fromMap(json.decode(source));
}
