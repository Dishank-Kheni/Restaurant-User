import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductFirebase {
  static Future<void> placeOrder({
    required double price,
    required int tableNo,
    required String productName,
    required String userId,
    required String tableId,
    required String productId,
    required double totalAmount,
    required int qty,
    required int chefRemainingOrder,
    // @required int submittedOrder,
    required int currentPerformingOrder,
  }) async {
    print('placce order');
    await FirebaseFirestore.instance.collection('order').add({
      'price': price,
      'orderTime': DateTime.now(),
      'tableNo': tableNo,
      'productName': productName,
      'productId': productId,
      'tableId': tableId,
      'userId': userId,
      'qty': qty,
      'totalAmount': totalAmount,
      'chefRemainingOrder': chefRemainingOrder,
      //'submittedOrder': submittedOrder,
      'currentPerformingOrder': currentPerformingOrder,
    }).then((e) {
      FirebaseFirestore.instance
          .collection('order')
          .doc(e.id)
          .update({'orderId': e.id});
    });
  }

  static Future<void> updateProductTotalOrders(
      {String? productId, int? orders}) async {
    final _prodData = await FirebaseFirestore.instance
        .collection('product')
        .doc(productId)
        .get();
    final _prodOrder = _prodData.data()!['totalOrder'];
    int order = _prodOrder + orders;
    print('jyfhyfy' + order.toString());
    await FirebaseFirestore.instance
        .collection('product')
        .doc(productId)
        .update({'totalOrder': order});
  }

  static Future<void> deleteTable({@required String? tableId}) async {
    await FirebaseFirestore.instance.collection('table').doc(tableId).delete();
  }

  static Future<void> updateRequest({
    required String requestId,
    required int tableNo,
    required String userId,
    required bool isRequestAccept,
    required String tableId,
  }) async {
    await FirebaseFirestore.instance
        .collection('request')
        .doc(requestId)
        .update({
      'tableNo': tableNo,
      'userId': userId,
      'isRequestAccept': isRequestAccept,
      'tableId': tableId,
    });
  }

  static Future<void> updateUser(
      {required int tableNo,
      required String userId,
      required String tableId,
      required bool isRequestAccept,
      required bool isRequestSent}) async {
    await FirebaseFirestore.instance.collection('user').doc(userId).update({
      'tableNo': tableNo,
      'tableId': tableId,
      'isRequestAccept': isRequestAccept,
      'isRequestSent': isRequestSent
    });
  }

  static Future<void> deleteRequest({required String requestId}) async {
    await FirebaseFirestore.instance
        .collection('request')
        .doc(requestId)
        .delete();
  }

  static Future createNewTable(
      {required String reqId,
      required String userId,
      required String tableId,
      required int tableNo,
      required String userName,
      required String userEmail}) async {
    await FirebaseFirestore.instance.collection('table').doc(tableId).set({
      'userId': userId,
      'tableNo': tableNo,
      'requestId': reqId,
      'tableId': tableId,
      'userName': userName,
      'userEmail': userEmail,
      'isCreatedByUser': false,
    });
  }
}
