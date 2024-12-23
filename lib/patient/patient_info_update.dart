import 'package:flutter/material.dart';

class UpdatePatientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Patient"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/profile_placeholder.png'),
                    // Replace with NetworkImage or FileImage for dynamic images
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // Handle change photo action
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(label: "Full Name", initialValue: "Zishan Ahmed"),
            const SizedBox(height: 10),
            _buildGenderSelection(),
            const SizedBox(height: 10),
            _buildDateOfBirthSelector(),
            const SizedBox(height: 10),
            _buildDropdownField(label: "District"),
            const SizedBox(height: 10),
            _buildDropdownField(label: "Sub District"),
            const SizedBox(height: 10),
            _buildDropdownField(label: "Union / Pourashava / Ward"),
            const SizedBox(height: 10),
            _buildTextField(label: "Phone Number", initialValue: "01852533405"),
            const SizedBox(height: 10),
            _buildTextField(label: "Email Address"),
            const SizedBox(height: 10),
            _buildDropdownField(label: "Profession", initialValue: "Architect"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(label: "Height (cm)"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(label: "Weight (kg)"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle save/update action
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, String? initialValue}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        const Text("Gender: "),
        Row(
          children: [
            Radio(value: true, groupValue: true, onChanged: (value) {}),
            const Text("Male"),
          ],
        ),
        Row(
          children: [
            Radio(value: false, groupValue: true, onChanged: (value) {}),
            const Text("Female"),
          ],
        ),
      ],
    );
  }

  Widget _buildDateOfBirthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildDropdownField(
              label: "Day",
              items: List.generate(31, (index) => (index + 1).toString())),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDropdownField(
            label: "Month",
            items: [
              "January",
              "February",
              "March",
              "April",
              "May",
              "June",
              "July",
              "August",
              "September",
              "October",
              "November",
              "December"
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDropdownField(
            label: "Year",
            items: List.generate(100, (index) => (2023 - index).toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
      {required String label, String? initialValue, List<String>? items}) {
    return DropdownButtonFormField<String>(
      value: initialValue,
      items: items
          ?.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (value) {},
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
