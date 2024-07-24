import 'dart:async';

extension ThrottleExtension on Function {
  void Function() throttle([int milliseconds = 500]) {
    bool isAllowed = true;
    Timer? throttleTimer;
    // print('init here');

    return () {
      // print('click ');
      if (!isAllowed) {
        return;
      }

      // print('click success');

      isAllowed = false;

      this();

      throttleTimer?.cancel();
      throttleTimer = Timer(Duration(milliseconds: milliseconds), () {
        isAllowed = true;
      });
    };
  }
}
