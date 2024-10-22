import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

final promoIndexProvider = StateProvider<int>((ref) => 0);
final footerIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  final CarouselSliderController _carouselController = CarouselSliderController();
  final CarouselSliderController _footerCarouselController = CarouselSliderController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPromoIndex = ref.watch(promoIndexProvider);
    final currentFooterIndex = ref.watch(footerIndexProvider);

    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    final List<String> promoBanners = [
      'assets/images/ace.jpg',
      'assets/images/Axlovir.jpg',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
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
                  _buildGridItem('ডাক্তার খুঁজুন', Icons.search, context),
                  _buildGridItem('ফলোআপ', Icons.update, context),
                  _buildGridItem(
                      'অ্যাপয়েন্টমেন্ট', Icons.calendar_today, context),
                  _buildGridItem('প্রেসক্রিপশন', Icons.medication, context),
                  _buildGridItem('আমার ডাক্তার', Icons.person, context),
                  _buildGridItem(
                      'হেলথ চেক-আপ', Icons.health_and_safety, context),
                  _buildGridItem('হোম টেস্ট', Icons.home, context),
                  _buildGridItem('ইন্স্যুরেন্স', Icons.shield, context),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: const Text(
                'জনপ্রিয় সার্চ',
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
                  _buildGridItem(
                      'জেনারেল প্র্যাকটিস...', Icons.local_hospital, context),
                  _buildGridItem('জন্ডিস, হেপাটাইট...', Icons.person, context),
                  _buildGridItem(
                      'স্ত্রী ও প্রসূতি', Icons.pregnant_woman, context),
                  _buildGridItem('অর্থোপেডিক', Icons.healing, context),
                  _buildGridItem('ডায়াবেটোলজি', Icons.bloodtype, context),
                  _buildGridItem('খাদ্য ও পুষ্টি', Icons.food_bank, context),
                  _buildGridItem('নাক, কান ও গলা', Icons.person_2, context),
                  _buildGridItem('হৃদরোগ', Icons.favorite, context),
                ],
              ),
            ),
            // Footer Carousel with Dots
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
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
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

  Widget _buildGridItem(String title, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,size: 40,color: Colors.green,),
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
