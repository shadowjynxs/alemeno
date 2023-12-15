// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:alemeno/screens/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class SuccessPage extends StatefulWidget {
  final String scheduleTime;
  final List<String> testId;
  final List<String> testName;
  final String userId;

  const SuccessPage({
    super.key,
    required this.scheduleTime,
    required this.testId,
    required this.testName,
    required this.userId,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  void initState() {
    super.initState();
    moveItemsToOrderedItems(widget.userId, widget.testId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 10.h),
              child: Text(
                "Success",
                style: TextStyle(
                  color: Color(0xff10217D),
                  fontSize: 5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffC6C6C6),
                  ),
                  borderRadius: BorderRadius.circular(1.h),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      Image.asset('lib/assets/success.png'),
                      SizedBox(height: 4.h),
                      Text(
                        "Lab tests have been scheduled successfully, You will receive a mail of the same.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff0F172A),
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        widget.scheduleTime,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff667085),
                          fontSize: 4.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFF10217D),
                          ),
                        ),
                      ),
                      child: Text(
                        "Back to home",
                        style: TextStyle(
                          color: const Color(0xFF10217D),
                          fontSize: 3.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 1.w),
                      child: Icon(
                        Icons.arrow_forward_outlined,
                        color: const Color(0xFF10217D),
                        size: 2.h,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> moveItemsToOrderedItems(String userId, List<String> itemIds) async {
  try {
    for (String itemId in itemIds) {
      // Read the item from cart collection
      DocumentSnapshot<Map<String, dynamic>> itemSnapshot = await FirebaseFirestore.instance.collection('user_carts').doc(userId).collection('cart_items').doc(itemId).get();

      if (itemSnapshot.exists) {
        // Add item to ordered_items collection
        await FirebaseFirestore.instance.collection('user_carts').doc(userId).collection('ordered_items').doc(itemId).set(itemSnapshot.data()!);

        // Remove item from cart collection
        await FirebaseFirestore.instance.collection('user_carts').doc(userId).collection('cart_items').doc(itemId).delete();
      } else {
        // Handle case when the item doesn't exist in the cart
      }
    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error moving item: $e');
  }
}
