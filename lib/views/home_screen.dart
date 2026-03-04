import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/home_controller.dart';
import 'onboarding_screen.dart';

class HomeScreen extends ConsumerStatefulWidget { // <-- Change here
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> { // <-- Change here
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    ref.read(homeControllerProvider).fetchCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = ref.watch(homeControllerProvider);

    if (homeController.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.green,
          color: Colors.green.shade100,
          items: [
Icon(Icons.home),
            Icon(Icons.search),
            Icon(Icons.settings),
            Icon(Icons.person)
      ]),
      appBar: AppBar(
        title: Text('Move X',style: TextStyle(color: Colors.white),),

        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                    (_) => false,
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Destination Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter destination",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: homeController.updateDestination,
            ),
          ),

          // Offer Price Input & Ride Type Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Offer Price",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                    onChanged: homeController.updateOfferPrice,
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: homeController.rideType,
                  items: const [
                    DropdownMenuItem(value: 'Standard', child: Text('Standard')),
                    DropdownMenuItem(value: 'Premium', child: Text('Premium')),
                    DropdownMenuItem(value: 'XL', child: Text('XL')),
                  ],
                  onChanged: (value) {
                    if (value != null) homeController.updateRideType(value);
                  },
                )
              ],
            ),
          ),

          // Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  homeController.currentPosition!.latitude,
                  homeController.currentPosition!.longitude,
                ),
                zoom: 13,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
