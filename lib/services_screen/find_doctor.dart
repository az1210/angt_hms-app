import 'package:flutter/material.dart';

class FindDoctorScreen extends StatefulWidget {
  const FindDoctorScreen({super.key});

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

  final List<String> specialties = [
    "Otolaryngology, Specialist GP",
    "General Physician, Medicine",
    "Ear, Nose and Throat (ENT)",
    // Add more specialties as needed
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

  void openSpecialtyFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "স্পেশালিটি বেছে নিন",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: specialties.length,
                itemBuilder: (context, index) {
                  final specialty = specialties[index];
                  return ListTile(
                    title: Text(specialty),
                    onTap: () {
                      setState(() {
                        selectedSpecialty = specialty;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ডাক্তার খুঁজুন"),
      ),
      body: Padding(
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
                      hintText: "ডাক্তারের নাম / প্রতিষ্ঠানের নাম দিয়ে খুঁজুন",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: openSpecialtyFilterModal,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("টেলিমেডিসিন"),
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
                          Text("বিশেষজ্ঞ: ${doctor["specialty"]!}"),
                          if (doctor["organization"] != null &&
                              doctor["organization"]!.isNotEmpty)
                            Text("কর্মস্থল: ${doctor["organization"]!}"),
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
    );
  }
}
