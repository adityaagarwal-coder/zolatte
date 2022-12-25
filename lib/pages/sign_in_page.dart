import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zolatte/pages/Home.dart';
import 'package:zolatte/utils/database.dart';
import 'package:zolatte/utils/googleSignIn.dart';
import 'package:zolatte/widgets/custom_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';

String userid = "1";
String authMethod = "google";

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return Home();
        } else {
          return SignUpWidget();
        }
      },
    ));
  }
}

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  DatabaseServices databaseServices = new DatabaseServices();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  bool otpVisibility = false;

  String verificationID = "";
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Text("Welcome To Zolatte",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 100),
                InkWell(
                  onTap: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogin();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: MediaQuery.of(context).size.width - 80,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FaIcon(FontAwesomeIcons.google, color: Colors.red),
                          Text(
                            "Sign In with Google",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Sign In with Phone Number",
                  style: TextStyle(color: Colors.white,fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1 ?? 1),
                      borderRadius:
                          BorderRadius.all(Radius.circular(11 ?? 5.0)),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone number",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.phone,
                    )),
                Visibility(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1 ?? 1),
                      borderRadius:
                          BorderRadius.all(Radius.circular(11 ?? 5.0)),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: otpController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Code"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  visible: otpVisibility,
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () {
                      if (otpVisibility) {
                        verifyOTP();
                      } else {
                        loginWithPhone();
                      }
                    },
                    child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(otpVisibility ? "Login" : "Verify")))),
              ],
            ),
          ),
        ));
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationID = verificationId;
        otpVisibility = true;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await auth.signInWithCredential(credential).then((value) {
      print("You are logged in successfully");
      showToast("You are logged in successfully");
      authMethod = "phone";
    });
  }
}

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0);
}
