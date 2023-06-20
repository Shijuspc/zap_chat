import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'home.dart';

class Phone extends StatefulWidget {
  const Phone({Key? key}) : super(key: key);

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    try {
      setState(() {
        _isLoading = true; // Show loading screen
      });

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        var snackBar = SnackBar(content: Text('Successfully Log In'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print('Signed in with Google! User: ${user.displayName}');
      } else {
        var snackBar = SnackBar(content: Text('Log In Failed'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print('Failed to sign in with Google.');
      }
    } catch (e) {
      var snackBar = SnackBar(content: Text('Log In Failed'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('Failed to sign in with Google: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading screen
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 50, bottom: 100, left: 10, right: 10),
                    child: Image.asset('lib/image/login.jpg'),
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          side: BorderSide(color: Colors.blue, width: 2)),
                      onPressed: _signInWithGoogle,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Image(
                              image: AssetImage("lib/image/google.png"),
                              height: 20.0,
                              width: 24,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 14, right: 10),
                              child: Text(
                                'Google',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading) // Show loading overlay if _isLoading is true
              Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset('lib/image/loading.gif')),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            color: Colors.blue.shade200,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
