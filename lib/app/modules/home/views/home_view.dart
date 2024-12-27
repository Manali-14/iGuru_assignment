import 'package:assignment/app/modules/home/views/desktop_home_view_widget.dart';
import 'package:assignment/app/modules/home/views/mobile_home_view_widget.dart';
import 'package:assignment/app/utils/responsive.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Responsive(
          mobile: MobileHomeViewWidget(),
          tablet: MobileHomeViewWidget(),
          desktop: DesktopHomeViewWidget()),
    );
  }
}
