import 'package:flutter/material.dart';
import 'package:task_management/pages/add_ambulance.dart';
import 'package:task_management/pages/home.dart';
import 'package:task_management/pages/onboarding.dart';
import 'package:task_management/pages/today_task.dart';
import 'package:task_management/pages/ambulance_list.dart';

class Routes {
  static const onBoarding = "/";
  static const home = "/home";
  static const todaysTask = "/task/todays";
  static const ambulanceList = "/ambulance/list";
  static const ambulanceAdd = "/ambulance/add";
}

class RouterGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoarding:
        return MaterialPageRoute(
          builder: ((context) => const OnboardingScreen()),
        );
      case Routes.ambulanceList:
        return MaterialPageRoute(
          builder: ((context) => const AmbulanceListScreen()),
        );
      case Routes.ambulanceAdd:
        return MaterialPageRoute(
          builder: ((context) =>  AddAmbulanceScreen()),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: ((context) => const HomeScreen()),
        );
      case Routes.todaysTask:
        return MaterialPageRoute(
          builder: ((context) => const TodaysTaskScreen()),
        );
      default:
        return MaterialPageRoute(
          builder: ((context) => const HomeScreen()),
        );
    }
  }
}
