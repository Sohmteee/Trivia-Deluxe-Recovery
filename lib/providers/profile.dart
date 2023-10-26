import 'package:flutter/material.dart';
import 'package:trivia/data/box.dart';

class ProfileProvider extends ChangeNotifier{
  String? username = box.get("username", defaultValue: null);
}