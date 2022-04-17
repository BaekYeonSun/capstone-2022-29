// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

AppBar appBar(Size size, String title, BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: Container(
      margin: EdgeInsets.only(left: size.width * 0.05),
      child: IconButton(
        icon: Image.asset('lib/assets/images/backIcon.png', width: size.width * 0.1, height: size.width * 0.1),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    title: title != ' ' ? Container(
      child: Center( child: title != ''? Text(title,style: TextStyle(color: Colors.black)) : Image.asset('lib/assets/images/logo_mini.png')),
      width: size.width * 0.4,
      height: size.width * 0.1,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
    ) : null,
    centerTitle: true,
    elevation: 0.0,
  );
}