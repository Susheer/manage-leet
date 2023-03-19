import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:task_management/core/res/color.dart';
import 'package:task_management/core/routes/routes.dart';
import 'package:task_management/models/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
    ChangeNotifierProvider<AppState>(create: (context)=>AppState())
    ],
    child: Sizer(builder: (context, orientation, deviceType) {
    return MaterialApp(
    title: 'Task Management',
    debugShowCheckedModeBanner: false,
    theme: AppColors.getTheme,
    initialRoute: Routes.onBoarding,
    onGenerateRoute: RouterGenerator.generateRoutes,
    );
    })
    );
  }
}
