import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: buildBox(),
          subtitle: buildBox(),
        ),
        Divider(height: 10.0),
      ],
    );
  }

  Widget buildBox() {
    return Container(
      height: 24.0,
      width: 150.0,
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      color: Colors.grey.shade300,
    );
  }
}
