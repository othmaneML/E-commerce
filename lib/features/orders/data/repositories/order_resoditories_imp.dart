import 'package:dartz/dartz.dart';
import 'package:ecomerce/features/orders/data/models/order_model.dart';

import '../../../../core/errors/exeptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network_info/network_info.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repositories.dart';
import '../datasources/remote_data_soure.dart';

class OrderRepositoryImp implements OrderRepository {
  final OrderRemoteDataSource orderRemoteDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImp(
      {required this.orderRemoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<OrderItem>>> getOrders() async {
    if (await networkInfo.isConnected) {
      try {
        final List<OrderItem> orders = [];
        final ordersfromServer = await orderRemoteDataSource.getAllOrders();
        ordersfromServer.forEach(
          (element) => orders.add(OrderItem(
              amount: element.amount,
              dateTime: element.dateTime,
              id: element.id,
              products: element.products)),
        );
        return right(orders);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> setOrder(OrderItem order) async {
 
    final orderModelItem = OrderModel(
        amount: order.amount,
        products: order.products,
        dateTime: order.dateTime);

        print('sett ordermodel $orderModelItem');
          

    if (await networkInfo.isConnected) {
      try {
        await orderRemoteDataSource.addOrder(orderModelItem);
         print('sett ordermodel $orderModelItem');

        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
