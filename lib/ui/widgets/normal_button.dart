import 'package:flutter/material.dart';

class NormalButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const NormalButton({
    required this.label,
    required this.onPressed,
  }) : this.isLoading = false;

  const NormalButton.loading()
      : this.label = null,
        this.onPressed = null,
        this.isLoading = true;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isLoading ? () {} : onPressed!,
      color: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 2.0,
      highlightElevation: 5.0,
      child: isLoading
          ? SizedBox(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Text(label!,
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: Colors.white)),
    );
  }
}
