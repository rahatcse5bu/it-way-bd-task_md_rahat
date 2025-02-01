import 'package:get/get.dart';
import 'package:prostuti/app/modules/contest-details/binding/contest_details_binding.dart';
import 'package:prostuti/app/modules/contest-details/view/contest_details_view.dart';
import 'package:prostuti/app/modules/onboarding/views/onboarding_view.dart';
import 'package:prostuti/app/modules/register/bindings/register_binding.dart';
import 'package:prostuti/app/modules/register/views/register_view.dart';
import 'package:prostuti/app/modules/splash/views/splash_view.dart';
import '../modules/contests/bindings/contest_binding.dart';
import '../modules/contests/views/contest_view.dart';
import '../modules/custom-exam/binding/custom_exam_binding.dart';
import '../modules/custom-exam/view/custom_exam_view.dart';
import '../modules/email_varification/binding/email_varification_binding.dart';
import '../modules/email_varification/view/email_varification_view.dart';
import '../modules/exam-types/bindings/exam-type-binding.dart';
import '../modules/exam-types/views/exam-type-view.dart';
import '../modules/home/binding/home_binding.dart';
import '../modules/home/view/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/package-details/binding/package_details_binding.dart';
import '../modules/package-details/view/package_details_view.dart';
import '../modules/questions/bindings/question_bindings.dart';
import '../modules/questions/views/question_view.dart';
import '../modules/search-page/binding/search_binding.dart';
import '../modules/search-page/view/search_view.dart';

class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const register = '/register';
  static const emailVarification = '/email-varification';
  static const login = '/login';
  static const profile = '/profile';
  static const profileEdit = '/profile-edit';
  static const home = '/home';
  static const search = '/search';
  static const jobCircular = '/job-circulars';
  static const jobCategories = '/job-categories';
  static const examTypes = '/exam-types';
  static const customExam = '/custom-exam';
  static const questions = '/questions';
  static const contests = '/contests';
  static const contestDetails = '/contest-details/';
  static const packageDetails = '/package-details/';
  // Dynamic route generator for single contest
  static String singleContest(String id) => '/contest/$id';
}

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.emailVarification,
      page: () => const EmailVarificationView(),
      binding: EmailVarificationBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),

 
    GetPage(
      name: Routes.examTypes,
      page: () => const ExamTypeView(),
      binding: ExamTypeBinding(),
    ),
    GetPage(
      name: Routes.customExam,
      page: () => const CustomExamView(),
      binding: CustomExamBinding(),
    ),
    GetPage(
      name: '/contests',
      page: () => const ContestView(),
      binding: ContestBinding(),
    ),
    GetPage(
      // name: '/contest/:id',
      name: '/contest-details/',
      page: () => const ContestDetailsView(),
      binding: ContestDetailsBinding(),
    ),
    GetPage(
      name: '/package-details/',
      page: () => const PackageDetailsView(),
      binding: PackageDetailsBinding(),
    ),
    GetPage(
      name: '/questions',
      page: () => const QuestionView(),
      binding: QuestionBinding(),
    ),
  ];
}
