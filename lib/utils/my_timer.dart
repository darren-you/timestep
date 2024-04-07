import 'dart:async';

import 'package:flutter/foundation.dart';

class MyTimer {
  final VoidCallback function;
  final Duration duration;
  Timer? _timer;
  bool _isActive = false;

  MyTimer({required this.duration, required this.function});

  void start() {
    if (_isActive) return; // 如果已经在运行，则不再重复启动
    _isActive = true;
    _timer = Timer.periodic(duration, (Timer t) {
      function.call();
    });
  }

  void pause() {
    if (!_isActive) return; // 如果已经暂停，则不再重复暂停
    _isActive = false;
    _timer?.cancel(); // 取消定时器
  }

  void resume() {
    start(); // 重新启动定时器
  }

  void dispose() {
    _timer?.cancel(); // 确保在不需要时取消定时器
  }
}
