import 'package:flutter/material.dart';

class ElectronicHealthRecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Electronic Health Record"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () {
              // Handle QR code scanner
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Handle sharing functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPatientInfoCard(),
              const SizedBox(height: 20),
              _buildSectionTitle("Personal Information"),
              _buildInfoRow("Date of Birth", "1993-04-07"),
              _buildInfoRow("Phone", "01852533405"),
              const SizedBox(height: 20),
              _buildSectionTitle("Consultation History"),
              _buildConsultationCard(
                doctorName: "Dr. Faysal Rana",
                doctorDetails:
                    "PGT, CCD, MBBS, BCS (Health)\nGeneral Physician, Endocrinology",
                date: "26 August 2022",
              ),
              _buildConsultationCard(
                doctorName: "Dr. Faysal Rana",
                doctorDetails:
                    "PGT, CCD, MBBS, BCS (Health)\nGeneral Physician, Endocrinology",
                date: "24 August 2022",
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Handle "View More Consultations"
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("View More Consultations"),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              child: const Text(
                "Z",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Zishan Ahmed (Myself)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("31Y  7M  - Male - 67 Kg"),
                SizedBox(height: 4),
                Text("ID: 542008", style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            Spacer(),
            Icon(Icons.share, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildConsultationCard({
    required String doctorName,
    required String doctorDetails,
    required String date,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    doctorDetails,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(date),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(Icons.picture_as_pdf, color: Colors.blue),
                SizedBox(height: 8),
                Text(
                  "Prescription",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
