import 'package:alemeno/screens/cartpage/desktop/desktop_cart_page.dart';
import 'package:alemeno/screens/homepage/responsive/desktop/desktop_widgets.dart';
import 'package:alemeno/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class DesktopPage extends StatefulWidget {
  const DesktopPage({super.key});

  @override
  State<DesktopPage> createState() => _DesktopPageState();
}

class _DesktopPageState extends State<DesktopPage> {
  User? user;
  String? uid;
  String addToCart = "Add to cart";
  late ValueNotifier<int?> cartCountNotifier;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    loginAnon();
    uid = auth.currentUser!.uid;
    cartCountNotifier = ValueNotifier<int?>(null);
    fetchCart();
  }

  void loginAnon() async {
    UserCredential? userCredential = await AuthService().signInAnonymously();
    if (userCredential != null) {
      user = userCredential.user;
      Fluttertoast.showToast(msg: "Success");
    } else {
      Fluttertoast.showToast(msg: "Error");
    }
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 10.w,
                right: 10.w,
                top: 3.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "LOGO",
                            style: TextStyle(
                              color: const Color(0xff3A3A3A),
                              fontWeight: FontWeight.w600,
                              fontSize: 6.sp,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Home",
                                    style: TextStyle(
                                      color: const Color(0xff10217D),
                                      fontSize: 3.2.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(
                                    Icons.circle,
                                    size: 1.h,
                                  )
                                ],
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                "View tests",
                                style: TextStyle(
                                  color: const Color(0xff7A7A7A),
                                  fontSize: 3.2.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                "About us",
                                style: TextStyle(
                                  color: const Color(0xff7A7A7A),
                                  fontSize: 3.2.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                "Contact",
                                style: TextStyle(
                                  color: const Color(0xff7A7A7A),
                                  fontSize: 3.2.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
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
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff10217D),
                                ),
                                borderRadius: BorderRadius.circular(5.h),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 1.w,
                                  vertical: 0.3.h,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.shopping_cart,
                                      color: Color(0xFF10217D),
                                    ),
                                    SizedBox(width: 0.5.w),
                                    Text(
                                      "Cart",
                                      style: TextStyle(
                                        color: const Color(0xff10217D),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 3.2.sp,
                                      ),
                                    ),
                                    SizedBox(width: 0.5.w),
                                    ValueListenableBuilder<int?>(
                                      valueListenable: cartCountNotifier,
                                      builder: (context, value, _) {
                                        return CartCountWidget(count: value);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      customHeader(
                        "Popular lab tests",
                        const Color(0xFF10217D),
                        false,
                        8.sp,
                        8.sp,
                        2.h,
                        3.h,
                        0.w,
                        1.h,
                        FontWeight.w700,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              customBox("Popular tests", false),
                              SizedBox(width: 1.w),
                              customBox("Fever", true),
                              SizedBox(width: 1.w),
                              customBox("Covid 19", true),
                              SizedBox(width: 1.w),
                              customBox("Allergy Profiles", true),
                              SizedBox(width: 1.w),
                              customBox("Fittness", true),
                            ],
                          ),
                          Row(
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
                                  "View more",
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
                          )
                        ],
                      ),
                      StreamBuilder(
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
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: GridView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: MediaQuery.of(context).size.width > 1498
                                        ? MediaQuery.of(context).size.width / 1500
                                        : MediaQuery.of(context).size.width >= 1024
                                            ? MediaQuery.of(context).size.width >= 1600
                                                ? MediaQuery.of(context).size.width / 2200
                                                : MediaQuery.of(context).size.width / 1900
                                            : MediaQuery.of(context).size.width / 1350,
                                    crossAxisCount: MediaQuery.of(context).size.width > 1498
                                        ? (MediaQuery.of(context).size.width ~/ 500)
                                        : MediaQuery.of(context).size.width < 1025
                                            ? (MediaQuery.of(context).size.width ~/ 250)
                                            : MediaQuery.of(context).size.width >= 1600
                                                ? (MediaQuery.of(context).size.width ~/ 400).toInt()
                                                : (MediaQuery.of(context).size.width ~/ 300).toInt(),
                                    crossAxisSpacing: 4.w,
                                    mainAxisSpacing: 5.h,
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
                                  }),
                            );
                          }),
                    ],
                  ),
                  Center(
                    child: customHeader(
                      "Popular Packages",
                      const Color(0xFF10217D),
                      false,
                      8.sp,
                      8.sp,
                      2.h,
                      3.h,
                      0.w,
                      1.h,
                      FontWeight.w700,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
                            child: Row(
                              children: [
                                customBox("All packages", false),
                                SizedBox(width: 1.w),
                                customBox("Elderly", true),
                                SizedBox(width: 1.w),
                                customBox("Heart", true),
                                SizedBox(width: 1.w),
                                customBox("Women Health", true),
                                SizedBox(width: 1.w),
                                customBox("Men", true),
                              ],
                            ),
                          ),
                          Row(
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
                                  "View more",
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
                          )
                        ],
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('lab_package').orderBy('test_id').snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Error ${snapshot.error}");
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: GridView.builder(
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: MediaQuery.of(context).size.width >= 1025
                                    ? MediaQuery.of(context).size.width >= 1600
                                        ? MediaQuery.of(context).size.width / 1700
                                        : MediaQuery.of(context).size.width / 1800
                                    : MediaQuery.of(context).size.width / 1150,
                                crossAxisCount: MediaQuery.of(context).size.width >= 1000
                                    ? MediaQuery.of(context).size.width >= 1600
                                        ? (MediaQuery.of(context).size.width ~/ 500).toInt()
                                        : (MediaQuery.of(context).size.width ~/ 500).toInt()
                                    : (MediaQuery.of(context).size.width ~/ 350).toInt(),
                                crossAxisSpacing: 4.w,
                                mainAxisSpacing: 5.h,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                                return CustomPackageContainer(
                                  tests: data,
                                  userId: uid!,
                                  onAddToCart: onAddToCart,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.grey.shade800),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                  top: 6.h,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 3.w, top: 3.h, bottom: 3.h, right: 7.w),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1.h)),
                              child: Text(
                                "LOGO",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 3.sp,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              child: Text(
                                "Join Us",
                                style: TextStyle(color: Colors.white, fontSize: 3.sp, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.video_call, color: Colors.white),
                                SizedBox(width: 0.7.w),
                                const Icon(Icons.facebook, color: Colors.white),
                                SizedBox(width: 0.7.w),
                                const Icon(Icons.social_distance, color: Colors.white),
                                SizedBox(width: 0.7.w),
                                const Icon(Icons.chat, color: Colors.white),
                                SizedBox(width: 0.7.w),
                                const Icon(Icons.chat, color: Colors.white),
                              ],
                            )
                          ],
                        ),
                        customFooterCol("Company", "About us", "Contact us", "Terms & Conditions", "Pricing", "Testimonials"),
                        customFooterCol("Support", "Help center", "Terms of service", "Legal", "Privacy Policy", "Status"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Stay up to date",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 4.sp,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0.5.h)),
                              padding: EdgeInsets.only(right: 2.w, top: 1.h, bottom: 1.h, left: 0.5.w),
                              child: Text(
                                "Enter your email address",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.h, top: 5.h),
                      child: const Text(
                        "Name @ 2023. All rights reserved.",
                        style: TextStyle(color: Colors.white),
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

Widget customText(String text, FontWeight weight) {
  return Padding(
    padding: EdgeInsets.only(bottom: 1.h),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 3.5.sp,
        fontWeight: weight,
      ),
    ),
  );
}

Widget customFooterCol(
  String s1,
  String s2,
  String s3,
  String s4,
  String s5,
  String s6,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      customText(s1, FontWeight.w600),
      customText(s2, FontWeight.w500),
      customText(s3, FontWeight.w500),
      customText(s4, FontWeight.w500),
      customText(s5, FontWeight.w500),
      customText(s6, FontWeight.w500),
    ],
  );
}

Widget customBox(String text, bool isBg) {
  return Container(
    decoration: BoxDecoration(
      color: isBg ? Colors.white : const Color(0xff10217D),
      borderRadius: BorderRadius.circular(1.h),
      border: Border.all(
        color: const Color(0xff10217D),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: 1.h,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isBg ? const Color(0xff10217D) : Colors.white,
          fontSize: 2.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
