import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/custom_appbar.dart';
import '../../../common/custom_simple_appbar.dart';
import '../../../common/widgets/bottom_nav_bar_widget.dart';
import '../../contests/views/it_way_bd_task_view.dart';
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
          leadingWidget: null

         ),
      body:  Container(
          padding: EdgeInsets.fromLTRB(19.w, 12.h, 19.w, 12.h),
          color: Colors.white,
          child: ITWayBDTaskView()),
   
    );
  }
}
