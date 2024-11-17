import 'package:flutter/material.dart';

class FindDoctorScreen extends StatefulWidget {
  const FindDoctorScreen({Key? key}) : super(key: key);

  @override
  _FindDoctorScreenState createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  bool telemedicineToggle = false;
  String searchQuery = "";
  String selectedSpecialty = "";

  final List<Map<String, String>> doctors = [
    {
      "name": "Dr. Salah Uddin Sazeeb",
      "qualification": "MBBS, MS, CCD",
      "specialty": "Otolaryngology, Specialist GP",
      "organization":
          "Sir Salimullah Medical College & Mitford Hospital, Mitford",
    },
    {
      "name": "Dr. Amit Banarjee",
      "qualification": "FCPS (Medicine), MBBS, MACP",
      "specialty": "General Physician, Medicine",
      "organization": "",
    },
    {
      "name": "Dr. Moniruzzaman",
      "qualification": "DLO, CCD",
      "specialty": "Ear, Nose and Throat (ENT)",
      "organization": "",
    },
    // Add more doctor data here as needed
  ];

  final List<Map<String, dynamic>> specialties = [
    {"name": "Psychology", "icon": Icons.psychology},
    {"name": "Surgery", "icon": Icons.health_and_safety},
    {"name": "Physical Medicine", "icon": Icons.fitness_center},
    {"name": "Physiotherapy", "icon": Icons.accessibility_new},
    {"name": "Neuro Medicine", "icon": Icons.medical_services},
    {"name": "Cardiology", "icon": Icons.favorite},
    {"name": "Orthopedic", "icon": Icons.accessible},
    {"name": "Nephrology", "icon": Icons.local_hospital},
    {"name": "Darmatology", "icon": Icons.face},
    {"name": "Gynocology", "icon": Icons.female},
    {"name": "Pediatric", "icon": Icons.child_care},
    {"name": "Dental", "icon": Icons.medical_services},
    {"name": "Medicine", "icon": Icons.health_and_safety},
    // Add more specialties if needed
  ];

  List<Map<String, String>> get filteredDoctors {
    return doctors.where((doctor) {
      final matchesSearchQuery = searchQuery.isEmpty ||
          doctor["name"]!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          doctor["organization"]!
              .toLowerCase()
              .contains(searchQuery.toLowerCase());

      final matchesSpecialty =
          selectedSpecialty.isEmpty || doctor["specialty"] == selectedSpecialty;

      return matchesSearchQuery && matchesSpecialty;
    }).toList();
  }

  void openSpecialtyFilterDialog() {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
                maxHeight: deviceHeight * 0.75, maxWidth: deviceWidth * 0.75),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Find By Specialty",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.green),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: specialties.length,
                    itemBuilder: (context, index) {
                      final specialty = specialties[index];
                      return Column(
                        children: [
                          ListTile(
                            leading:
                                Icon(specialty["icon"], color: Colors.green),
                            title: Text(
                              specialty["name"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedSpecialty = specialty["name"];
                              });
                              Navigator.pop(context);
                            },
                          ),
                          if (index < specialties.length - 1) const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Doctor"),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Find By Doctor/ Organization Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: openSpecialtyFilterDialog,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    "Telemedicine",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: telemedicineToggle,
                    onChanged: (value) {
                      setState(() {
                        telemedicineToggle = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = filteredDoctors[index];
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(doctor["name"]!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doctor["qualification"]!),
                            Text("Specialty: ${doctor["specialty"]!}"),
                            if (doctor["organization"] != null &&
                                doctor["organization"]!.isNotEmpty)
                              Text("Organization: ${doctor["organization"]!}"),
                          ],
                        ),
                        trailing: telemedicineToggle
                            ? const Icon(Icons.video_call)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
