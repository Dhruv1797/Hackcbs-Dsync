import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locationapp/auth/login_page.dart';
import 'package:locationapp/auth/register_page.dart';
import 'package:locationapp/widgets/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;

    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          width: devicewidth,
          height: deviceheight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 400,
                width: devicewidth,
                // color: Colors.red,
                child: Image.asset(
                  "assets/images/buslogo.png",
                  fit: BoxFit.fitWidth,

                  // height: deviceheight,
                ),
              ),
              SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: LoginPage(),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1E232C),
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
                  height: 55.17241.h,
                  width: 317.76001.w,
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: "Urbanist",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              GestureDetector(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: RegisterPage(),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(7.45),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF1E232C),
                        spreadRadius: 1,
                        blurRadius: 6.r,
                        offset: Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      width: 1.0, // 1px border width
                      color: Color.fromRGBO(182, 214, 204, 1), // Border color
                    ),
                  ),
                  height: 55.17241.h,
                  width: 317.76001.w,
                  child: Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontFamily: "Urbanist",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E232C),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
