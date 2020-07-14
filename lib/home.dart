import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider((ref) => 0);

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => counterProvider.read(context).state++,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      body: Consumer(
        (context, read) {
          return Center(
            child: Text(
              'You have pushed the button this many times: ${read(counterProvider).state}',
            ),
          );
        },
      ),
    );
  }
}
