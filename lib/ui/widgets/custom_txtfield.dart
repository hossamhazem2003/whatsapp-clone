import 'package:flutter/material.dart';
import 'package:whatsapp/utiliz/colors.dart';

Widget customTextField(String hintText, TextEditingController controller, Widget icon) {
  return Container(
      color: const Color(0xff191819),
      margin: const EdgeInsets.only(right: 30, left: 30),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: backgroundColor,
          filled: true,
          hintText: hintText,
          suffixIcon: icon,
        ),
      ));
}


/*
(value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
*/ 