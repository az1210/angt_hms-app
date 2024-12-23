// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../provider.dart';
// import './doctor_details_screen.dart';

// class FindDoctorScreen extends ConsumerWidget {
//   const FindDoctorScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.read(authProvider.notifier).fetchAllUsers();

//     final authState = ref.watch(authProvider);

//     final doctors = authState.users ?? [];

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 242, 240, 239),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text("ডাক্তার খুঁজুন"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     onChanged: (value) {
//                       ref.read(authProvider.notifier).filterDoctors(value);
//                     },
//                     decoration: const InputDecoration(
//                         prefixIcon: Icon(Icons.search),
//                         hintText:
//                             "ডাক্তারের নাম / প্রতিষ্ঠানের নাম দিয়ে খুঁজুন",
//                         filled: true,
//                         fillColor: Colors.white),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.filter_list),
//                   onPressed: () => openSpecialtyFilterDialog(context, ref),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: authState.users == null
//                   ? const Center(
//                       child: CircularProgressIndicator()) // Loading indicator
//                   : doctors.isEmpty
//                       ? const Center(
//                           child: Text(
//                               "কোন ডাক্তার পাওয়া যায়নি।")) // Empty state message
//                       : ListView.builder(
//                           itemCount: doctors.length,
//                           itemBuilder: (context, index) {
//                             final doctor = doctors[index];
//                             return DoctorCard(doctor: doctor);
//                           },
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void openSpecialtyFilterDialog(BuildContext context, WidgetRef ref) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "স্পেশালিটি বেছে নিন",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close, color: Colors.green),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: ref.watch(authProvider).specialties?.length ?? 0,
//                     itemBuilder: (context, index) {
//                       final specialty =
//                           ref.watch(authProvider).specialties![index];
//                       return ListTile(
//                         title: Text(specialty),
//                         onTap: () {
//                           ref
//                               .read(authProvider.notifier)
//                               .filterBySpecialty(specialty);
//                           Navigator.pop(context);
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class DoctorCard extends StatelessWidget {
//   final Map<String, dynamic> doctor;
//   final String imageBaseUrl = "https://rxbackend.crp-carerapidpoint.com/";

//   const DoctorCard({super.key, required this.doctor});

//   @override
//   Widget build(BuildContext context) {
//     String? imageUrl = doctor["doctor_image"];

//     if (imageUrl != null && !imageUrl.startsWith('http')) {
//       imageUrl = imageBaseUrl + imageUrl;
//     }

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DoctorDetailsScreen(doctor: doctor),
//           ),
//         );
//       },
//       child: Card(
//         margin: const EdgeInsets.only(bottom: 20),
//         color: Colors.white,
//         elevation: 0.8,
//         child: ListTile(
//           leading: CircleAvatar(
//             backgroundColor: Colors.green,
//             backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
//             child: imageUrl == null
//                 ? const Icon(Icons.person, color: Colors.white)
//                 : null,
//           ),
//           title: Text(doctor["displayName"] ?? "N/A"),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(doctor["degree"] ?? "N/A"),
//               Text("বিশেষজ্ঞ: ${doctor["speciality"] ?? "N/A"}"),
//               if (doctor["work_at"] != null && doctor["work_at"].isNotEmpty)
//                 Text("কর্মস্থল: ${doctor["work_at"]}"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider.dart';
import './doctor_details_screen.dart';

class FindDoctorScreen extends ConsumerWidget {
  const FindDoctorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(authProvider.notifier).fetchAllUsers();

    final authState = ref.watch(authProvider);

    final doctors = authState.users ?? [];
    final currentPage = ref.watch(pageProvider); // Track current page
    const int doctorsPerPage = 15;

    final paginatedDoctors = doctors
        .skip((currentPage - 1) * doctorsPerPage)
        .take(doctorsPerPage)
        .toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 240, 239),
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                      ref.read(authProvider.notifier).filterDoctors(value);
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "ডাক্তারের নাম / প্রতিষ্ঠানের নাম দিয়ে খুঁজুন",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => openSpecialtyFilterDialog(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: authState.users == null
                  ? const Center(child: CircularProgressIndicator())
                  : paginatedDoctors.isEmpty
                      ? const Center(child: Text("কোন ডাক্তার পাওয়া যায়নি।"))
                      : ListView.builder(
                          itemCount: paginatedDoctors.length,
                          itemBuilder: (context, index) {
                            final doctor = paginatedDoctors[index];
                            return DoctorCard(doctor: doctor);
                          },
                        ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 1
                      ? () {
                          ref.read(pageProvider.notifier).state--;
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color.fromARGB(255, 31, 155, 95)),
                  child: const Text(
                    "Previous",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text("Page $currentPage"),
                ElevatedButton(
                  onPressed: currentPage * doctorsPerPage < doctors.length
                      ? () {
                          ref.read(pageProvider.notifier).state++;
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromARGB(255, 31, 155, 95),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void openSpecialtyFilterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
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
                Expanded(
                  child: ListView.builder(
                    itemCount: ref.watch(authProvider).specialties?.length ?? 0,
                    itemBuilder: (context, index) {
                      final specialty =
                          ref.watch(authProvider).specialties![index];
                      return ListTile(
                        title: Text(specialty),
                        onTap: () {
                          ref
                              .read(authProvider.notifier)
                              .filterBySpecialty(specialty);
                          Navigator.pop(context);
                        },
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
}

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final String imageBaseUrl = "https://rxbackend.crp-carerapidpoint.com/";

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    String? imageUrl = doctor["doctor_image"];

    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = imageBaseUrl + imageUrl;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailsScreen(doctor: doctor),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        color: Colors.white,
        elevation: 0.8,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
            child: imageUrl == null
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          title: Text(doctor["displayName"] ?? "N/A"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(doctor["degree"] ?? "N/A"),
              Text("বিশেষজ্ঞ: ${doctor["speciality"] ?? "N/A"}"),
              if (doctor["work_at"] != null && doctor["work_at"].isNotEmpty)
                Text("কর্মস্থল: ${doctor["work_at"]}"),
            ],
          ),
        ),
      ),
    );
  }
}

final pageProvider = StateProvider<int>((ref) => 1);
