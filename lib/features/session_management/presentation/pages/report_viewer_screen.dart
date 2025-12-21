import 'dart:typed_data';

import 'package:ecare360/data/models/session_data_model.dart';
import 'package:ecare360/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportViewerScreen extends StatelessWidget {
  final String patientId;
  final DateTime sessionDate;

  const ReportViewerScreen(
      {super.key, required this.patientId, required this.sessionDate});

  Future<SessionData?> _fetchSessionData() async {
    return await LocalStorageService.fetchSessionData(patientId, sessionDate);
  }

  pw.Widget _buildKeyValueTable(Map<String, String?> data) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
      },
      children: data.entries.map((entry) {
        return pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child:
                  pw.Text(entry.key, style: const pw.TextStyle(fontSize: 11)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                (entry.value == null || entry.value!.isEmpty)
                    ? '-'
                    : entry.value!,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  pw.Widget _buildTableSection(String title, pw.Widget table) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),
        pw.Text(title,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
        pw.SizedBox(height: 6),
        table,
      ],
    );
  }

  pw.Widget _buildSignatureTable() {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Text('Doctor Signature'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Text('Nurse Signature'),
          ),
        ]),
      ],
    );
  }

  pw.Widget _buildPatientHeader(SessionData data) {
    return _buildKeyValueTable({
      'Patient ID': data.patientId,
      'Session Date': data.sessionDate.toString().split(' ').first,
    });
  }

  pw.Widget _buildVitalSignsTable(SessionData data) {
    return _buildKeyValueTable({
      'Pre Weight (Kg)': data.vitalSigns.preWeight,
      'Post Weight (Kg)': data.vitalSigns.postWeight,
      'Pre Pulse': data.vitalSigns.prePulse,
      'Mid Pulse': data.vitalSigns.midPulse,
      'Post Pulse': data.vitalSigns.postPulse,
      'Pre Systolic': data.vitalSigns.preSystolic,
      'Mid Systolic': data.vitalSigns.midSystolic,
      'Post Systolic': data.vitalSigns.postSystolic,
      'Pre Diastolic': data.vitalSigns.preDiastolic,
      'Mid Diastolic': data.vitalSigns.midDiastolic,
      'Post Diastolic': data.vitalSigns.postDiastolic,
      'Pre Temperature': data.vitalSigns.preTemp,
      'Post Temperature': data.vitalSigns.postTemp,
      'Pre SpO₂': data.vitalSigns.preSpo2,
      'Post SpO₂': data.vitalSigns.postSpo2,
    });
  }

  pw.Widget _buildTreatmentParamsTable(SessionData data) {
    final t = data.treatmentParameters;

    return _buildKeyValueTable({
      'Actual Blood Flow Rate': t.actualBloodFlowRate,
      'Total Blood Processed': t.totalBloodProcessed,
      'Dialyzer Type': t.dialyzerType,
      'Arterial Pressure': t.arterialPressure,
      'Dialysis Flow Rate': t.actualDialysisFlowRate,
      'Heparin Bolus': t.heparinBolus,
      'Access Condition': t.accessCondition,
      'Venous Pressure': t.venousPressure,
      'Actual Ultrafiltration': t.actualUltrafiltration,
      'Heparin Rate': t.heparinRate,
      'Needle Size': t.needleSize,
      'TMP': t.tmp,
    });
  }

  String _formatSerologyResult(String? result) {
    if (result == null || result.isEmpty) return '-';
    if (result == 'BinaryResult.positive') return '+ve';
    if (result == 'BinaryResult.negative') return '-ve';
    if (result == 'ReactiveResult.reactive') return 'Reactive';
    if (result == 'ReactiveResult.nonReactive') return 'Non-Reactive';
    return result; // Fallback for unexpected values
  }

  pw.Widget _buildLaboratoryTable(SessionData data) {
    final l = data.laboratoryValues;

    return _buildKeyValueTable({
      'Pre BUN': l.preBun,
      'Pre Creatinine': l.preCreatinine,
      'Pre Potassium': l.prePotassium,
      'Pre Sodium': l.preSodium,
      'Pre Haemoglobin': l.preHaemoglobin,
      'Pre SGOT': l.preSGOT,
      'Pre SGPT': l.preSGPT,
      'Post Haemoglobin': l.postHaemoglobin,
      'Post SGOT': l.postSGOT,
      'Post SGPT': l.postSGPT,
      'HCV': _formatSerologyResult(l.serologyResults.hcvResult),
      'HBsAg': _formatSerologyResult(l.serologyResults.hbsagResult),
      'HIV': _formatSerologyResult(l.serologyResults.hivResult),
      'HCV RNA': _formatSerologyResult(l.serologyResults.hcvRnaResult),
      'PCR': _formatSerologyResult(l.serologyResults.pcrResult),
    });
  }

  pw.Widget _buildClinicalNotesTable(SessionData data) {
    final c = data.clinicalNotes;

    return _buildKeyValueTable({
      'Machine Alarm': c.machineAlarm,
      'Patient Tolerance': c.patientTolerance,
      'Nursing Interventions': c.nursingInterventions,
      'Symptoms During Treatment': c.symptomsDuringTreatment,
      'Complications Details': c.complicationsDetails,
      'Action Taken': c.actionTaken,
      'Remarks': c.remarks,
    });
  }

  pw.Widget _buildBloodPressureTable(List<BloodPressureEntry> entries) {
    if (entries.isEmpty) {
      return _buildKeyValueTable({'Blood Pressure': '-'});
    }

    final Map<int, String> map = {for (var e in entries) e.time: e.bpValue};

    final int maxMinute =
        entries.map((e) => e.time).reduce((a, b) => a > b ? a : b);

    final List<pw.Widget> widgets = [];
    int hour = 1;

    for (int start = 15; start <= maxMinute; start += 60) {
      final mins = [start, start + 15, start + 30, start + 45];

      widgets.add(
        pw.Text('Hour $hour',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      );

      widgets.add(
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          children: [
            pw.TableRow(
              children: mins
                  .map((m) => pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child:
                            pw.Text('$m min', textAlign: pw.TextAlign.center),
                      ))
                  .toList(),
            ),
            pw.TableRow(
              children: mins
                  .map((m) => pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(map[m] ?? '-',
                            textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ))
                  .toList(),
            ),
          ],
        ),
      );

      widgets.add(pw.SizedBox(height: 6));
      hour++;
    }

    return pw.Column(children: widgets);
  }

  List<pw.Widget> _buildBpReportTable(List<BloodPressureEntry> entries) {
    if (entries.isEmpty) {
      return [
        _buildDetailRow('Blood Pressure', '-'),
      ];
    }

    // Map minute → value
    final Map<int, String> bpMap = {
      for (var e in entries) e.time: e.bpValue,
    };

    final int maxMinute =
        entries.map((e) => e.time).reduce((a, b) => a > b ? a : b);

    final List<pw.Widget> widgets = [];

    int hour = 1;
    for (int start = 15; start <= maxMinute; start += 60) {
      final minutes = [
        start,
        start + 15,
        start + 30,
        start + 45,
      ];

      widgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 6),
          child: pw.Text(
            'Hour $hour',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      );

      widgets.add(
        pw.Table(
          border: pw.TableBorder.all(width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1),
            3: const pw.FlexColumnWidth(1),
          },
          children: [
            // Minute row
            pw.TableRow(
              children: minutes
                  .map(
                    (m) => pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('$m min',
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 10)),
                    ),
                  )
                  .toList(),
            ),
            // Value row
            pw.TableRow(
              children: minutes
                  .map(
                    (m) => pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        bpMap[m] ?? '-',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
      hour++;
    }
    return widgets;
  }

  Future<Uint8List> _generatePdf(SessionData sessionData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text('Dialysis Session Report',
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          _buildTableSection(
              'Patient Details', _buildPatientHeader(sessionData)),
          _buildTableSection('Vital Signs', _buildVitalSignsTable(sessionData)),
          _buildTableSection(
              'Treatment Parameters', _buildTreatmentParamsTable(sessionData)),
          _buildTableSection(
            'Blood Pressure Monitoring',
            _buildBloodPressureTable(
              sessionData.treatmentParameters.bloodPressureEntries,
            ),
          ),
          _buildTableSection('Laboratory Values',
              _buildLaboratoryTable(sessionData)), // same pattern
          _buildTableSection(
              'Clinical Notes', _buildClinicalNotesTable(sessionData)),
          _buildTableSection('Signatures', _buildSignatureTable()),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildSection(
      pw.Context context, String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 15),
        pw.Text(title,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
        pw.Divider(),
        ...children,
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _buildDetailRow(String label, String? value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
          pw.Text(
            (value == null || value.isEmpty) ? '-' : value,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session Report')),
      body: FutureBuilder<SessionData?>(
        future: _fetchSessionData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final sessionData = snapshot.data!;
            return PdfPreview(
              build: (format) => _generatePdf(sessionData),
            );
          } else {
            return const Center(child: Text('No session data found.'));
          }
        },
      ),
    );
  }
}
