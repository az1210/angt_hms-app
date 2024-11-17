import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'services_screen/find_doctor.dart';
import './services_screen/follow_up.dart';
import './services_screen/appointment.dart';
import './services_screen/home_test.dart';
import './services_screen/insurance.dart';
import './services_screen/my_doctor.dart';
import './services_screen/prescription.dart';
import './services_screen/cardiology.dart';
import './services_screen/diabetology.dart';
import './services_screen/ent.dart';
import './services_screen/food_nutrition.dart';
import './services_screen/general_practice.dart';
import './services_screen/gynecology.dart';
import './services_screen/health_check.dart';
import './services_screen/jaundice.dart';
import './services_screen/orthopedics.dart';

final promoIndexProvider = StateProvider<int>((ref) => 0);
final footerIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final CarouselSliderController _footerCarouselController =
      CarouselSliderController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPromoIndex = ref.watch(promoIndexProvider);
    final currentFooterIndex = ref.watch(footerIndexProvider);

    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    final List<String> promoBanners = [
      'assets/images/ace.jpg',
      'assets/images/Bufocort.jpg',
      'assets/images/Bevicort.jpg'
    ];

    final List<String> footerBanners = [
      'assets/images/BICOZIN.jpg',
      'assets/images/Bufocort.jpg',
      'assets/images/DIBENOL.jpg',
    ];

    final List<String> promoLinks = [
      'https://www.google.com',
      'https://promo-site-2.com',
      'https://promo-site-3.com',
    ];

    final List<String> footerLinks = [
      'https://footer-site-1.com',
      'https://footer-site-2.com',
      'https://footer-site-3.com',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ANGT HMS'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.menu),
        //     onPressed: () {
        //       Scaffold.of(context).openDrawer();
        //     },
        //   ),
        // ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName:
                  Text(authState.isAuthenticated ? 'Logged in' : 'Guest'),
              accountEmail:
                  Text(authState.isAuthenticated ? 'Welcome' : 'Please Login'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.green),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: Text(authState.isAuthenticated ? 'Logout' : 'Login'),
              onTap: () async {
                if (authState.isAuthenticated) {
                  authNotifier.logout();
                } else {
                  await _showLoginDialog(context, authNotifier);
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildCarouselWithDots(
                images: promoBanners,
                currentIndex: currentPromoIndex,
                carouselController: _carouselController,
                onPageChanged: (index) {
                  ref.read(promoIndexProvider.notifier).state = index;
                },
                links: promoLinks,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildGridItem('Find Doctor', Icons.search, context,
                        const FindDoctorScreen()),
                    _buildGridItem('Follow-up', Icons.update, context,
                        const FollowUpScreen()),
                    _buildGridItem('Appointment', Icons.calendar_today, context,
                        const AppointmentScreen()),
                    _buildGridItem('Prescription', Icons.medication, context,
                        const Prescription()),
                    _buildGridItem(
                        'My Doctor', Icons.person, context, const MyDoctor()),
                    _buildGridItem('Health Check-up', Icons.health_and_safety,
                        context, const HealthCheckUpScreen()),
                    _buildGridItem('Home Test', Icons.home, context,
                        const HomeTestScreen()),
                    _buildGridItem('Insurance', Icons.shield, context,
                        const InsuranceScreen()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Popular Search',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildGridItem('General Practice', Icons.local_hospital,
                        context, const GeneralPracticeScreen()),
                    _buildGridItem('Jaundice, Hepatitis', Icons.person, context,
                        const JaundiceScreen()),
                    _buildGridItem('Maternal', Icons.pregnant_woman, context,
                        const GynecologyScreen()),
                    _buildGridItem('Orthopedic', Icons.healing, context,
                        const OrthopedicsScreen()),
                    _buildGridItem('Diabetology', Icons.bloodtype, context,
                        const DiabetologyScreen()),
                    _buildGridItem('Food & Nutrition', Icons.food_bank, context,
                        const FoodNutritionScreen()),
                    _buildGridItem(
                        'ENT', Icons.person_2, context, const EntScreen()),
                    _buildGridItem('Heart Disease', Icons.favorite, context,
                        const CardiologyScreen()),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              _buildCarouselWithDots(
                images: footerBanners,
                currentIndex: currentFooterIndex,
                carouselController: _footerCarouselController,
                onPageChanged: (index) {
                  ref.read(footerIndexProvider.notifier).state = index;
                },
                links: footerLinks,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselWithDots({
    required List<String> images,
    required int currentIndex,
    required CarouselSliderController carouselController,
    required Function(int) onPageChanged,
    required List<String> links,
  }) {
    return Column(
      children: [
        CarouselSlider(
          items: images.map((imagePath) {
            return GestureDetector(
              onTap: () async {
                final url = links[images.indexOf(imagePath)];
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          }).toList(),
          carouselController: carouselController,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              onPageChanged(index);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => carouselController.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == entry.key
                      ? Colors.black
                      : Colors.black.withOpacity(0.3),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _showLoginDialog(
      BuildContext context, AuthNotifier authNotifier) async {
    String username = '';
    String password = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  username = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Username',
                ),
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Login'),
              onPressed: () async {
                await authNotifier.login(username, password);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridItem(
      String title, IconData icon, BuildContext context, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.green,
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
