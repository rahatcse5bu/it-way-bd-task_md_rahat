import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/custom_styles.dart';
import '../../../common/widgets/header_curve_logo_widget.dart';
import '../../../constant/app_color.dart';
import '../controllers/register_controller.dart';
import '../widgets/register_form.dart';

class RegisterView extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtil().screenWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
          ),
          child: Obx(
            () => controller.isLoading.value
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  )
                : Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                     const HeaderCurveLogoWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Create Your Account',
                          style: CustomStyles.textStyle.copyWith(
                            fontSize: 24.sp,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'Manage, Track, Progress',
                          style: CustomStyles.textStyle.copyWith(
                              color: AppColors.midnightBlue.withOpacity(0.7)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const RegisterForm(),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Or',
                          style: CustomStyles.textStyle.copyWith(
                              color: AppColors.midnightBlue.withOpacity(0.7)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialButton(
                            icon: 'assets/icons/google.png',
                            onPressed: () {
                              // Handle Google login
                            },
                          ),
                          const SizedBox(width: 30),
                          SocialButton(
                            icon: 'assets/icons/facebook.png',
                            onPressed: () {
                              // Handle Facebook login
                            },
                          ),
                          const SizedBox(width: 30),
                          SocialButton(
                            icon: 'assets/icons/apple.png',
                            onPressed: () {
                              // Handle Apple login
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/login');
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.midnightBlue, width: 0.5),
      ),
      child: Image.asset(
        icon,
        width: 30.w,
        height: 30.h,
      ),
    );
  }
}
