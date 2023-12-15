import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  Future<UserCredential?> signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      await postUser();

      return userCredential;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error $e");
      return null;
    }
  }

  postUser() async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'name': 'John Doe',
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error $e");
    }
  }

  Future<String> addToCart(
    String userId,
    String testId,
    int quantity,
    String testName,
    num offerPrice,
    num originalPrice,
  ) async {
    try {
      CollectionReference cartRef = FirebaseFirestore.instance
          .collection('user_carts')
          .doc(userId)
          .collection('cart_items');

      await cartRef.doc(testId).set({
        'quantity': quantity,
        'test_id': testId,
        'test_name': testName,
        'offer_price': offerPrice,
        'original_price': originalPrice,
      });
      return "Success";
    } catch (e) {
      return "Failed";
    }
  }

  Future<void> updateCart(String userId, String testId, int newQuantity) async {
    CollectionReference cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');

    await cartRef.doc(testId).update({
      'quantity': newQuantity,
    });
  }

  Future<int> getCartItemCount(String userId) async {
    try {
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('user_carts')
          .doc(userId)
          .collection('cart_items')
          .get();
      return cartSnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> checkIfAddedToCart(String userId, String testId) async {
    try {
      DocumentSnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('user_carts')
          .doc(userId)
          .collection('cart_items')
          .doc(testId)
          .get();
      return cartSnapshot.exists;
    } catch (e) {
      Fluttertoast.showToast(msg: "failed to check cart");
      return false;
    }
  }
}
