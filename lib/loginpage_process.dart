import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsldictionary/homepage_screen.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPageProcessState extends StatefulWidget {
// ignore: use_super_parameters
  const LoginPageProcessState({Key? key}) : super(key: key);

  @override
  State<LoginPageProcessState> createState() => ItLoginPageProcessState();
}

class ItLoginPageProcessState extends State<LoginPageProcessState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      // Add other required scopes
    ],
  );

  @override
  Widget build(BuildContext context) {
    String useremail = _user?.email ?? '';
    String userdisplayphoto = _user?.photoURL ?? '';
    String userdisplayname = _user?.displayName ?? '';
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/defaultscreen_background_0.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _user != null
            ? HomePageProcess(
                useremail: useremail,
                userdisplayphoto: userdisplayphoto,
                userdisplayname: userdisplayname,
                wordListPageState: 0)
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.auto_stories,
                      color: Colors.white,
                      size: 128.0,
                    ),
                    const Text(
                      "DICTIONARY",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "FSL 3D APP",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 21.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 44.0,
                    ),
                    SignInButton(
                      Buttons.google,
                      text: "Authenticate with Google ",
                      onPressed: () {
                        handlerSignInWithGoogle();
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> handlerSignInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        _user = userCredential.user;
      }
    } catch (e) {
      print(e);
    }
  }
}
