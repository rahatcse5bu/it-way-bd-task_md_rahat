import 'package:IT_Way_BD/app/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/custom_appbar.dart';
import '../../../common/custom_buttons.dart';
import '../../../common/custom_simple_appbar.dart';
import '../../../common/utils/task_utils.dart';
import '../../../common/widgets/bottom_nav_bar_widget.dart';
import '../../it_way_bd_tasks/views/it_way_bd_task_view.dart';
import '../controller/home_controller.dart';
import '../widgets/home_main_widget.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppBar.appBar(
          title: 'IT Way BD Task',
          backgroundColor: Colors.white,
          centerTitle: true,
        isBackIcon: false,
          actions: [
            GestureDetector(
                onTap: () {
                  Utils.logoutUser();
                },
                child: Icon(
                  Icons.logout_outlined,
                  color: AppColors.primary,
                )),
            SizedBox(
              width: 10.w,
            )
          ]),
      body: Container(
          padding: EdgeInsets.fromLTRB(19.w, 12.h, 19.w, 12.h),
          color: Colors.white,
          child: ITWayBDTaskView()),
    );
  }
}
