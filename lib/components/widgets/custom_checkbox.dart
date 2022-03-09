import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  CustomCheckbox({Key? key, required this.onToggle, required this.isChecked})
      : super(key: key);
  final Function(bool isChecked) onToggle;
  final bool isChecked;
  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool? isChecked;
  @override
  void initState() {
    setState(() {
      isChecked = widget.isChecked;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.black,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      side: BorderSide(color: Colors.black),
      onChanged: (bool? value) {
        widget.onToggle(value!);
        setState(() {
          isChecked = value;
        });
      },
    );
  }
}

Color getColor(Set<MaterialState> states) {
  // const Set<MaterialState> interactiveStates = <MaterialState>{
  //   MaterialState.pressed,
  //   MaterialState.hovered,
  //   MaterialState.focused,
  // };
  // if (states.any(interactiveStates.contains)) {
  //   return Colors.blue;
  // }
  return Colors.white;
}
