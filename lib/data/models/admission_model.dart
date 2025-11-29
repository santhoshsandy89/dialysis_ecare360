class AdmissionModel {
  final String patientId;
  final String patientName;
  final String bedId;
  final String specialization;
  final List<String> admittedFor;
  final String admittedByDoctorId;
  final String admittedByDoctorName;
  final String? mrn;
  final String phoneNumber;
  final String dateOfAdmission;
  final String trackingId;
  final String? dateOfDischarge;
  final String admissionType;
  final String sourceName;
  final String sourceId;
  final String campaignId;
  final String campaignName;
  final String schemeId;
  final String schemeName;
  final String schemeNumber;
  final bool isCharged;
  final Map<String, dynamic> medicolegalCase;
  final List<Map<String, String>> attendees;
  final int bedStatus;

  AdmissionModel({
    required this.patientId,
    required this.patientName,
    required this.bedId,
    required this.specialization,
    required this.admittedFor,
    required this.admittedByDoctorId,
    required this.admittedByDoctorName,
    required this.mrn,
    required this.phoneNumber,
    required this.dateOfAdmission,
    required this.trackingId,
    required this.dateOfDischarge,
    required this.admissionType,
    required this.sourceName,
    required this.sourceId,
    required this.campaignId,
    required this.campaignName,
    required this.schemeId,
    required this.schemeName,
    required this.schemeNumber,
    required this.isCharged,
    required this.medicolegalCase,
    required this.attendees,
    required this.bedStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      "patientId": patientId,
      "patientName": patientName,
      "bedId": bedId,
      "specialization": specialization,
      "admittedFor": admittedFor,
      "admittedByDoctorId": admittedByDoctorId,
      "admittedByDoctorName": admittedByDoctorName,
      "mrn": mrn,
      "phoneNumber": phoneNumber,
      "dateOfAdmission": dateOfAdmission,
      "trackingId": trackingId,
      "dateOfDischarge": dateOfDischarge,
      "admissionType": admissionType,
      "sourceName": sourceName,
      "sourceId": sourceId,
      "campaignId": campaignId,
      "campaignName": campaignName,
      "schemeId": schemeId,
      "schemeName": schemeName,
      "schemeNumber": schemeNumber,
      "isCharged": isCharged,
      "medicolegalCase": medicolegalCase,
      "attendees": attendees,
      "bedStatus": bedStatus,
    };
  }

  factory AdmissionModel.fromForm({
    required String patientId,
    required String patientName,
    required String bedId,
    required String admittedFor,
    required String doctorId,
    required String doctorName,
    required String phoneNumber,
    required DateTime dateOfAdmission,
    required String trackingId,
    required List<Map<String, String>> attendees,
    required int bedStatus,
  }) {
    return AdmissionModel(
      patientId: patientId,
      patientName: patientName,
      bedId: bedId,
      specialization: "General",
      admittedFor: [admittedFor],
      admittedByDoctorId: doctorId,
      admittedByDoctorName: doctorName,
      mrn: '123555',
      phoneNumber: phoneNumber,
      dateOfAdmission: dateOfAdmission.toIso8601String(),
      trackingId: trackingId,
      dateOfDischarge: null,
      admissionType: "normal",
      sourceName: "",
      sourceId: "",
      campaignId: "",
      campaignName: "",
      schemeId: "",
      schemeName: "",
      schemeNumber: "",
      isCharged: true,
      medicolegalCase: {},
      attendees: attendees,
      bedStatus: bedStatus,
    );
  }
}
