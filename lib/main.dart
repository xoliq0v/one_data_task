import 'package:flutter/material.dart';
import 'app.dart';
import 'core/singleton/injection.dart' as di;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(App());
}