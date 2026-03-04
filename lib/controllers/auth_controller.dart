import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AuthState {
  final bool isLoading;
  final String? verificationId;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.isLoading = false,
    this.verificationId,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? verificationId,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      verificationId: verificationId ?? this.verificationId,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// controlelr


final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send OTP
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto verification (Android only)
        await _auth.signInWithCredential(credential);
        state = state.copyWith(isLoading: false);
      },

      verificationFailed: (FirebaseAuthException e) {
        print("ERROR CODE: ${e.code}");
        print("ERROR MESSAGE: ${e.message}");
        state = state.copyWith(
          isLoading: false,
          error: e.message,
        );
      },

      codeSent: (String verificationId, int? resendToken) {
        state = state.copyWith(
          isLoading: false,
          verificationId: verificationId,
        );
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        state = state.copyWith(
          verificationId: verificationId,
        );
      },
    );
  }

  // Verify OTP
  Future<void> signInWithOTP(String smsCode) async {
    if (state.verificationId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: state.verificationId!,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);

      state = state.copyWith(isLoading: false,isAuthenticated: true,);

    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}

