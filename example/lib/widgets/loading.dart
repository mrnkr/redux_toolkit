import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'loading.g.dart';

@hwidget
Widget loading({bool isLoading, Widget child}) {
  return isLoading ? Center(child: CircularProgressIndicator()) : child;
}
