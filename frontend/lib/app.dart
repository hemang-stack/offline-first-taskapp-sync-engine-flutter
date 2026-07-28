import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';

import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/pages/signup_page.dart';

import 'features/navigation/pages/main_navigation_page.dart';

class CuratorApp extends StatelessWidget {
  const CuratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Curator',
      theme: AppTheme.darkTheme,
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoggedIn) {
            print("TOKEN:");
            print(state.user.token);
            return const MainNavigationPage();
          }

          return const SignupPage();
        },
      ),
    );
  }
}
