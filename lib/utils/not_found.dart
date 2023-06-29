import 'package:flutter/material.dart';

import '../services/global.dart';

class NotFound extends StatelessWidget {
  final String? label;
  final String? size;
  final bool isButton;
  final Function? action;

  const NotFound({
    Key? key,
    this.label,
    this.size,
    required this.isButton,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 10,
      // decoration: BoxDecoration(color: Colors.red),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isButton == true) ...[
            TextButton(
              onPressed: () => action!(),
              child: Column(
                children: [
                  Icon(Icons.add, size: 40, color: GlobalConfig.primaryColor),
                  Text(
                    label!,
                    style: TextStyle(
                      color: GlobalConfig.primaryColor,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            )
          ] else ...[
            // Image.asset(
            //   'images/notfound.png',
            //   width: size == 'mini' ? 60 : 100,
            // ),
            // const SizedBox(height: 10),
            Text(
              label ?? '',
              style: TextStyle(
                fontSize: size == 'mini' ? 12 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            )
          ]
        ],
      ),
    );
  }
}
