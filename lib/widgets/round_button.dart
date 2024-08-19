import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const RoundButton({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
  });

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(14)),
          child:  Center(
            child: widget.loading == true ? const  CircularProgressIndicator.adaptive(strokeWidth: 3.0,backgroundColor: Colors.white,) : Text(
              widget.title.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )),
    );
  }
}
