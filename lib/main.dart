import 'package:ecomerce/core/resources/routes_manager.dart';

import 'package:ecomerce/features/products/presentation/product_detail_screen.dart/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/resources/theme_manager.dart';
import 'features/auth/presentation/cubit/authentication_cubit.dart';
import 'injection_container.dart' as di;

import 'features/carts/presintation/bloc/cart_bloc/cart_bloc.dart';

import 'features/orders/presintation/bloc/order_bloc.dart';
import 'features/products/presentation/bloc/products_block/products_block_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.inti();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey =
      di.sl<GlobalKey<NavigatorState>>();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => di.sl<ProductsBloc>(),
          ),
          BlocProvider(
              create: (context) => di.sl<OrderBloc>()..add(GetOrdersEvent())),
          BlocProvider(
              create: (context) => di.sl<CartBloc>()..add(GetCartEvent())),
          BlocProvider(create: ((context) => di.sl<AuthenticationCubit>()))
        ],
        child: MaterialApp(
          theme: getApplicationTheme(),
            navigatorKey: _navigatorKey,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) => RouteGenerator.getRoute(settings),
            initialRoute: Routes.splashRoute));
  }
}
