import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingStories extends StatelessWidget {
  const LoadingStories({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[500],
          highlightColor: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child:
                      Container(width: 80, height: 10, color: Colors.white24),
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
      },
    );
  }
}
