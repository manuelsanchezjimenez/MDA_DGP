import 'package:app_dgp/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundButton extends StatelessWidget{
  final String text;
  late IconData icon;
  final VoidCallback onPressed;
  final Color color, textColor;
  final double width;
  final double height;

  RoundButton({
    Key? key,
    required this.text,
    //required this.icon,
    required this.onPressed,
    required this.color,
    this.textColor = kPrimaryWhite,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FlatButton(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            color: color,
            onPressed: onPressed,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.lexend(
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                      color: textColor,
                    ),
                  ),
                ]
            )
        ),
      ),
    );
  }

}