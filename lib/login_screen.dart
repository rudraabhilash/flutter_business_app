import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'firebase_auth_services.dart'; // Ensure this is correctly implemented
import 'constants.dart';
import 'dashboard_screen.dart'; // Import this for navigation after login
import 'signup_screen.dart'; // Import the signup screen

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  bool _isLoading = false;

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _loginUser(LoginData loginData) async {
    final email = loginData.name;
    final password = loginData.password;

    try {
      final user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        return null; // Login successful
      } else {
        return 'Login failed. Please try again.';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        title: Constants.appName,
        logo: const AssetImage('assets/images/ecorp.png'),
        logoTag: Constants.logoTag,
        titleTag: Constants.titleTag,
        navigateBackAfterRecovery: false,
        loginAfterSignUp: false,
        userValidator: (value) {
          if (value == null || !value.contains('@') || !value.endsWith('.com')) {
            return "Email must contain '@' and end with '.com'";
          }
          return null;
        },
        passwordValidator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is empty';
          }
          return null;
        },
        onLogin: (loginData) async {
          final result = await _loginUser(loginData);
          if (result == null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          }
          return result;
        },
        onSignup: null, // Remove signup logic from FlutterLogin
        onSubmitAnimationCompleted: () {
          // No longer needed
        },
        headerWidget: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SignupScreen()),
            );
          },
          child: Column(
            children: [
              const IntroWidget(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.blue, // Highlight color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onRecoverPassword: (_) {
          // Removed password recovery logic
          return null;
        },
        loginProviders: [
          LoginProvider(
            button: Buttons.linkedIn,
            label: 'Sign in with LinkedIn',
            callback: () async {
              return null;
            },
            providerNeedsSignUpCallback: () {
              return Future.value(true);
            },
          ),
          LoginProvider(
            icon: FontAwesomeIcons.google,
            label: 'Google',
            callback: () async {
              return null;
            },
          ),
          LoginProvider(
            icon: FontAwesomeIcons.githubAlt,
            callback: () async {
              debugPrint('start github sign in');
              await Future.delayed(loginTime);
              debugPrint('stop github sign in');
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class IntroWidget extends StatelessWidget {
  const IntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "You are trying to login/sign up on server hosted on ",
              ),
              TextSpan(
                text: "example.com",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          textAlign: TextAlign.justify,
        ),
        Row(
          children: <Widget>[
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Authenticate"),
            ),
            Expanded(child: Divider()),
          ],
        ),
      ],
    );
  }
}
