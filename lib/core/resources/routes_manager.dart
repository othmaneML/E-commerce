import 'package:ecomerce/core/resources/strings_manager.dart';
import 'package:ecomerce/features/orders/presintation/orer_screen.dart';
import 'package:ecomerce/features/products/presentation/edit_product/edit_product_screen.dart';
import 'package:ecomerce/features/products/presentation/manage_products/user_products_screen.dart.dart';
import 'package:ecomerce/features/products/presentation/product_overview/product_overview_screen.dart';
import 'package:ecomerce/features/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/auth_screen.dart';
import '../../features/carts/presintation/cart_screen.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/products/presentation/product_detail_screen.dart/product_detail_screen.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String onBoardingRoute = "/onBoarding";
  static const String productOverViewRoute = "/productOverViewRoute";
  static const String productDetailScreenRoute = "/productDetailScreen";
  static const String cartScreenRoute = "/cartScreen";
  static const String orderScreenRoute = "/orderScreen";
  static const String manageUserProductsScreenRoute = "/manageUserProducts";
  static const String editProductsScreenRoute = "/editProducts";
  static const String authentication = " '/auth'";
}

class RouteGenerator {


  RouteGenerator();
  static Route<dynamic> getRoute(
      RouteSettings settings) {
   
    
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.productOverViewRoute:
        return MaterialPageRoute(builder: (_) => ProductsOverviewScreen());
      case Routes.cartScreenRoute:
        return MaterialPageRoute(builder: (_) => CartScreen());
      case Routes.orderScreenRoute:
        return MaterialPageRoute(builder: (_) => OrdersScreen());
      case Routes.productDetailScreenRoute:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
                  productDetail: product,
                ));
      case Routes.manageUserProductsScreenRoute:
        return MaterialPageRoute(builder: (_) => UserProductsScreen());
      case Routes.editProductsScreenRoute:
        final product = settings.arguments as Product?;
        return MaterialPageRoute(builder: (_) => EditProductScreen(product));
      case Routes.authentication:
        return MaterialPageRoute(builder: (_) => AuthScreen());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
