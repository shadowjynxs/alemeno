import 'package:alemeno/screens/cartpage/mobile/mobile_cart_page.dart';
import 'package:alemeno/screens/homepage/responsive/mobile/mobile_widgets.dart';
import 'package:alemeno/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class MobilePage extends StatefulWidget {
  const MobilePage({super.key});

  @override
  State<MobilePage> createState() => _MobilePageState();
}

class _MobilePageState extends State<MobilePage> {
  User? user;
  String? uid;
  String addToCart = "Add to cart";
  late ValueNotifier<int?> cartCountNotifier;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    uid = auth.currentUser!.uid;
    cartCountNotifier = ValueNotifier<int?>(null);
    fetchCart();
  }

  void fetchCart() async {
    int itemCount = await AuthService().getCartItemCount(uid!);
    cartCountNotifier.value = itemCount;
  }

  void onAddToCart() async {
    fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            UserCredential? userCredential = await AuthService().signInAnonymously();
            if (userCredential != null) {
              user = userCredential.user;
              Fluttertoast.showToast(msg: "Success");
            } else {
              Fluttertoast.showToast(msg: "Error");
            }
          },
          child: Text(
            "LOGO",
            style: TextStyle(
              color: const Color(0xFF303030),
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    userId: uid!,
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(
                right: 7.w,
              ),
              child: Row(
                children: [
                  ValueListenableBuilder<int?>(
                    valueListenable: cartCountNotifier,
                    builder: (context, value, _) {
                      return CartCountWidget(count: value);
                    },
                  ),
                  const Icon(
                    Icons.shopping_cart,
                    color: Color(0xFF10217D),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customHeader("Popular lab tests", const Color(0xFF10217D), true, 20.sp, 12.sp, 2.h, 1.h, 7.w, 1.w, FontWeight.w500),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 1.h,
                horizontal: 7.w,
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('lab_tests').orderBy('test_id').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error ${snapshot.error}");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery.of(context).size.width <= 350
                              ? MediaQuery.of(context).size.width / 250
                              : MediaQuery.of(context).size.width <= 430
                                  ? MediaQuery.of(context).size.width / 600
                                  : MediaQuery.of(context).size.width / 600,
                          crossAxisCount: MediaQuery.of(context).size.width <= 430 ? (MediaQuery.of(context).size.width ~/ 180).toInt() : (MediaQuery.of(context).size.width ~/ 220).toInt(),
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                          return CustomContainer(
                            tests: data,
                            userId: uid!,
                            onAddToCart: onAddToCart,
                          );
                        });
                  }),
            ),
            customHeader("Popular Packages", const Color(0xFF10217D), false, 20.sp, 12.sp, 2.h, 1.h, 7.w, 1.w, FontWeight.w500),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 1.h,
                horizontal: 12.w,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(
                      0xffDBDDE0,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(1.h),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                50.h,
                              ),
                              color: const Color.fromARGB(56, 47, 129, 237),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(1.h),
                              child: Icon(
                                Icons.medication_outlined,
                                size: 5.h,
                                color: const Color(0xff2F80ED),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff16C2D5),
                              borderRadius: BorderRadius.circular(1.h),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 1.5.w,
                                    top: 0.5.h,
                                    bottom: 0.5.h,
                                  ),
                                  child: const Icon(
                                    Icons.verified_user,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 1.5.h,
                                    top: 0.5.h,
                                    bottom: 0.5.h,
                                  ),
                                  child: Text(
                                    "Safe",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Text(
                          "Full Body checkup",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Included 92 tests",
                            style: TextStyle(
                              color: const Color(0xff6C87AE),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "• Blood Glucose Fasting",
                            style: TextStyle(
                              color: const Color(0xff6C87AE),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "• Liver Function Test",
                            style: TextStyle(
                              color: const Color(0xff6C87AE),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xff6C87AE),
                                ),
                              ),
                            ),
                            child: Text(
                              "View more",
                              style: TextStyle(
                                color: const Color(0xff6C87AE),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹ 2000/-",
                                style: TextStyle(
                                  color: const Color(0xff1BA9B5),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              addToCartButton(
                                "Add to cart",
                                const Color(0xff10217D),
                                const Color(0xFF10217D),
                                FontWeight.w700,
                                10.sp,
                                true,
                                true,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
