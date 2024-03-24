import 'package:ofcluxury_seller/const/const.dart';

class StoreServices {
  static getProfile(uid) {
    return firestore.collection(vendorsCollection).where('id', isEqualTo: uid).get();
  }

  static getMessages(uid) {
    return firestore.collection(chatsCollection).where('toid', isEqualTo: uid).snapshots();
  }

  static getOrders(uid) {
    return firestore.collection(ordersCollection).where('vendors', arrayContains: uid).snapshots();
  }

  static getProducts(uid) {
    return firestore.collection(productsCollection).where('vendor_id', isEqualTo: uid).snapshots();
  }
}