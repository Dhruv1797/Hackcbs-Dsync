import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:location/location.dart' as loc;
import 'package:locationapp/auth/login_page.dart';
import 'package:locationapp/button.dart';
import 'package:locationapp/drawer.dart';
import 'package:locationapp/flutter_flow/index.dart';

import 'package:locationapp/mymap.dart';
import 'package:locationapp/onboardscreen.dart';
import 'package:locationapp/profile_page.dart';
import 'package:locationapp/scannerscreen.dart';
import 'package:locationapp/service/auth_service.dart';
import 'package:locationapp/service/database_service.dart';
import 'package:locationapp/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'helper/helper_function.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ScreenUtilInit(
    designSize: const Size(360, 800),
    child: MaterialApp(
      home: Builder(builder: (context) {
        return AnimatedSplashScreen(
            splash: Container(
                // color: Colors.red,
                height: 400,
                width: 400,
                child: Column(children: <Widget>[
                  Container(
                    // color: Colors.yellow,
                    height: 600,
                    width: 600,
                    child: Image.asset(
                      'assets/images/movelogo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // SizedBox(
                  //   height: 19,
                  // ),
                  // Text(
                  //   'Where Memories Matter',
                  //   style: TextStyle(
                  //       color: Color.fromRGBO(0, 0, 0, 1),
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 16),
                  // )
                ])),
            splashIconSize: 800,
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white,
            duration: 500,
            nextScreen: OnboardScreen());
      }),
      debugShowCheckedModeBanner: false,
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  String userName = "";
  String email = "";

  String busNumber = '';
  String conductorNumber = '';
  String conductoremail = '';
  String fullName = '';
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  bool alertloading = false;

  loc.LocationData? _globallocationResult;
  final String? useruid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    gettingUserData();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userData = await userDoc.get();

        if (userData.exists) {
          setState(() {
            // Retrieve the fields from the Firestore document
            busNumber = userData['busnumber'] ?? '';
            conductorNumber = userData['conductornumber'] ?? '';
            conductoremail = userData['email'] ?? '';
            fullName = userData['fullName'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address =
            '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        return address;
      } else {
        return 'No address found';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  Future<void> postDataToApi({required String address}) async {
    final apiUrl =
        Uri.parse('https://moveasy--md2125cse1047.repl.co/generate-alert/');

    // Define the JSON data
    final jsonData = {
      "location": address,
      "bus_number": busNumber,
      "conductor_name": fullName,
      "conductor_number": conductorNumber,
      "longitude": _globallocationResult!.longitude,
      "latitude": _globallocationResult!.latitude,
    };

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        // Successful response
        print(response.body);
        print('Data posted successfully.');
      } else {
        // Handle other response codes or errors
        print('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            title: const Text(
              "MOVEASY",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.white,
          drawer: MyDrawer(),
          // appBar: AppBar(
          //   title: Text('live location tracker'),
          // ),
          // drawer: Drawer(
          //     child: ListView(
          //   padding: const EdgeInsets.symmetric(vertical: 50),
          //   children: <Widget>[
          //     Icon(
          //       Icons.account_circle,
          //       size: 150,
          //       color: Colors.grey[700],
          //     ),
          //     const SizedBox(
          //       height: 15,
          //     ),
          //     Text(
          //       userName,
          //       textAlign: TextAlign.center,
          //       style: const TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //     const SizedBox(
          //       height: 30,
          //     ),
          //     const Divider(
          //       height: 2,
          //     ),
          //     // ListTile(
          //     //   onTap: () {
          //     //     nextScreen(context, MyApp());
          //     //   },
          //     //   contentPadding:
          //     //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //     //   leading: const Icon(Icons.group),
          //     //   title: const Text(
          //     //     "Groups",
          //     //     style: TextStyle(color: Colors.black),
          //     //   ),
          //     // ),
          //     ListTile(
          //       onTap: () {
          //         nextScreen(context, MyApp());
          //       },
          //       selected: true,
          //       selectedColor: Theme.of(context).primaryColor,
          //       contentPadding:
          //           const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //       leading: const Icon(Icons.group),
          //       title: const Text(
          //         "Home Screen",
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ),
          //     ListTile(
          //       onTap: () async {
          //         showDialog(
          //             barrierDismissible: false,
          //             context: context,
          //             builder: (context) {
          //               return AlertDialog(
          //                 title: const Text("Logout"),
          //                 content:
          //                     const Text("Are you sure you want to logout?"),
          //                 actions: [
          //                   IconButton(
          //                     onPressed: () {
          //                       Navigator.pop(context);
          //                     },
          //                     icon: const Icon(
          //                       Icons.cancel,
          //                       color: Colors.red,
          //                     ),
          //                   ),
          //                   IconButton(
          //                     onPressed: () async {
          //                       await authService.signOut();
          //                       Navigator.of(context).pushAndRemoveUntil(
          //                           MaterialPageRoute(
          //                               builder: (context) =>
          //                                   const LoginPage()),
          //                           (route) => false);
          //                     },
          //                     icon: const Icon(
          //                       Icons.done,
          //                       color: Colors.green,
          //                     ),
          //                   ),
          //                 ],
          //               );
          //             });
          //       },
          //       contentPadding:
          //           const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //       leading: const Icon(Icons.exit_to_app),
          //       title: const Text(
          //         "Logout",
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     )
          //   ],
          // )),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 400,
                    width: 360,
                    // decoration: BoxDecoration(
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.grey.withOpacity(0.5),
                    //       spreadRadius: 5,
                    //       blurRadius: 7,
                    //       offset: Offset(0, 3),
                    //     ),
                    //   ],
                    // ),

                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(7.45),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(182, 214, 204, 1),
                          spreadRadius: 2,
                          blurRadius: 6.r,
                          offset: Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        width: 1.0, // 1px border width
                        color: Color.fromRGBO(182, 214, 204, 1), // Border color
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 4, // Button elevation
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10), // Button padding
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  25), // Button border radius
                                            ),
                                            primary: Colors
                                                .white, // Button color (background color)
                                            onPrimary:
                                                Colors.black, // Text color
                                          ),
                                          onPressed: () {
                                            _getLocation();
                                          },
                                          icon: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,

                                                  color: Colors
                                                      .white, // Customize the color as needed
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(
                                                          182, 214, 204, 1),
                                                      spreadRadius: 2,
                                                      blurRadius: 6,
                                                      offset: Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    height: 35,
                                                    width: 35,
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                          "assets/images/addlocation.png"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          label: SizedBox()),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     _getLocation();
                                      //   },
                                      //   child: Container(
                                      //     width: 50.w,
                                      //     height: 50.h,
                                      //     decoration: BoxDecoration(
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: Color.fromRGBO(
                                      //               182, 214, 204, 1),
                                      //           spreadRadius: 2,
                                      //           blurRadius: 6.r,
                                      //           offset: Offset(0, 6),
                                      //         ),
                                      //       ],
                                      //       shape: BoxShape.circle,
                                      //       color: Colors
                                      //           .white, // Customize the color as needed
                                      //     ),
                                      //     child: Column(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       children: [
                                      //         Container(
                                      //           height: 35,
                                      //           width: 35,
                                      //           child: Image.asset(
                                      //               "assets/images/addlocation.png"),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Add Location",
                                        style: TextStyle(
                                          fontFamily: "Urbanist",
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color:
                                    Colors.grey, // Customize the divider color
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 4, // Button elevation
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10), // Button padding
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  25), // Button border radius
                                            ),
                                            primary: Colors
                                                .white, // Button color (background color)
                                            onPrimary:
                                                Colors.black, // Text color
                                          ),
                                          onPressed: () {
                                            _listenLocation();
                                          },
                                          icon: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,

                                                  color: Colors
                                                      .white, // Customize the color as needed
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(
                                                          182, 214, 204, 1),
                                                      spreadRadius: 2,
                                                      blurRadius: 6,
                                                      offset: Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    height: 35,
                                                    width: 35,
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                          "assets/images/starttrack.png"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          label: SizedBox()),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     _listenLocation();
                                      //   },
                                      //   child: Container(
                                      //     width: 50.w,
                                      //     height: 50.h,
                                      //     decoration: BoxDecoration(
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: Color.fromRGBO(
                                      //               182, 214, 204, 1),
                                      //           spreadRadius: 2,
                                      //           blurRadius: 6.r,
                                      //           offset: Offset(0, 6),
                                      //         ),
                                      //       ],
                                      //       shape: BoxShape.circle,
                                      //       color: Colors
                                      //           .white, // Customize the color as needed
                                      //     ),
                                      //     child: Column(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       children: [
                                      //         Container(
                                      //           height: 35,
                                      //           width: 35,
                                      //           child: Image.asset(
                                      //               "assets/images/starttrack.png"),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Start Tracking",
                                        style: TextStyle(
                                          fontFamily: "Urbanist",
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey, // Customize the divider color
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 4, // Button elevation
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10), // Button padding
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  25), // Button border radius
                                            ),
                                            primary: Colors
                                                .white, // Button color (background color)
                                            onPrimary:
                                                Colors.black, // Text color
                                          ),
                                          onPressed: () {
                                            _stopListening();
                                          },
                                          icon: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,

                                                  color: Colors
                                                      .white, // Customize the color as needed
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(
                                                          182, 214, 204, 1),
                                                      spreadRadius: 2,
                                                      blurRadius: 6,
                                                      offset: Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    height: 35,
                                                    width: 35,
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                          "assets/images/stoptrack.png"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          label: SizedBox()),
                                      // GestureDetector(
                                      //   onTap: () async {
                                      //     _stopListening();
                                      //   },
                                      //   child: Container(
                                      //     width: 50.w,
                                      //     height: 50.h,
                                      //     decoration: BoxDecoration(
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: Color.fromRGBO(
                                      //               182, 214, 204, 1),
                                      //           spreadRadius: 2,
                                      //           blurRadius: 6.r,
                                      //           offset: Offset(0, 6),
                                      //         ),
                                      //       ],
                                      //       shape: BoxShape.circle,
                                      //       color: Colors
                                      //           .white, // Customize the color as needed
                                      //     ),
                                      //     child: Column(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       children: [
                                      //         Container(
                                      //           height: 35,
                                      //           width: 35,
                                      //           child: Image.asset(
                                      //               "assets/images/stoptrack.png"),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Stop Tracking",
                                        style: TextStyle(
                                          fontFamily: "Urbanist",
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color:
                                    Colors.grey, // Customize the divider color
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 4, // Button elevation
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10), // Button padding
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  25), // Button border radius
                                            ),
                                            primary: Colors
                                                .white, // Button color (background color)
                                            onPrimary:
                                                Colors.black, // Text color
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              alertloading = true;
                                            });

                                            print(
                                                "The globallat is ${_globallocationResult!.latitude} and ${_globallocationResult!.longitude}");
                                            String address = await getAddress(
                                                _globallocationResult!
                                                    .latitude!,
                                                _globallocationResult!
                                                    .longitude!);
                                            print('Address: $address');

                                            print("user uid : ${useruid}");
                                            print("busnumber : ${busNumber}");
                                            print(
                                                "conductornumber : ${conductorNumber}");
                                            print(
                                                "conductoremail : ${conductoremail}");
                                            print("fullname : ${fullName}");

                                            await postDataToApi(
                                                address: address);

                                            setState(() {
                                              setState(() {
                                                alertloading = false;
                                              });
                                            });
                                          },
                                          icon: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,

                                                  color: Colors
                                                      .white, // Customize the color as needed
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(
                                                          182, 214, 204, 1),
                                                      spreadRadius: 2,
                                                      blurRadius: 6,
                                                      offset: Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: alertloading
                                                      ? CircularProgressIndicator()
                                                      : Container(
                                                          height: 35,
                                                          width: 35,
                                                          child: ClipOval(
                                                            child: Image.asset(
                                                                "assets/images/alert.png"),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          label: SizedBox()),
                                      // GestureDetector(
                                      //   onTap: () async {
                                      //     String address = await getAddress(
                                      //         _globallocationResult!.latitude!,
                                      //         _globallocationResult!
                                      //             .longitude!);
                                      //     print('Address: $address');

                                      //     print("user uid : ${useruid}");
                                      //     print("busnumber : ${busNumber}");
                                      //     print(
                                      //         "conductornumber : ${conductorNumber}");
                                      //     print(
                                      //         "conductoremail : ${conductoremail}");
                                      //     print("fullname : ${fullName}");

                                      //     await postDataToApi(address: address);
                                      //   },
                                      //   child: Container(
                                      //     width: 50.w,
                                      //     height: 50.h,
                                      //     decoration: BoxDecoration(
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: Color.fromRGBO(
                                      //               182, 214, 204, 1),
                                      //           spreadRadius: 2,
                                      //           blurRadius: 6.r,
                                      //           offset: Offset(0, 6),
                                      //         ),
                                      //       ],
                                      //       shape: BoxShape.circle,
                                      //       color: Colors
                                      //           .white, // Customize the color as needed
                                      //     ),
                                      //     child: Column(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       children: [
                                      //         Container(
                                      //           height: 35,
                                      //           width: 35,
                                      //           child: Image.asset(
                                      //             "assets/images/alert.png",
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Alert Sent",
                                        style: TextStyle(
                                          fontFamily: "Urbanist",
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey, // Customize the divider color
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 4, // Button elevation
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10), // Button padding
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  25), // Button border radius
                                            ),
                                            primary: Colors
                                                .white, // Button color (background color)
                                            onPrimary:
                                                Colors.black, // Text color
                                          ),
                                          onPressed: () async {
                                            nextScreen(
                                                context, QRScannerScreen());
                                          },
                                          icon: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,

                                                  color: Colors
                                                      .white, // Customize the color as needed
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromRGBO(
                                                          182, 214, 204, 1),
                                                      spreadRadius: 2,
                                                      blurRadius: 6,
                                                      offset: Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    height: 35,
                                                    width: 35,
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                          "assets/images/qr-code.png"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          label: SizedBox()),
                                      // GestureDetector(
                                      //   onTap: () async {
                                      //     nextScreen(
                                      //         context, QRScannerScreen());
                                      //   },
                                      //   child: Container(
                                      //     width: 50.w,
                                      //     height: 50.h,
                                      //     decoration: BoxDecoration(
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: Color.fromRGBO(
                                      //               182, 214, 204, 1),
                                      //           spreadRadius: 2,
                                      //           blurRadius: 6.r,
                                      //           offset: Offset(0, 6),
                                      //         ),
                                      //       ],
                                      //       shape: BoxShape.circle,
                                      //       color: Colors
                                      //           .white, // Customize the color as needed
                                      //     ),
                                      //     child: Column(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       children: [
                                      //         Container(
                                      //           height: 30,
                                      //           width: 30,
                                      //           child: Image.asset(
                                      //             "assets/images/qr-code.png",
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),,
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Scanner",
                                        style: TextStyle(
                                          fontFamily: "Urbanist",
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // VerticalDivider(
                              //   color:
                              //       Colors.grey, // Customize the divider color
                              // ),
                              // Expanded(
                              //   child: Center(
                              //     child: Column(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         GestureDetector(
                              //           onTap: () {},
                              //           child: Container(
                              //             width: 50.w,
                              //             height: 50.h,
                              //             decoration: BoxDecoration(
                              //               boxShadow: [
                              //                 BoxShadow(
                              //                   color: Color.fromRGBO(
                              //                       182, 214, 204, 1),
                              //                   spreadRadius: 2,
                              //                   blurRadius: 6.r,
                              //                   offset: Offset(0, 6),
                              //                 ),
                              //               ],
                              //               shape: BoxShape.circle,
                              //               color: Colors
                              //                   .white, // Customize the color as needed
                              //             ),
                              //             child: Image.asset(
                              //                 "assets/images/ticket4.png"),
                              //           ),
                              //         ),
                              //         SizedBox(
                              //           height: 10,
                              //         ),
                              //         Text(
                              //           "Live Location",
                              //           style: TextStyle(
                              //             fontFamily: "Urbanist",
                              //             fontSize: 13.sp,
                              //             fontWeight: FontWeight.w600,
                              //             color: Colors.black,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // MyButton(
                //     icon: Icons.location_on,
                //     onPressed: () {
                //       _getLocation();
                //     },
                //     text: "add Location"),
                // MyButton(
                //     icon: Icons.location_on,
                //     onPressed: () {
                //       _listenLocation();
                //     },
                //     text: "start tracking"),
                // MyButton(
                //     icon: Icons.location_on,
                //     onPressed: () {
                //       _stopListening();
                //     },
                //     text: "stop tracking"),
                // MyButton(
                //     icon: Icons.track_changes,
                //     onPressed: () async {
                //       String address = await getAddress(
                //           _globallocationResult!.latitude!,
                //           _globallocationResult!.longitude!);
                //       print('Address: $address');

                //       print("user uid : ${useruid}");
                //       print("busnumber : ${busNumber}");
                //       print("conductornumber : ${conductorNumber}");
                //       print("conductoremail : ${conductoremail}");
                //       print("fullname : ${fullName}");

                //       await postDataToApi(address: address);
                //     },
                //     text: "Alert Sent"),
                // MyButton(
                //     icon: Icons.track_changes,
                //     onPressed: () async {
                //       nextScreen(context, QRScannerScreen());
                //     },
                //     text: "Scanner"),

                // TextButton(
                //     onPressed: () {
                //       nextScreenReplace(
                //           context,
                //           ProfilePage(
                //             userName: userName,
                //             email: email,
                //           ));
                //     },
                //     child: Text('about page')),
                // Text('data'),
                // TextButton(
                //     onPressed: () {
                //       _listenLocation();
                //     },
                //     child: Text('enable live location')),
                // TextButton(
                //     onPressed: () {
                //       _stopListening();
                //     },
                //     child: Text('stop live location')),
                // Expanded(
                //     child: StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //       .collection('location')
                //       .snapshots(),
                //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                //     if (!snapshot.hasData) {
                //       return Center(child: CircularProgressIndicator());
                //     }
                //     return ListView.builder(
                //         itemCount: snapshot.data?.docs.length,
                //         itemBuilder: (context, index) {
                //           return ListTile(
                //             title: Text(
                //                 snapshot.data!.docs[index]['name'].toString()),
                //             subtitle: Row(
                //               children: [
                //                 Text(snapshot.data!.docs[index]['latitude']
                //                     .toString()),
                //                 SizedBox(
                //                   width: 20,
                //                 ),
                //                 Text(snapshot.data!.docs[index]['longitude']
                //                     .toString()),
                //               ],
                //             ),
                //             trailing: IconButton(
                //               icon: Icon(Icons.directions),
                //               onPressed: () {
                //                 Navigator.of(context).push(MaterialPageRoute(
                //                     builder: (context) =>
                //                         MyMap(snapshot.data!.docs[index].id)));
                //               },
                //             ),
                //           );
                //         });
                //   },
                // )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      _globallocationResult = _locationResult;

      print(_globallocationResult!.latitude.toString());
      print(_globallocationResult!.longitude.toString());
      await FirebaseFirestore.instance.collection('location').doc(useruid).set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': '$userName'
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc(useruid).set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': '$userName'
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
