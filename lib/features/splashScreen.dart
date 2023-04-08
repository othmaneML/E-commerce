

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/presentation/cubit/authentication_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthenticationCubit>(context).getCashedUser();
    return const Scaffold(
      body: Center(child: Text('loading')),
    );
  }
}