import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  final String text;
  final bool extraSize;
  final Color? backgroundColor;
  final Icon? icon;
  const ChipWidget(this.text, {Key? key, this.extraSize = false, this.backgroundColor, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: extraSize ? const [BoxShadow(color: Colors.black54, offset: Offset(2, 2))] : null,
        color: backgroundColor ?? Theme.of(context).chipTheme.backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: backgroundColor),
                // margin: const EdgeInsets.all(3),
                child: const Icon(
                  Icons.check,
                  size: 20,
                )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Text(
              text,
              style: extraSize ? Theme.of(context).textTheme.bodyText1 : null,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
