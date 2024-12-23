import 'package:flutter/material.dart';

import './find_doctor.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String imageBaseUrl = "https://rxbackend.crp-carerapidpoint.com/";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;

    String? imageUrl = doctor["doctor_image"];

    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = imageBaseUrl + imageUrl;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("ডাক্তারের অ্যাপয়েন্টমেন্ট",
            style: const TextStyle(color: Colors.black)),
        iconTheme:
            const IconThemeData(color: Colors.black), // Back button color
      ),
      body: Column(
        children: [
          // Doctor's image and name section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.green.shade50,
            child: Row(
              children: [
                // Doctor's image
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.green,
                  backgroundImage:
                      imageUrl != null ? NetworkImage(imageUrl) : null,
                  child: imageUrl == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 16),
                // Doctor's name and degree
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor['displayName'] ?? "N/A",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor['degree'] ?? "N/A",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tab bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "আপয়েন্টমেন্ট"),
              Tab(text: "ডাক্তারের প্রোফাইল"),
            ],
            indicatorColor: Colors.green,
          ),
          // Tab bar content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AppointmentInfoTab(doctor: doctor),
                DoctorProfileTab(doctor: doctor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentInfoTab extends StatefulWidget {
  final Map<String, dynamic> doctor;
  const AppointmentInfoTab({super.key, required this.doctor});

  @override
  State<AppointmentInfoTab> createState() => _AppointmentInfoTabState();
}

class _AppointmentInfoTabState extends State<AppointmentInfoTab> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text("কত তারিখে দেখতে চান?",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          // const TextField(
          //   readOnly: true,
          //   decoration: InputDecoration(
          //     hintText: "Dec 8, 2024",
          //     prefixIcon: Icon(Icons.calendar_today),
          //     filled: true,
          //     fillColor: Colors.white,
          //   ),
          // ),
          GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(), // Prevent selecting past dates
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            child: AbsorbPointer(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText:
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                  prefixIcon: const Icon(Icons.calendar_month_outlined),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text("কোন চেম্বারে দেখতে চান?",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: widget.doctor['work_at']?.split(',').first,
            items: [
              if (widget.doctor['work_at'] != null) ...[
                DropdownMenuItem(
                  value: widget.doctor['work_at'],
                  child: Text(
                    widget.doctor['work_at'],
                  ),
                )
              ]
            ],
            onChanged: (value) {},
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone, color: Colors.green),
              const SizedBox(width: 8),
              Text(widget.doctor['phone'] ?? "N/A",
                  style: const TextStyle(fontSize: 16))
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.call),
            label: const Text("কল করুন"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 50),
            ),
          )
        ],
      ),
    );
  }
}

class DoctorProfileTab extends StatelessWidget {
  final Map<String, dynamic> doctor;
  const DoctorProfileTab({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ডাক্তার সম্পর্কে",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(doctor['bio'] ?? "N/A"),
            const SizedBox(height: 16),
            Text("অভিজ্ঞতা", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(doctor['experience'] ?? "N/A"),
            const SizedBox(height: 16),
            Text("বিশেষজ্ঞ", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(doctor['speciality'] ?? "N/A"),
            const SizedBox(height: 16),
            Text("শিক্ষা/ডিগ্রি",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(doctor['degree'] ?? "N/A"),
          ],
        ),
      ),
    );
  }
}
