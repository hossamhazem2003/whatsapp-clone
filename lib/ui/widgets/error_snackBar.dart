import 'package:flutter/material.dart';

errorSnackBar(BuildContext context,String error) {
  ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
}
