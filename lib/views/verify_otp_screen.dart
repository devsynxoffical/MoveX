import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movex/controllers/auth_controller.dart';
import 'package:movex/views/home_screen.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next)async {
      // Show error
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }


      if (next.isAuthenticated) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      }
    });


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Verify OTP",style: TextStyle(color: Colors.white),),
centerTitle: true,
      backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.network('https://static.vecteezy.com/system/resources/previews/046/479/421/non_2x/two-factor-authentication-verification-isolated-cartoon-illustrations-vector.jpg'),
           SizedBox(height:30 ,),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter OTP",
                  border: OutlineInputBorder(),
                ),
              ),
          
              const SizedBox(height: 20),
          
              authState.isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(authControllerProvider.notifier)
                        .signInWithOTP(otpController.text.trim());
          
                  },
                  child:  Text("Verify"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
