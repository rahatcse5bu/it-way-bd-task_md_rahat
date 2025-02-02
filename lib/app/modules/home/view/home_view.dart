import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/custom_appbar.dart';
import '../../../common/custom_simple_appbar.dart';
import '../../../common/widgets/bottom_nav_bar_widget.dart';
import '../controller/home_controller.dart';
import '../widgets/home_main_widget.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final List<Widget> _pages = [
    const HomeMainWidget(),


    const Center(child: Text('More Page')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppBar.appBar(
          title: 'IT Way BD Task',
          backgroundColor: Colors.white,
          centerTitle: true, 
          leadingWidget: null

         ),
      body: Obx(() => Container(
          padding: EdgeInsets.fromLTRB(19.w, 12.h, 19.w, 12.h),
          color: Colors.white,
          child: _pages[controller.currentIndex.value])),
      bottomNavigationBar: Obx(() => CustomBottomNavBar(
            currentIndex: controller.currentIndex.value,
            onTap: (value) {
              if (value == 4) {
                // Get.bottomSheet(
                //   const HomeBottomNavMoreBottomSheet(),
                //   isScrollControlled:
                //       false, // Optional, to allow for full-screen or scrollable content
                //   backgroundColor: Colors
                //       .white, // Optional, background color for the bottom sheet
                //   ignoreSafeArea: false,
                //   isDismissible: true,
                // );
              } else {
                controller.currentIndex.value = value;
              }
            },
          )),
    );
  }
}
