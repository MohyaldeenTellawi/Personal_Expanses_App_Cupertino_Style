import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("About"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(50)
              ),
              child: Text("Copyrights reserved for Mohyaldeen Tellawi"),
            ),
          ],
        ),
      ),
    );
  }
}
