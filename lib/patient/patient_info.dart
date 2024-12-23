import 'package:flutter/material.dart';

import './patient_info_update.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(context, UpdatePatientScreen()),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: "Personal Information",
              children: [
                _buildProfileRow(label: "Gender", value: "Male"),
                _buildProfileRow(
                    label: "Date of Birth", value: "07 April 1993"),
                _buildProfileRow(label: "Profession", value: "Architect"),
              ],
            ),
            _buildSectionCard(
              title: "Contact Information",
              children: [
                _buildProfileRow(label: "Phone Number", value: "01852533405"),
                _buildProfileRow(
                    label: "Email Address", value: "zishan.ahmed@example.com"),
              ],
            ),
            _buildSectionCard(
              title: "Location Details",
              children: [
                _buildProfileRow(label: "District", value: "Dhaka"),
                _buildProfileRow(label: "Sub District", value: "Mohammadpur"),
                _buildProfileRow(label: "Union / Ward", value: "Ward 10"),
              ],
            ),
            _buildSectionCard(
              title: "Physical Statistics",
              children: [
                _buildProfileRow(label: "Height", value: "175 cm"),
                _buildProfileRow(label: "Weight", value: "70 kg"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context,Widget screen) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.blue,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                'https://a.storyblok.com/f/191576/1200x800/a3640fdc4c/profile_picture_maker_before.webp'),
            // Replace with NetworkImage or FileImage for dynamic images
          ),
          IconButton(onPressed: (){Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );}, icon: Icon(Icons.edit,color: Colors.white,)),
          SizedBox(height: 10),
          Text(
            "Haider Ali",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(
            "Architect",
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
