import 'package:ecomerce/core/network_info/network_info.dart';
import 'package:ecomerce/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:ecomerce/features/auth/data/data_source/remote_datasource/firebase_aut.dart';
import 'package:ecomerce/features/auth/data/models/auth_model.dart';
import 'package:ecomerce/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:ecomerce/features/auth/domain/entities/entities.dart';
import 'package:ecomerce/features/auth/domain/repositories/repositories.dart';
import 'package:ecomerce/features/auth/domain/use_cases/clear_cached_cser/clear_cached_user.dart';
import 'package:ecomerce/features/auth/domain/use_cases/get_cached_cser/get_cached_user.dart';
import 'package:ecomerce/features/auth/domain/use_cases/signe_in_Use_case/signe_in_use_case.dart';


import 'package:ecomerce/features/products/data/datasources/firebase_products_data_soure.dart';
import 'package:ecomerce/features/products/data/repositories/product_resoditories_imp.dart';
import 'package:ecomerce/features/products/domain/repositories/product_repository.dart';
import 'package:ecomerce/features/products/domain/use_cases/add_product.dart';
import 'package:ecomerce/features/products/domain/use_cases/delate_product.dart';
import 'package:ecomerce/features/products/domain/use_cases/get_products.dart';
import 'package:ecomerce/features/products/domain/use_cases/set_to_favorite.dart';
import 'package:ecomerce/features/products/domain/use_cases/update_product.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/domain/use_cases/signe_up_use_case/signe_up_use_case.dart';
import 'features/auth/presentation/cubit/authentication_cubit.dart';
import 'features/carts/data/datasources/local_data_source.dart';
import 'features/carts/data/repositories/cart_resoditories_imp.dart';
import 'features/carts/domain/repositories/cart_repositories.dart';
import 'features/carts/domain/usecases/get_products.dart';

import 'features/carts/domain/usecases/update_product.dart';
import 'features/carts/presintation/bloc/cart_bloc/cart_bloc.dart';

import 'features/orders/data/datasources/remote_data_soure.dart';
import 'features/orders/data/repositories/order_resoditories_imp.dart';
import 'features/orders/domain/repositories/order_repositories.dart';
import 'features/orders/domain/usecases/add_order.dart';
import 'features/orders/domain/usecases/get_order.dart';
import 'features/orders/presintation/bloc/order_bloc.dart';
import 'features/products/presentation/bloc/products_block/products_block_bloc.dart';

final sl = GetIt.instance;

Future<void> inti() async {
//features products
// blocs
  sl.registerLazySingleton(() => ProductsBloc(
      setToFavProductsUseCase: sl(),
      getProductsUseCase: sl(),
      updateProductsUseCase: sl(),
      addProductsUseCase: sl(),
      deleteProductsUseCase: sl()));

//usecase
//prodcut
  sl.registerLazySingleton(() => UpdateProductsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddProductsUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteProductsUseCase(repository: sl()));
  sl.registerFactory(() => SetToFavProductsUseCase(repository: sl()));

//repsitories
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImp(
      networkInfo: NetworkInfoImpl(connectionChecker: sl()),
      remoteDataSource: RemoteDataSourceImp(client: sl(),user: sl())));


// External
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => http.Client());

  //cart
  //bloc
  sl.registerFactory(() => CartBloc(
      getCartsUseCase: sl(), updateCartsUseCase: sl(), orderBloc: sl()));

  //usecase
  sl.registerLazySingleton(() => GetCartsUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateCartsUseCase(repository: sl()));
  //repository
  sl.registerLazySingleton<CartRepository>(
      () => CartRepositoryImp(cartLocalDataSource: sl()));
  //data source
  sl.registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(sharedPreferences: sl()));
  // shared preference
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //order

  sl.registerFactory(
      () => OrderBloc(getOrderUseCase: sl(), addOrderUseCase: sl()));
  //usecase
  sl.registerLazySingleton(() => GetOrderUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddOrderUseCase(repository: sl()));

  //repository
  sl.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImp(networkInfo: sl(), orderRemoteDataSource: sl()));
  //data source
  sl.registerLazySingleton<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImp(client: sl()));
  // authentication
  //cubit
  
sl.registerLazySingleton((() =>GlobalKey<NavigatorState>() ));

  sl.registerLazySingleton(
      () => AuthenticationCubit(singeInUseCase: sl(), singeUpUseCase: sl(),navigatorKey: sl(),productsBloc: sl(),clearCashedUserUseCase:sl() ,getCashedUserUseCase: sl()));
  //useCases
  sl.registerLazySingleton(() =>GetCashedUserUseCase(authRepository: sl()));
  sl.registerLazySingleton(() =>ClearCashedUserUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SingeInUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SingeUpUseCase(authRepository: sl()));
// authRepository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(fireBaseAuth: sl(),userLocalDataSource: sl()));
//data source
sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(sharedPreferences: sl(), userModel: sl()),);
  sl.registerLazySingleton<FireBaseAuth>(
      () => FireBaseAuthImp(client: sl(), networkInfo: sl(),userLocalDataSource: sl(),userModel: sl()));
  sl.registerLazySingleton(() => User());
  sl.registerLazySingleton(() => UserModel());


    //core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));
   
  
}
