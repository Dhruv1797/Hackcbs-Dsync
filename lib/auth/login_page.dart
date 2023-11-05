import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:locationapp/helper/helper_function.dart';
import 'package:locationapp/auth/register_page.dart';
import 'package:locationapp/main.dart';
import 'package:locationapp/onboardscreen.dart';
import 'package:locationapp/service/auth_service.dart';
import 'package:locationapp/service/database_service.dart';
import 'package:locationapp/widgets/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;

    double devicewidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
              )
            : SingleChildScrollView(
                child: Container(
                  height: deviceheight,
                  width: devicewidth,
                  child: Padding(
                    padding: EdgeInsets.only(left: 13.w, right: 13.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 42.w,
                          ),
                          // const Text(
                          //   "Groupie",
                          //   style: TextStyle(
                          //       fontSize: 40, fontWeight: FontWeight.bold),
                          // ),

                          // const Text("Login now to see what they are talking!",
                          //     style: TextStyle(
                          //         fontSize: 15, fontWeight: FontWeight.w400)),
                          // SizedBox(
                          //     height: 400,
                          //     width: 500,
                          //     child: Image.asset(
                          //       "assets/images/buslogo.png",
                          //       fit: BoxFit.contain,
                          //     )),

                          GestureDetector(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: OnboardScreen(),
                                withNavBar:
                                    false, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Container(
                              height: 41.h,
                              width: 41.h,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(7.45),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 2,
                                    blurRadius: 6.r,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                                border: Border.all(
                                  width: 1.0, // 1px border width
                                  color: Color.fromRGBO(
                                      182, 214, 204, 1), // Border color
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                    "assets/images/back_arrow.svg"),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 42.h,
                          ),

                          Text(
                            "Welcome back! Glad to see you, Again!",
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Urbanist",
                              color: Color(0xFF1E232C),
                            ),
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                          Container(
                            width: 331.0.w,
                            height: 56.14.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7.45),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 2,
                                  blurRadius: 6.r,
                                  offset: Offset(0, 6),
                                ),
                              ],
                              border: Border.all(
                                width: 1.0, // 1px border width
                                color: Color.fromRGBO(
                                    182, 214, 204, 1), // Border color
                              ),
                            ),
                            child: Center(
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w200,
                                  fontFamily: "Urbanist",
                                  color: Color.fromRGBO(54, 67, 86, 1),
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w200,
                                    fontFamily: "Urbanist",
                                    color: Color.fromRGBO(54, 67, 86, 1),
                                  ),
                                  hintText: 'abc123@example.com',
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },

                                // check tha validation
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val!)
                                      ? null
                                      : "Please enter a valid email";
                                },
                              ),
                            ),
                          ),

                          // TextFormField(
                          //   decoration: textInputDecoration.copyWith(
                          //     enabledBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //           width: 3,
                          //           color: Colors.black), //<-- SEE HERE
                          //     ),
                          //     labelText: "Email",
                          //     prefixIcon: Icon(
                          //       Icons.email,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          //   onChanged: (val) {
                          //     setState(() {
                          //       email = val;
                          //     });
                          //   },

                          //   // check tha validation
                          //   validator: (val) {
                          //     return RegExp(
                          //                 r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          //             .hasMatch(val!)
                          //         ? null
                          //         : "Please enter a valid email";
                          //   },
                          // ),

                          SizedBox(
                            height: 18.54,
                          ),
                          Container(
                            width: 331.0.w,
                            height: 56.14.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7.45),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 2,
                                  blurRadius: 6.r,
                                  offset: Offset(0, 6),
                                ),
                              ],
                              border: Border.all(
                                width: 1.0, // 1px border width
                                color: Color.fromRGBO(
                                    182, 214, 204, 1), // Border color
                              ),
                            ),
                            child: Center(
                              child: TextFormField(
                                obscureText: true,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w200,
                                  fontFamily: "Urbanist",
                                  color: Color.fromRGBO(54, 67, 86, 1),
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w200,
                                    fontFamily: "Urbanist",
                                    color: Color.fromRGBO(54, 67, 86, 1),
                                  ),
                                  hintText: '***********',
                                ),
                                validator: (val) {
                                  if (val!.length < 6) {
                                    return "Password must be at least 6 characters";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Urbanist",
                                  color: Color(0xFF6A707C),
                                ),
                              ),
                            ],
                          ),
                          // TextFormField(
                          //   obscureText: true,
                          //   decoration: textInputDecoration.copyWith(
                          //       enabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             width: 3,
                          //             color: Colors.black), //<-- SEE HERE
                          //       ),
                          //       labelText: "Password",
                          //       prefixIcon: Icon(
                          //         Icons.lock,
                          //         color: Colors.black,
                          //       )),
                          //   validator: (val) {
                          //     if (val!.length < 6) {
                          //       return "Password must be at least 6 characters";
                          //     } else {
                          //       return null;
                          //     }
                          //   },
                          //   onChanged: (val) {
                          //     setState(() {
                          //       password = val;
                          //     });
                          //   },
                          // ),
                          SizedBox(
                            height: 50.h,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 0.w),
                                child: GestureDetector(
                                  onTap: () async {
                                    login();
                                    // setState(() {
                                    //   isloading = true;
                                    // });
                                    // await login(snapshot);
                                    // setState(() {
                                    //   isloading = false;
                                    // });
                                  },
                                  child: Container(
                                    height: 61.h,
                                    width: 317.76001.w,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1E232C),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sign in",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Urbanist",
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //         primary: Colors.black,
                          //         elevation: 0,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius:
                          //                 BorderRadius.circular(30))),
                          //     child: const Text(
                          //       "Sign In",
                          //       style: TextStyle(
                          //           color: Colors.white, fontSize: 16),
                          //     ),
                          //     onPressed: () {
                          //       login();
                          //     },
                          //   ),
                          // ),
                          SizedBox(
                            height: 75.83.h,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 1,
                                width: 103.w,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              Text(
                                "Or Register with",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Exo",
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              Container(
                                height: 1,
                                width: 103.w,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 56.h,
                                width: 105.w,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(7.45),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 2,
                                      blurRadius: 6.r,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                  border: Border.all(
                                    width: 1.0, // 1px border width
                                    color: Color.fromRGBO(
                                        182, 214, 204, 1), // Border color
                                  ),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                      "assets/images/google.svg"),
                                ),
                              ),
                              SizedBox(
                                width: 25.w,
                              ),
                              Container(
                                height: 56.h,
                                width: 105.w,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(7.45),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 2,
                                      blurRadius: 6.r,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                  border: Border.all(
                                    width: 1.0, // 1px border width
                                    color: Color.fromRGBO(
                                        182, 214, 204, 1), // Border color
                                  ),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                      "assets/images/facebook.svg"),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 22.h,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text.rich(TextSpan(
                                text: "Don't have an account? ",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Register here",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          PersistentNavBarNavigator
                                              .pushNewScreen(
                                            context,
                                            screen: RegisterPage(),
                                            withNavBar:
                                                false, // OPTIONAL VALUE. True by default.
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino,
                                          );
                                        }),
                                ],
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreenReplace(context, MyApp());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
