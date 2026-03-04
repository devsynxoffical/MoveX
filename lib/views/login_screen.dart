import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movex/views/verify_otp_screen.dart';
import '../controllers/auth_controller.dart';
import 'package:movex/controllers/auth_controller.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  final namecontroller=TextEditingController();


  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      // Navigate when OTP is sent
      if (next.verificationId != null &&
          previous?.verificationId != next.verificationId) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyOtpScreen(),
          ),
        );
      }

      // Show error
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Send OTP",style: TextStyle(color: Colors.white),),centerTitle: true,
      backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 51,),
              Image.network('https://static.vecteezy.com/system/resources/previews/046/479/421/non_2x/two-factor-authentication-verification-isolated-cartoon-illustrations-vector.jpg'),
              SizedBox(height: 30,),

              TextField(
                controller: namecontroller,
                keyboardType: TextInputType.text,


                decoration:  InputDecoration(

                  labelText: "Enter Name",
                  hintText: "usertemp ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
              SizedBox(height: 30,),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,


                decoration:  InputDecoration(

                  labelText: "Phone Number",
                  hintText: "+923034567890",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
          
              const SizedBox(height: 20),
          
              authState.isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(authControllerProvider.notifier)
                        .verifyPhoneNumber(phoneController.text.trim());
                  },
                  child: Text("Send OTP",style: TextStyle(color: Colors.white,fontSize: 20),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
