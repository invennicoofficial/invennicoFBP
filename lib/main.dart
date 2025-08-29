import 'package:flutter/material.dart';
import 'package:invennico_fbp/image_picker_module.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/app_colors.dart';
import 'core/config/app_router.dart';
import 'core/utils/theme/theme_changer.dart';

void main() {
  runApp(BlocProvider(
    create: (_) => ThemeCubit(),
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Boilerplates',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //   ),
    //   home: const ImagePickerModule(),
    return BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            themeMode: themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: AppColors.colorBlack,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: AppColors.colorWhite,
            ),
          );
        }
    );
  }
}
