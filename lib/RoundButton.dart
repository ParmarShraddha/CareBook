// ignore_for_file: file_names

import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final Color color,textColor;
  final bool loading;

  const RoundButton({Key? key,
    required this.title,
    required this.onPress,
    this.textColor = Colors.black,
    this.color = Colors.white,
    this.loading = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: double.infinity,
        child:loading ? const Center(child: CircularProgressIndicator()) :  Center(child:Text(title),),
      );
  }
}
