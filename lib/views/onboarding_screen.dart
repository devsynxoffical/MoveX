import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movex/views/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controllers/onboarding_controller.dart';
import 'package:movex/controllers/onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int pageIndex = 0;

  final List<_PageData> pages = [
    _PageData(
      icon: Icons.local_taxi,
      title: "Welcome to Move X",
      subtitle:
          "Start earning by accepting rides near you and driving on your schedule.",
    ),
    _PageData(
      icon: Icons.shield,
      title: "Your Safety Comes First",
      subtitle:
          "Emergency assistance, ride tracking, and verified riders keep you secure.",
    ),
    _PageData(
      icon: Icons.attach_money,
      title: "Smart Ride Bidding",
      subtitle:
          "View ride requests and bid for the trips that suits you Best .",
    ),
    _PageData(
      icon: Icons.notifications_active,
      title: "Stay Connected",
      subtitle:
          "Enable permissions to receive ride alerts and accurate pickup locations.",
    ),
  ];

  Future<void> requestPermissions() async {
    final controller = ref.read(onboardingProvider);

    bool locationGranted = await controller.requestLocation();
    bool notificationGranted = await controller.requestNotifications();

    if (locationGranted && notificationGranted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("All permissions granted")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissions required to continue")),
      );
    }
  }

  void nextPage() {
    if (pageIndex == pages.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>LoginScreen()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 351),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageView.builder(
          controller: _pageController,
          itemCount: pages.length,
          onPageChanged: (i) => setState(() => pageIndex = i),
          itemBuilder: (_, i) {
            final page = pages[i];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  // Icon Card
                  Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Icon(page.icon, size: 70, color: Colors.green),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    page.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),

                  const SizedBox(height: 40),

                  if (i == 3)
                    ElevatedButton.icon(
                      onPressed: requestPermissions,
                      icon: const Icon(Icons.lock_open, color: Colors.white),
                      label: const Text(
                        "Allow Permissions",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 45,
              width: 100,
              child: TextButton(
                onPressed: () => _pageController.jumpToPage(3),
                child: Text("Skip", style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),

            SmoothPageIndicator(
              controller: _pageController,
              count: pages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.green,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),

            SizedBox(
              height: 45,
              width: 100,
              child: ElevatedButton(
                onPressed: nextPage,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(
                  pageIndex == pages.length - 1 ? "Get Started" : "Next",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// page model
class _PageData {
  final IconData icon;
  final String title;
  final String subtitle;

  _PageData({required this.icon, required this.title, required this.subtitle});
}
