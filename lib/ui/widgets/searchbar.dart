import 'package:flutter/material.dart';
import 'package:frontend/ui/shared/app_colors.dart';

class SearchBar extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final int maxLength;
  final Icon? icon;
  final Color color;
  final Color backgroundColor;
  final Function(String)? onSavedFun;
  final TextInputType textInputType;

  const SearchBar({
    Key? key,
    this.title = "Wyszukaj",
    required this.controller,
    this.maxLength = 40,
    this.color = primaryColor,
    this.backgroundColor = Colors.white,
    this.icon,
    this.onSavedFun,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          //initialValue: "",
          controller: widget.controller,
          maxLength: widget.maxLength,
          keyboardType: widget.textInputType,
          onFieldSubmitted: widget.onSavedFun,
          decoration: InputDecoration(
            icon: widget.icon,
            labelText: widget.title,
            labelStyle: TextStyle(
              color: widget.color,
            ),
            border: InputBorder.none,
            counterText: "",
            // enabledBorder: UnderlineInputBorder(
            //   borderSide: BorderSide(color: widget.color),
            // ),
          ),
        ),
      ),
    );
  }
}
