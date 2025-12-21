import 'dart:convert';

enum SessionStatus {
  pending,
  in_progress,
  completed,
}

class BloodPressureEntry {
  final int time;
  final String bpValue;

  BloodPressureEntry({
    required this.time,
    required this.bpValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'bpValue': bpValue,
    };
  }

  factory BloodPressureEntry.fromMap(Map<String, dynamic> map) {
    return BloodPressureEntry(
      time: map['time'] as int,
      bpValue: map['bpValue'] as String,
    );
  }
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
  final String preWeight;
  final String postWeight;
  final String prePulse;
  final String midPulse;
  final String postPulse;
  final String preSystolic;
  final String midSystolic;
  final String postSystolic;
  final String preDiastolic;
  final String midDiastolic;
  final String postDiastolic;
  final String preTemp;
  final String postTemp;
  final String preSpo2;
  final String postSpo2;

  VitalSigns({
    required this.preWeight,
    required this.postWeight,
    required this.prePulse,
    required this.midPulse,
    required this.postPulse,
    required this.preSystolic,
    required this.midSystolic,
    required this.postSystolic,
    required this.preDiastolic,
    required this.midDiastolic,
    required this.postDiastolic,
    required this.preTemp,
    required this.postTemp,
    required this.preSpo2,
    required this.postSpo2,
  });

  Map<String, dynamic> toMap() {
    return {
      'preWeight': preWeight,
      'postWeight': postWeight,
      'prePulse': prePulse,
      'midPulse': midPulse,
      'postPulse': postPulse,
      'preSystolic': preSystolic,
      'midSystolic': midSystolic,
      'postSystolic': postSystolic,
      'preDiastolic': preDiastolic,
      'midDiastolic': midDiastolic,
      'postDiastolic': postDiastolic,
      'preTemp': preTemp,
      'postTemp': postTemp,
      'preSpo2': preSpo2,
      'postSpo2': postSpo2,
    };
  }

  factory VitalSigns.fromMap(Map<String, dynamic> map) {
    return VitalSigns(
      preWeight: map['preWeight'] ?? '',
      postWeight: map['postWeight'] ?? '',
      prePulse: map['prePulse'] ?? '',
      midPulse: map['midPulse'] ?? '',
      postPulse: map['postPulse'] ?? '',
      preSystolic: map['preSystolic'] ?? '',
      midSystolic: map['midSystolic'] ?? '',
      postSystolic: map['postSystolic'] ?? '',
      preDiastolic: map['preDiastolic'] ?? '',
      midDiastolic: map['midDiastolic'] ?? '',
      postDiastolic: map['postDiastolic'] ?? '',
      preTemp: map['preTemp'] ?? '',
      postTemp: map['postTemp'] ?? '',
      preSpo2: map['preSpo2'] ?? '',
      postSpo2: map['postSpo2'] ?? '',
    );
  }
}

class TreatmentParameters {
  final String actualBloodFlowRate;
  final String totalBloodProcessed;
  final String dialyzerType;
  final String arterialPressure;
  final String actualDialysisFlowRate;
  final String heparinBolus;
  final String accessCondition;
  final String venousPressure;
  final String actualUltrafiltration;
  final String heparinRate;
  final String needleSize;
  final String tmp;
  final List<BloodPressureEntry> bloodPressureEntries;

  TreatmentParameters({
    required this.actualBloodFlowRate,
    required this.totalBloodProcessed,
    required this.dialyzerType,
    required this.arterialPressure,
    required this.actualDialysisFlowRate,
    required this.heparinBolus,
    required this.accessCondition,
    required this.venousPressure,
    required this.actualUltrafiltration,
    required this.heparinRate,
    required this.needleSize,
    required this.tmp,
    this.bloodPressureEntries = const [],
  });

  Map<String, dynamic> toMap() => {
        'actualBloodFlowRate': actualBloodFlowRate,
        'totalBloodProcessed': totalBloodProcessed,
        'dialyzerType': dialyzerType,
        'arterialPressure': arterialPressure,
        'actualDialysisFlowRate': actualDialysisFlowRate,
        'heparinBolus': heparinBolus,
        'accessCondition': accessCondition,
        'venousPressure': venousPressure,
        'actualUltrafiltration': actualUltrafiltration,
        'heparinRate': heparinRate,
        'needleSize': needleSize,
        'tmp': tmp,
        'bloodPressureEntries':
            bloodPressureEntries.map((e) => e.toMap()).toList(),
      };

  factory TreatmentParameters.fromMap(Map<String, dynamic> map) {
    return TreatmentParameters(
      actualBloodFlowRate: map['actualBloodFlowRate'] ?? '',
      totalBloodProcessed: map['totalBloodProcessed'] ?? '',
      dialyzerType: map['dialyzerType'] ?? '',
      arterialPressure: map['arterialPressure'] ?? '',
      actualDialysisFlowRate: map['actualDialysisFlowRate'] ?? '',
      heparinBolus: map['heparinBolus'] ?? '',
      accessCondition: map['accessCondition'] ?? '',
      venousPressure: map['venousPressure'] ?? '',
      actualUltrafiltration: map['actualUltrafiltration'] ?? '',
      heparinRate: map['heparinRate'] ?? '',
      needleSize: map['needleSize'] ?? '',
      tmp: map['tmp'] ?? '',
      bloodPressureEntries: (map['bloodPressureEntries'] as List<dynamic>?)
              ?.map((e) => BloodPressureEntry.fromMap(e))
              .toList() ??
          [],
    );
  }
}

