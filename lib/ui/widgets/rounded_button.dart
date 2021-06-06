import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const RoundedButton({required this.label, required this.onPressed})
      : this.isLoading = false;

  const RoundedButton.loading()
      : this.label = null,
        this.onPressed = null,
        this.isLoading = true;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            width: 17.0,
            height: 17.0,
            child:
                CircularProgressIndicator(color: Theme.of(context).accentColor),
          )
        : MaterialButton(
            onPressed: onPressed!,
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            color: Colors.blue.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Text(
              label!,
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: Colors.white),
            ),
          );
  }
}
