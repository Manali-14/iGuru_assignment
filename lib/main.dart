import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.isLocationServiceEnabled();
  await Hive.initFlutter();
  await Hive.openBox('user_data');
  runApp(const MyAssignment());
}

class MyAssignment extends GetView {
  const MyAssignment({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'iGuru Assignment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppPages.intial,
      getPages: AppPages.routes,
    );
  }
}
