import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shimmer/shimmer.dart';

class LoadingStories extends HookWidget {
  const LoadingStories({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var anim = useAnimationController(
      duration: Duration(seconds: 1),
    );
    final Animation curve =
        CurvedAnimation(parent: anim, curve: Curves.easeInOut);

    anim.forward();

    return ListView.builder(
      itemCount: 7,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[500],
          highlightColor: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SlideTransition(
              position: Tween(
                begin: Offset((index + 1) * -0.25, 0),
                end: Offset(0, 0),
              ).animate(
                curve,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: 80,
                      height: 10,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: 10,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: 10,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: 10,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        height: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
