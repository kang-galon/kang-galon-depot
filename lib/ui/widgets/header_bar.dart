import 'package:flutter/material.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';

class HeaderBar extends StatelessWidget {
  final String title;

  const HeaderBar({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.0,
      child: Row(
        children: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            padding: const EdgeInsets.all(10.0),
            minWidth: 0.0,
            elevation: 8.0,
            shape: CircleBorder(),
            color: Colors.white,
            child: Icon(
              Icons.arrow_back,
              size: 25.0,
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: Pallette.containerBoxDecoration,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
