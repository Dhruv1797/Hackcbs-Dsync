import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SucessfulScreen extends StatefulWidget {
  final String email;
  const SucessfulScreen({super.key, required this.email});

  @override
  State<SucessfulScreen> createState() => _SucessfulScreenState();
}

class _SucessfulScreenState extends State<SucessfulScreen> {
  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;

    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: deviceheight,
          width: devicewidth,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "PAYMENT VERIFIED SUCESSFULLY",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: "Urbanist",
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Email Id: ${widget.email}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: "Urbanist",
                    color: Color.fromRGBO(54, 67, 86, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
