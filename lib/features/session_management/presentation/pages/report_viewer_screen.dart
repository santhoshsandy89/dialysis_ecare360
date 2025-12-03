import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ecare360/data/models/session_data_model.dart';
import 'package:ecare360/data/services/local_storage_service.dart';

class ReportViewerScreen extends StatelessWidget {
  final String patientId;

  const ReportViewerScreen({super.key, required this.patientId});

  Future<SessionData?> _fetchSessionData() async {
    return await LocalStorageService.fetchSessionData(patientId);
  }

  Future<Uint8List> _generatePdf(SessionData sessionData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
                'Session Report for Patient: ${sessionData.patientId}',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
          ),
          pw.SizedBox(height: 20),
          _buildSection(context, 'Vital Signs', [
            _buildDetailRow(
                'Blood Pressure', sessionData.vitalSigns.bloodPressure),
            _buildDetailRow('Heart Rate', sessionData.vitalSigns.heartRate),
            _buildDetailRow('Temperature', sessionData.vitalSigns.temperature),
          ]),
          _buildSection(context, 'Treatment Parameters', [
            _buildDetailRow('Dialysis Duration',
                sessionData.treatmentParameters.dialysisDuration),
            _buildDetailRow(
                'Dialyzer Type', sessionData.treatmentParameters.dialyzerType),
            _buildDetailRow(
                'Flow Rate', sessionData.treatmentParameters.flowRate),
          ]),
          _buildSection(context, 'Laboratory Values', [
            _buildDetailRow(
                'Hemoglobin', sessionData.laboratoryValues.hemoglobin),
            _buildDetailRow(
                'Creatinine', sessionData.laboratoryValues.creatinine),
            _buildDetailRow(
                'Potassium', sessionData.laboratoryValues.potassium),
          ]),
          _buildSection(context, 'Clinical Notes', [
            _buildDetailRow('Notes', sessionData.clinicalNotes.notes),
          ]),
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

  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
          pw.Text(value,
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
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
