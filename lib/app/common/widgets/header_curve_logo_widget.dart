import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/app_color.dart';

  class HeaderCurveLogoWidget extends StatelessWidget {
  const HeaderCurveLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtil().screenWidth;
    return SizedBox(
      width: screenWidth,
      height: 120.h,
      // height: screenHeight - 40.h,
      child: Stack(
        children: [
          Container(
              width: screenWidth,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r)),
              ),
              child: null),
          Positioned(
            bottom: 0.h,
            child: Image.asset(
              'assets/blue-banner.jpg',
              width: screenWidth,
            ),
          ),
          Positioned(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/main-logo.svg',
                    width: 60.w,
                    height: 60.h,
                
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Prostuti',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
