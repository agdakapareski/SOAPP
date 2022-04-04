import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
    this.color,
    this.text,
    this.onTap,
  }) : super(key: key);

  final Color? color;
  final String? text;
  final void Function()? onTap;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 55.9,
        decoration: BoxDecoration(
          color: widget.color,
          // borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Text(
            widget.text!,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
