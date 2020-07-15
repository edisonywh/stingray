import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingComment extends StatelessWidget {
  const LoadingComment({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(width: 80, height: 10, color: Colors.white24),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(height: 10, color: Colors.white24),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(height: 10, color: Colors.white24),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(height: 10, color: Colors.white24),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(height: 10, color: Colors.white24),
            ),
          ],
        ),
      ),
    );
  }
}
