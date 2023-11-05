import 'package:flutter/material.dart';
import 'package:locationapp/Sucessfulverified.dart';
import 'package:locationapp/widgets/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String email = "";
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String qrData = ''; // Added a variable to store QR data
  String responseMessage = ''; // To store the response message
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('QR Scanner'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Background color
                onPrimary: Colors.white, // Text color
                padding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12), // Button padding
                textStyle: TextStyle(fontSize: 18), // Text style
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Button border radius
                ),
              ),
              onPressed: () async {
                // print(qrData);

                await verifyToken();
                if (email != "") {
                  nextScreen(context, SucessfulScreen(email: email));
                }

                // Perform validation logic when the button is tapped
                // if (isValidQRData(qrData)) {
                //   // Valid QR code, handle it
                //   print('Valid QR Code: $qrData');
                //   // Perform actions with the validated data
                // } else {
                //   // Invalid QR code
                //   print('Invalid QR Code: $qrData');
                // }
              },
              child: Text('Validate QR Code'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> verifyToken() async {
    final apiUrl =
        Uri.parse('https://moveasy--md2125cse1047.repl.co/verify-token/');

    // Define the JSON data
    final jsonData = {
      "token": qrData,
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
        final responseDataJson = jsonDecode(response.body);
        final payload = responseDataJson['payload'];
        email = payload['email'];
        final exp = payload['exp'];
        setState(() {
          responseMessage = 'Email: $email, Expiration: $exp';
          print(responseMessage);
        });
      } else {
        // Handle other response codes or errors
        setState(() {
          responseMessage = 'Failed to verify token: ${response.statusCode}';
        });
      }
    } catch (e) {
      // Handle network or other errors
      setState(() {
        responseMessage = 'Error: $e';
      });
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Handle scanned data here if needed (e.g., display it)
      setState(() {
        qrData = scanData.code!; // Update qrData with scanned data
      });
    });
  }

  bool isValidQRData(String data) {
    // Implement your validation logic here
    // Return true if the data is valid, otherwise false
    // You can perform checks like data length, content format, etc.
    return data.isNotEmpty && data.length == 10; // Example validation
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: QRScannerScreen(),
  ));
}
