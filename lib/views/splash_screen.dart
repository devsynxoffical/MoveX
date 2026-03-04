import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:movex/views/update_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'home_screen.dart';
import 'login_screen.dart';
import 'maintenance_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {

    await Future.delayed(const Duration(seconds: 4),);

    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(seconds: 0), // dev mode
      ),
    );

    await remoteConfig.fetchAndActivate();

    // get values from firebase
    String latestVersion =
    remoteConfig.getString('latest_version');

    bool forceUpdate =
    remoteConfig.getBool('force_update');

    bool maintenance =
    remoteConfig.getBool('maintenance_mode');

    // fetchh current version
    PackageInfo packageInfo =
    await PackageInfo.fromPlatform();

    String currentVersion = packageInfo.version;

    // maintenace mode
    if (maintenance) {
      goToMaintenance();
      return;
    }

    // force update check
    if (forceUpdate && currentVersion != latestVersion) {
      goToUpdate();
      return;
    }

     // login token check
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      goToHome();
    } else {
      goToonboarding();
    }
  }

  void goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void goToonboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  void goToUpdate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const UpdateScreen()),
    );
  }

  void goToMaintenance() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MaintenanceScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent.shade400,
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.local_shipping, size: 150,
              color: Colors.white,),
            SizedBox(height: 70),
            Text(
              "Move X ",
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
