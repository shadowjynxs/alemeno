import 'package:alemeno/screens/homepage/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class SuccessPage extends StatefulWidget {
  final String scheduleTime;
  final String testId;
  final String testName;
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
    moveItemToOrderedItems(widget.userId, widget.testId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text(
          "Success",
          style: TextStyle(
            color: Color(0xff303030),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: const Icon(
              Icons.more_vert,
              color: Color(0xff0D99FF),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 10.h),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xffC6C6C6),
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
                        color: const Color(0xff0F172A),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.scheduleTime,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xff667085),
                        fontSize: 14.sp,
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
              setState(() {});
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const HomePage(),
                ),
                (Route<dynamic> route) => false,
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xff10217D),
                  borderRadius: BorderRadius.circular(1.h),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Text(
                    "Back to home",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<void> moveItemToOrderedItems(String userId, String itemId) async {
  try {
    // Read the item from cart collection
    DocumentSnapshot<Map<String, dynamic>> itemSnapshot = await FirebaseFirestore.instance.collection('user_carts').doc(userId).collection('cart_items').doc(itemId).get();

    if (itemSnapshot.exists) {
      // Add item to ordered_items collection
      await FirebaseFirestore.instance.collection('user_carts').doc(userId).collection('ordered_items').doc(itemId).set(itemSnapshot.data()!);

      // Remove item from cart collection
      await FirebaseFirestore.instance.collection('user_carts').doc(userId).collection('cart_items').doc(itemId).delete();
    } else {}
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error moving item: $e');
  }
}
