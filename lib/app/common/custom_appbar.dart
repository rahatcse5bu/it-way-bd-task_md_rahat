import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../constant/app_color.dart';
import '../routes/app_pages.dart';
import 'controller/app_controller.dart';
import 'utils/task_utils.dart';

class CustomAppBar {
  // Static method to create a custom app bar
  static PreferredSizeWidget appBar({
    required String title,
    bool centerTitle = true,
    Color? backgroundColor,
    Color? titleColor,
    String? name,
    List<Widget>? actions,
    IconData? leadingIcon,
    Widget? leadingWidget,
    double? leadingWidth,
    String? profilePicture,
    VoidCallback? onLeadingPressed,
  }) {
    final AppController appController = Utils.getAppController();

    return AppBar(
      scrolledUnderElevation: 0,
      leadingWidth: leadingWidth ?? 180,
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      automaticallyImplyLeading: true,
      actions: actions ??
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(
                            side: BorderSide(
                      color: Colors.grey,
                    ))),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      child: Image.asset("assets/notification.jpg"),
                    )),
                GestureDetector(
                  onTap: () {
                    Get.offAllNamed(Routes.profile);
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: const ShapeDecoration(
                          shape: CircleBorder(
                              side: BorderSide(
                        color: Colors.grey,
                      ))),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,
                        child: profilePicture != null
                            ? Image.network(profilePicture)
                            : Image.asset("assets/default-male.jpg"),
                      )),
                ),
              ],
            )
          ],
      leading: leadingWidget ??
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/header-logo.jpg',
                  // height: 47.h,
                  // width: 113.w,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Obx(() => Text(
                      'Hi ${name ?? "Rahat"} ${appController.userId.value}!',
                      style: TextStyle(fontSize: 16.sp),
                    ))
              ],
            ),
          ),
    );
  }
}
