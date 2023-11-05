import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:locationapp/helper/helper_function.dart';
import 'package:locationapp/auth/login_page.dart';
import 'package:locationapp/main.dart';
import 'package:locationapp/onboardscreen.dart';
import 'package:locationapp/service/auth_service.dart';
import 'package:locationapp/widgets/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";

  String busnumber = "";
  String conductornumber = "";

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
                    color: Theme.of(context).primaryColor))
            : SingleChildScrollView(
                child: Container(
                  height: deviceheight,
                  width: devicewidth,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 13.w, right: 13.w),
                      child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // const Text(
                              //   "MoveEasy",
                              //   style: TextStyle(
                              //       fontSize: 40, fontWeight: FontWeight.bold),
                              // ),
                              // const SizedBox(height: 10),
                              // const Text(
                              //     "Create your account now to chat and explore",
                              //     style: TextStyle(
                              //         fontSize: 15, fontWeight: FontWeight.w400)),
                              // SizedBox(
                              //     height: 400,
                              //     width: 500,
                              //     child: Image.asset(
                              //       "assets/images/movelogo.png",
                              //       fit: BoxFit.cover,
                              //     )),
                              SizedBox(
                                height: 42.w,
                              ),
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
                                "Hello! Register to get started",
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
                                      hintText: '@example Rahul Singh',
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        fullName = val;
                                      });
                                    },
                                    validator: (val) {
                                      if (val!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return "Name cannot be empty";
                                      }
                                    },
                                  ),
                                ),
                              ),
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
                                      hintText: 'Bus Number',
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        busnumber = val;
                                      });
                                    },
                                    validator: (val) {
                                      if (val!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return "Bus Number cannot be empty";
                                      }
                                    },
                                  ),
                                ),
                              ),
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
                                    keyboardType: TextInputType.number,
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
                                      hintText: 'conductor phone number',
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        conductornumber = val;
                                      });
                                    },
                                    validator: (val) {
                                      if (val!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return "conductor phone number cannot be empty";
                                      }
                                    },
                                  ),
                                ),
                              ),
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
                              //       enabledBorder: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //             width: 3,
                              //             color: Colors.black), //<-- SEE HERE
                              //       ),
                              //       labelText: "Full Name",
                              //       prefixIcon: Icon(
                              //         Icons.person,
                              //         color: Colors.black,
                              //       )),
                              //   onChanged: (val) {
                              //     setState(() {
                              //       fullName = val;
                              //     });
                              //   },
                              //   validator: (val) {
                              //     if (val!.isNotEmpty) {
                              //       return null;
                              //     } else {
                              //       return "Name cannot be empty";
                              //     }
                              //   },
                              // ),

                              // TextFormField(
                              //   decoration: textInputDecoration.copyWith(
                              //       enabledBorder: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //             width: 3,
                              //             color: Colors.black), //<-- SEE HERE
                              //       ),
                              //       labelText: "Email",
                              //       prefixIcon: Icon(
                              //         Icons.email,
                              //         color: Colors.black,
                              //       )),
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
                                      hintText: 'Password',
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
                                        register();
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
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Sign up",
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
                                          color:
                                              Color.fromRGBO(182, 214, 204, 1),
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
                                          color:
                                              Color.fromRGBO(182, 214, 204, 1),
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
                                  Text.rich(
                                    TextSpan(
                                      text: "Already have an account? ",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Login here",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                decoration:
                                                    TextDecoration.underline),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                PersistentNavBarNavigator
                                                    .pushNewScreen(
                                                  context,
                                                  screen: LoginPage(),
                                                  withNavBar:
                                                      false, // OPTIONAL VALUE. True by default.
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .cupertino,
                                                );
                                              }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 20,
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
                              //       "Register",
                              //       style: TextStyle(
                              //           color: Colors.white, fontSize: 16),
                              //     ),
                              //     onPressed: () {
                              //       register();
                              //     },
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Text.rich(TextSpan(
                              //   text: "Already have an account? ",
                              //   style: const TextStyle(
                              //       color: Colors.black, fontSize: 14),
                              //   children: <TextSpan>[
                              //     TextSpan(
                              //         text: "Login now",
                              //         style: const TextStyle(
                              //             color: Colors.black,
                              //             decoration: TextDecoration.underline),
                              //         recognizer: TapGestureRecognizer()
                              //           ..onTap = () {
                              //             nextScreen(
                              //                 context, const LoginPage());
                              //           }),
                              //   ],
                              // )),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(
              fullName, email, password, busnumber, conductornumber)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
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
