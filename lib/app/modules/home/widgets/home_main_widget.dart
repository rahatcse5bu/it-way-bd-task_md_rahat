import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/custom_buttons.dart';
import '../../../common/custom_it_way_bd_dialog.dart';
import '../../../common/utils/task_utils.dart';
import '../../it_way_bd_tasks/views/it_way_bd_task_view.dart';
import '../controller/home_controller.dart';

class HomeMainWidget extends GetWidget<HomeController> {
  const HomeMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 19.w),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => Text(
                  'Hi  ${jsonDecode(jsonEncode(controller.userId.value))}',
                  style: TextStyle(fontSize: 16.sp),
                )),
            CustomButton.button(
                text: "Logout",
                onPressed: () {
                  Utils.logoutUser();
                }),
            SizedBox(
              height: 10.h,
            ),
            // CustomButton.button(
            //     text: "Dialog",
            //     onPressed: () {

            //       PostutiDialog.warning(
            //         "Are you sure you want to proceed?",
            //         isBottomButton: true,
            //         noOfButtons: 3,
            //         buttonLabels: ["Yes", "No", "Cancel"],
            //         buttonActions: [
            //           () => print("Yes pressed"),
            //           () => print("No pressed"),
            //           () => Get.back(),
            //         ],
            //       );
            //     }),
             SizedBox(
              height: 800.h,
              child: ITWayBDTaskView()),
      
         
          ],
        ),
      ),
    );
  }
}
