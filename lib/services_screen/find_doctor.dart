import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider.dart'; // Import your provider

class FindDoctorScreen extends ConsumerStatefulWidget {
  const FindDoctorScreen({Key? key}) : super(key: key);

  @override
  _FindDoctorScreenState createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends ConsumerState<FindDoctorScreen> {
  bool telemedicineToggle = false;
  String searchQuery = "";
  String selectedSpecialty = "";

  List get filteredDoctors {
    final authState = ref.watch(authProvider);
    final doctors = authState.users ?? [];

    return doctors.where((doctor) {
      final matchesSearchQuery = searchQuery.isEmpty ||
          doctor["displayName"]!
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          doctor["work_at"]!.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesSpecialty = selectedSpecialty.isEmpty ||
          doctor["speciality"] == selectedSpecialty;

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
                      "স্পেশালিটি বেছে নিন",
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
                  onPressed: openSpecialtyFilterDialog,
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
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        backgroundImage: doctor["doctor_image"] != null
                            ? NetworkImage(doctor["doctor_image"])
                            : null,
                        child: doctor["doctor_image"] == null
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      title: Text(doctor["displayName"] ?? "N/A"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor["degree"] ?? "N/A"),
                          Text("বিশেষজ্ঞ: ${doctor["speciality"] ?? "N/A"}"),
                          if (doctor["work_at"] != null &&
                              doctor["work_at"]!.isNotEmpty)
                            Text("কর্মস্থল: ${doctor["work_at"]}"),
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