class SerologyResults {
  final String? hcvResult;
  final String? hbsagResult;
  final String? hivResult;
  final String? hcvRnaResult;
  final String? pcrResult;

  SerologyResults({
    this.hcvResult,
    this.hbsagResult,
    this.hivResult,
    this.hcvRnaResult,
    this.pcrResult,
  });

  Map<String, dynamic> toMap() {
    return {
      'hcvResult': hcvResult,
      'hbsagResult': hbsagResult,
      'hivResult': hivResult,
      'hcvRnaResult': hcvRnaResult,
      'pcrResult': pcrResult,
    };
  }

  factory SerologyResults.fromMap(Map<String, dynamic> map) {
    return SerologyResults(
      hcvResult: map['hcvResult'],
      hbsagResult: map['hbsagResult'],
      hivResult: map['hivResult'],
      hcvRnaResult: map['hcvRnaResult'],
      pcrResult: map['pcrResult'],
    );
  }

  SerologyResults copyWith({
    String? hcvResult,
    String? hbsagResult,
    String? hivResult,
    String? hcvRnaResult,
    String? pcrResult,
  }) {
    return SerologyResults(
      hcvResult: hcvResult ?? this.hcvResult,
      hbsagResult: hbsagResult ?? this.hbsagResult,
      hivResult: hivResult ?? this.hivResult,
      hcvRnaResult: hcvRnaResult ?? this.hcvRnaResult,
      pcrResult: pcrResult ?? this.pcrResult,
    );
  }
}

class LaboratoryValues {
  final String preBun;
  final String preCreatinine;
  final String prePotassium;
  final String preSodium;
  final String preHaemoglobin;
  final String preSGOT;
  final String preSGPT;
  final String postBun;
  final String postCreatinine;
  final String postPotassium;
  final String postSodium;
  final String postHaemoglobin;
  final String postSGOT;
  final String postSGPT;
  final SerologyResults serologyResults;

  LaboratoryValues({
    required this.preBun,
    required this.preCreatinine,
    required this.prePotassium,
    required this.preSodium,
    required this.preHaemoglobin,
    required this.preSGOT,
    required this.preSGPT,
    required this.postBun,
    required this.postCreatinine,
    required this.postPotassium,
    required this.postSodium,
    required this.postHaemoglobin,
    required this.postSGOT,
    required this.postSGPT,
    required this.serologyResults,
  });

  Map<String, dynamic> toMap() {
    return {
      'preBun': preBun,
      'preCreatinine': preCreatinine,
      'prePotassium': prePotassium,
      'preSodium': preSodium,
      'preHaemoglobin': preHaemoglobin,
      'preSGOT': preSGOT,
      'preSGPT': preSGPT,
      'postBun': postBun,
      'postCreatinine': postCreatinine,
      'postPotassium': postPotassium,
      'postSodium': postSodium,
      'postHaemoglobin': postHaemoglobin,
      'postSGOT': postSGOT,
      'postSGPT': postSGPT,
      'serologyResults': serologyResults.toMap(),
    };
  }

  factory LaboratoryValues.fromMap(Map<String, dynamic> map) {
    return LaboratoryValues(
      preBun: map['preBun'] ?? '',
      preCreatinine: map['preCreatinine'] ?? '',
      prePotassium: map['prePotassium'] ?? '',
      preSodium: map['preSodium'] ?? '',
      preHaemoglobin: map['preHaemoglobin'] ?? '',
      preSGOT: map['preSGOT'] ?? '',
      preSGPT: map['preSGPT'] ?? '',
      postBun: map['postBun'] ?? '',
      postCreatinine: map['postCreatinine'] ?? '',
      postPotassium: map['postPotassium'] ?? '',
      postSodium: map['postSodium'] ?? '',
      postHaemoglobin: map['postHaemoglobin'] ?? '',
      postSGOT: map['postSGOT'] ?? '',
      postSGPT: map['postSGPT'] ?? '',
      serologyResults: SerologyResults.fromMap(map['serologyResults'] ?? {}),
    );
  }
}

class ClinicalNotes {
  final String machineAlarm;
  final String nursingInterventions;
  final String patientTolerance;
  final String symptomsDuringTreatment;
  final String complicationsDetails;
  final String actionTaken;
  final String remarks;

  ClinicalNotes({
    required this.machineAlarm,
    required this.nursingInterventions,
    required this.patientTolerance,
    required this.symptomsDuringTreatment,
    required this.complicationsDetails,
    required this.actionTaken,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'machineAlarm': machineAlarm,
      'nursingInterventions': nursingInterventions,
      'patientTolerance': patientTolerance,
      'symptomsDuringTreatment': symptomsDuringTreatment,
      'complicationsDetails': complicationsDetails,
      'actionTaken': actionTaken,
      'remarks': remarks,
    };
  }

  factory ClinicalNotes.fromMap(Map<String, dynamic> map) {
    return ClinicalNotes(
      machineAlarm: map['machineAlarm'] ?? '',
      nursingInterventions: map['nursingInterventions'] ?? '',
      patientTolerance: map['patientTolerance'] ?? '',
      symptomsDuringTreatment: map['symptomsDuringTreatment'] ?? '',
      complicationsDetails: map['complicationsDetails'] ?? '',
      actionTaken: map['actionTaken'] ?? '',
      remarks: map['remarks'] ?? '',
    );
  }
}
