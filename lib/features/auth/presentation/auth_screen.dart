import 'dart:math';

import 'package:ecomerce/core/resources/color_manger.dart';
import 'package:ecomerce/core/resources/constant_manger.dart';
import 'package:ecomerce/core/resources/routes_manager.dart';
import 'package:ecomerce/core/resources/style_manager.dart';
import 'package:ecomerce/core/resources/vlaue_manager.dart';
import 'package:ecomerce/core/snack_bar/snack_bar.dart';
import 'package:ecomerce/features/products/presentation/bloc/products_block/products_block_bloc.dart';
import 'package:ecomerce/features/products/presentation/product_overview/product_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/authentication_cubit.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: AppMargin.m12),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p8, horizontal: AppPadding.p100),
                      transform:
                          Matrix4.rotationZ(-AppSize.s12 * pi / AppSize.s180)
                            ..translate(-AppSize.s10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.s16),
                        color: ColorManager.primary,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: AppPadding.p8,
                            color: Colors.black26,
                            offset: Offset(AppSize.s0, AppSize.s2),
                          )
                        ],
                      ),
                      child: Text('MyShop',
                          style: getRegularStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s22)),
                    ),
                  ),
                  Flexible(
                    child: AuthField(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthField extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthField> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  final _passwordController = TextEditingController();

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();

    if (_authMode == AuthMode.Login) {
      BlocProvider.of<AuthenticationCubit>(context)
          .singeIn(_authData['email']!, _authData['password']!);
    } else {
      BlocProvider.of<AuthenticationCubit>(context)
          .singeUp(_authData['email']!, _authData['password']!);
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'E-Mail',
                  filled: true,
                  fillColor: ColorManager.lightGrey,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
              const SizedBox(height: AppSize.s12),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: ColorManager.lightGrey),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < AppSize.s4) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
              const SizedBox(height: AppSize.s12),
              if (_authMode == AuthMode.SignUp)
                TextFormField(
                  enabled: _authMode == AuthMode.SignUp,
                  decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      filled: true,
                      fillColor: ColorManager.lightGrey),
                  obscureText: true,
                  validator: _authMode == AuthMode.SignUp
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        }
                      : null,
                ),
              const SizedBox(
                height: 20,
              ),
              BlocConsumer<AuthenticationCubit, AuthenticationState>(
                  listener: (context, state) {
                if (state is AuthenticationSnackState) {
                  snackBar(state.message, context);
                }
              }, builder: (context, state) {
                if (state is SigningAuthenticationState) {
                  return const CircularProgressIndicator();
                } else {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(AppSize.s160, AppSize.s40),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p12, vertical: AppPadding.p8),
                    ),
                    onPressed: _submit,
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  );
                }
              }),
              TextButton(
                onPressed: _switchAuthMode,
                style: ElevatedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p28, vertical: AppPadding.p8),
                  foregroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
