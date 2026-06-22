import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/tasks/cubit/add_new_task_cubit.dart';

import 'app.dart';

import 'features/auth/cubit/auth_cubit.dart';
import 'features/tasks/cubit/tasks_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit()..getUserData(),
        ),
        BlocProvider(
          create: (_) => TasksCubit(),
        ),
        BlocProvider(
          create: (_) => AddNewTaskCubit(),
        ),
      ],
      child: const CuratorApp(),
    ),
  );
}
