import 'package:flutter/material.dart';

class ConectionNotifier extends InheritedNotifier<ValueNotifier<bool>> {
  const ConectionNotifier({
    super.key,
    required super.notifier,
    required super.child,
  });

  static ValueNotifier<bool> of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ConectionNotifier>()!
        .notifier!;
  }
}
