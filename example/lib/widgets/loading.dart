import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final bool loading;
  final Widget child;

  const Loading({this.loading, this.child});

  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator()) : child;
  }
}
