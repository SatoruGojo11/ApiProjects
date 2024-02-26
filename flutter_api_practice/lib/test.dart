import 'package:flutter/material.dart';
import 'package:flutter_api_practice/models/text.dart';

class CameraAwesomeWidget extends StatelessWidget {
  const CameraAwesomeWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('CameraAwesomeWidget Screen'),
      ),
      body: Center(
        child: text('Hello'),
      ),
    );
  }
}
