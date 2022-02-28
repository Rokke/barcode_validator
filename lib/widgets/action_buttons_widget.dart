import 'package:flutter/material.dart';

class ActionButtonWidget extends StatelessWidget {
  final Function() onPressed;
  final Widget icon;
  final Color? color;
  final String? tooltip;
  const ActionButtonWidget(this.icon, {Key? key, required this.onPressed, this.color, this.tooltip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: tooltip,
        icon: Container(
            decoration: BoxDecoration(
              color: color ?? Colors.blue,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [BoxShadow(offset: Offset(2, 2), color: Colors.black54)],
            ),
            child: icon),
        onPressed: onPressed);
  }
}
