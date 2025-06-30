import 'package:flutter/material.dart';
import '../services/global.dart';

class ButtonFullWidth extends StatelessWidget {
  final String label;
  final Function action;
  final Color? color;
  final bool? confirmation;
  final bool? background;
  final IconData? icon;

  const ButtonFullWidth({
    Key? key,
    required this.label,
    required this.action,
    this.color,
    this.confirmation,
    this.background,
    this.icon,
  }) : super(key: key);

  void showConfirmation(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Apakah kamu yakin?"),
          content: const Text('Kamu akan melanjutkan proses ini!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => action(),
              style: TextButton.styleFrom(
                backgroundColor: GlobalConfig.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: const Text(
                'Ya',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: const Text(
                'Tidak',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: () =>
            confirmation != null ? showConfirmation(context) : action(),
        style: TextButton.styleFrom(
          backgroundColor:
              background == true ? GlobalConfig.primaryColor : color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: background == true ? color : GlobalConfig.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (icon != null)
              Icon(
                icon,
                color: background == true ? color : GlobalConfig.primaryColor,
              )
          ],
        ),
      ),
    );
  }
}
