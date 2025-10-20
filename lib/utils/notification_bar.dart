import 'package:flutter/material.dart';

class NotificationBar {
  static void error(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(reason: SnackBarClosedReason.remove);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Ups, $message",
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        backgroundColor: Colors.redAccent,
        shape: const StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void success(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(reason: SnackBarClosedReason.remove);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        backgroundColor: Colors.green,
        shape: const StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
