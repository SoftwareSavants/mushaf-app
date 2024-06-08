import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double? width, height;
  const LoadingWidget({Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}