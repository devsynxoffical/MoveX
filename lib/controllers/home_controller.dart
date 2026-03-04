import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';

final homeControllerProvider = ChangeNotifierProvider((ref) => HomeController());

class HomeController extends ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  String destination = '';
  double? offerPrice;
  String rideType = 'Standard'; // default

  bool isLoading = true;

  Future<void> fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _currentPosition = position;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching location: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  void updateDestination(String value) {
    destination = value;
    notifyListeners();
  }

  void updateOfferPrice(String value) {
    offerPrice = double.tryParse(value);
    notifyListeners();
  }

  void updateRideType(String type) {
    rideType = type;
    notifyListeners();
  }

// TODO: Implement backend calls:
// getNearbyDrivers(), calculateSurge(), validateMinimumPrice()
}
