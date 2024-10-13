import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final CarouselSliderController _footerCarouselController =
      CarouselSliderController();
  int _currentPromoIndex = 0;
  int _currentFooterIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List of promotional and footer banners
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

    // Promotional URLs
    final List<String> promoLinks = [
      'https://promo-site-1.com',
      'https://promo-site-2.com',
      'https://promo-site-3.com',
    ];

    // Footer URLs
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
            const UserAccountsDrawerHeader(
              accountName: Text('Logged in'),
              accountEmail: Text('Welcome'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.green),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Logout'),
              onTap: () {
                // Handle Logout
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Promotional Banner with Carousel
            _buildCarouselWithDots(
              images: promoBanners,
              currentIndex: _currentPromoIndex,
              carouselController: _carouselController,
              onPageChanged: (index) {
                setState(() {
                  _currentPromoIndex = index;
                });
              },
              links: promoLinks,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildGridItem('ডাক্তার খুঁজুন', Icons.search),
                  _buildGridItem('ফলোআপ', Icons.update),
                  _buildGridItem('অ্যাপয়েন্টমেন্ট', Icons.calendar_today),
                  _buildGridItem('প্রেসক্রিপশন', Icons.medication),
                  _buildGridItem('আমার ডাক্তার', Icons.person),
                  _buildGridItem('হেলথ চেক-আপ', Icons.health_and_safety),
                  _buildGridItem('হোম টেস্ট', Icons.home),
                  _buildGridItem('ইন্স্যুরেন্স', Icons.shield),
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
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildGridItem('জেনারেল প্র্যাকটিস...', Icons.local_hospital),
                  _buildGridItem('জন্ডিস, হেপাটাইট...', Icons.person),
                  _buildGridItem('স্ত্রী ও প্রসূতি', Icons.pregnant_woman),
                  _buildGridItem('অর্থোপেডিক', Icons.healing),
                  _buildGridItem('ডায়াবেটোলজি', Icons.bloodtype),
                  _buildGridItem('খাদ্য ও পুষ্টি', Icons.food_bank),
                  _buildGridItem('নাক, কান ও গলা', Icons.person_2),
                  _buildGridItem('হৃদরোগ', Icons.favorite),
                ],
              ),
            ),
            // Footer Banner with Carousel
            _buildCarouselWithDots(
              images: footerBanners,
              currentIndex: _currentFooterIndex,
              carouselController: _footerCarouselController,
              onPageChanged: (index) {
                setState(() {
                  _currentFooterIndex = index;
                });
              },
              links: footerLinks,
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the carousel with dots and linking
  Widget _buildCarouselWithDots({
    required List<String> images,
    required int currentIndex,
    required CarouselSliderController carouselController,
    required Function(int) onPageChanged,
    required List<String> links, // Link associated with each image
  }) {
    return Column(
      children: [
        CarouselSlider(
          items: images
              .asMap()
              .entries
              .map((entry) => InkWell(
                    onTap: () => _launchURL(
                        links[entry.key]), // Open link when banner is clicked
                    child: Image.asset(
                      entry.value,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ))
              .toList(),
          carouselController: carouselController,
          options: CarouselOptions(
            height: 150,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 8),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              onPageChanged(index);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            return InkWell(
              onTap: () {
                carouselController.animateToPage(entry.key,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (currentIndex == entry.key
                      ? Colors.black
                      : Colors
                          .grey), // Color changes based on the current index
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGridItem(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Clicked on $title')));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.green),
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

  Future<void> _launchURL(String url) async {
    // Handle URL launching
  }
}
