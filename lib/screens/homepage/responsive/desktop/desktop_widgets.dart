
import 'package:alemeno/services/services.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomPackageContainer extends StatefulWidget {
  final Map<String, dynamic> tests;
  final String userId;
  final Function() onAddToCart;
  const CustomPackageContainer({
    super.key,
    required this.tests,
    required this.userId,
    required this.onAddToCart,
  });

  @override
  State<CustomPackageContainer> createState() => _CustomPackageContainerState();
}

class _CustomPackageContainerState extends State<CustomPackageContainer> {
  bool isAddedToCart = false;
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: AuthService().checkIfAddedToCart(widget.userId, widget.tests['test_id']),
        builder: (BuildContext context, AsyncSnapshot<bool> cartSnapshot) {
          if (cartSnapshot.connectionState == ConnectionState.waiting) {}

          bool isAddedToCart = cartSnapshot.data ?? false;

          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: 1.h,
              horizontal: 0.w,
            ),
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 3,
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
                  horizontal: 2.w,
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
                              size: 3.h,
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
                                  left: 0.5.w,
                                  top: 0.5.h,
                                  bottom: 0.5.h,
                                ),
                                child: const Icon(
                                  Icons.verified_user,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 0.5.w),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 1.h,
                                  top: 0.5.h,
                                  bottom: 0.5.h,
                                ),
                                child: Text(
                                  "Safe",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      child: Text(
                        "${widget.tests['test_name']}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 3.5.sp,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Included ${widget.tests['test_count']} tests",
                          style: TextStyle(
                            color: const Color(0xff6C87AE),
                            fontSize: 4.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "• ${widget.tests['sub_tests'][0]}",
                          style: TextStyle(
                            color: const Color(0xff6C87AE),
                            fontSize: 3.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "• ${widget.tests['sub_tests'][1]}",
                          style: TextStyle(
                            color: const Color(0xff6C87AE),
                            fontSize: 3.sp,
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
                              fontSize: 3.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹ ${widget.tests['test_price']}/-",
                              style: TextStyle(
                                color: const Color(0xff1BA9B5),
                                fontSize: 4.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            if (isAddedToCart)
                              addToCartButton(
                                "Added to cart",
                                Colors.white,
                                const Color(0xFF16C2D5),
                                FontWeight.w700,
                                3.sp,
                                false,
                                false,
                              ),
                            if (!isAddedToCart)
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isClicked = true;
                                  });
                                  await Future.delayed(
                                    const Duration(microseconds: 100),
                                  );
                                  final message =
                                      await AuthService().addToCart(widget.userId, widget.tests['test_id'], 1, widget.tests['test_name'], widget.tests['test_price'], widget.tests['test_price']);
                                  if (message.contains('Success')) {
                                    widget.onAddToCart();
                                    setState(() {
                                      // isClicked = false;
                                    });
                                  }
                                },
                                child: isClicked
                                    ? addToCartButton(
                                        "Adding to cart",
                                        Colors.white,
                                        const Color(0xffB0B0B0),
                                        FontWeight.w700,
                                        3.sp,
                                        false,
                                        false,
                                      )
                                    : addToCartButton(
                                        "Add to cart",
                                        const Color(0xff10217D),
                                        const Color(0xFF10217D),
                                        FontWeight.w700,
                                        3.sp,
                                        true,
                                        true,
                                      ),
                              ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class CustomContainer extends StatefulWidget {
  final Map<String, dynamic> tests;
  final String userId;
  final Function() onAddToCart;

  const CustomContainer({
    Key? key,
    required this.tests,
    required this.userId,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  CustomContainerState createState() => CustomContainerState();
}

class CustomContainerState extends State<CustomContainer> {
  bool isAddedToCart = false;
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: AuthService().checkIfAddedToCart(widget.userId, widget.tests['test_id']),
        builder: (BuildContext context, AsyncSnapshot<bool> cartSnapshot) {
          if (cartSnapshot.connectionState == ConnectionState.waiting) {}

          bool isAddedToCart = cartSnapshot.data ?? false;

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                1.h,
              ),
              border: Border.all(
                color: Colors.grey.shade400,
              ),
            ),
            // color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff10217d),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(1.h),
                      topRight: Radius.circular(1.h),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 1.h,
                    ),
                    child: Text(
                      widget.tests['description'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 5.sp,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 2.w,
                    top: 2.h,
                    bottom: 1.h,
                    right: 2.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Include ${widget.tests['test_count']} tests",
                        style: TextStyle(
                          color: const Color(0xFF475569),
                          fontSize: 3.sp,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF16C2D5),
                          borderRadius: BorderRadius.circular(0.5.h),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0.5.w,
                            vertical: 0.3.h,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.verified_user_sharp,
                                color: Colors.white,
                                size: 1.5.h,
                              ),
                              SizedBox(width: 0.2.w),
                              Text(
                                "Safe",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 2.sp,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "• ${widget.tests['sub_tests'][0]}",
                        style: TextStyle(
                          color: const Color(0xff0F172A),
                          fontSize: 2.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "• ${widget.tests['sub_tests'][1]}",
                        style: TextStyle(
                          color: const Color(0xff0F172A),
                          fontSize: 2.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "• ${widget.tests['sub_tests'][2]}",
                        style: TextStyle(
                          color: const Color(0xff0F172A),
                          fontSize: 2.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 1.h,
                      ),
                      child: Text(
                        "Get reports in ${widget.tests['duration']}",
                        style: TextStyle(
                          color: const Color(0xFF475569),
                          fontSize: 2.sp,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "₹ ${widget.tests['offer_price']}",
                            style: TextStyle(
                              color: const Color(0xFF10217D),
                              fontWeight: FontWeight.w700,
                              fontSize: 4.sp,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            widget.tests['original_price'].toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: const Color(0xFF5B5B5B),
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 3.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    if (isAddedToCart)
                      addToCartButton(
                        "Added to cart",
                        Colors.white,
                        const Color(0xFF16C2D5),
                        FontWeight.w700,
                        3.sp,
                        false,
                        false,
                      ),
                    if (!isAddedToCart)
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isClicked = true;
                          });
                          await Future.delayed(
                            const Duration(microseconds: 100),
                          );
                          final message =
                              await AuthService().addToCart(widget.userId, widget.tests['test_id'], 1, widget.tests['description'], widget.tests['offer_price'], widget.tests['original_price']);
                          if (message.contains('Success')) {
                            widget.onAddToCart();
                            setState(() {
                              // isClicked = false;
                            });
                          }
                        },
                        child: isClicked
                            ? addToCartButton(
                                "Adding to cart",
                                Colors.white,
                                const Color(0xffB0B0B0),
                                FontWeight.w700,
                                3.sp,
                                false,
                                false,
                              )
                            : addToCartButton(
                                "Add to cart",
                                Colors.white,
                                const Color(0xFF10217D),
                                FontWeight.w700,
                                3.sp,
                                false,
                                false,
                              ),
                      ),
                    addToCartButton(
                      "View Details",
                      const Color(0xFF10217D),
                      const Color(0xFF10217D),
                      FontWeight.w500,
                      3.sp,
                      true,
                      false,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class CartCountWidget extends StatefulWidget {
  final int? count;

  const CartCountWidget({
    Key? key,
    required this.count,
  }) : super(key: key);

  @override
  CartCountWidgetState createState() => CartCountWidgetState();
}

class CartCountWidgetState extends State<CartCountWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.count == null || widget.count == 0
        ? Container()
        : Container(
            decoration: const BoxDecoration(
              color: Color(0xff16C2D5),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(0.8.h),
              child: Text(
                widget.count.toString(),
                style: TextStyle(
                  color: const Color(0xff10217D),
                  fontWeight: FontWeight.w700,
                  fontSize: 3.sp,
                ),
              ),
            ),
          );
  }
}

Widget addToCartButton(
  String text,
  Color color,
  Color bgColor,
  FontWeight weight,
  double size,
  bool isInverted,
  bool customPadding,
) {
  return Padding(
    padding: EdgeInsets.only(
      left: 1.5.w,
      top: 0.2.h,
      right: 1.5.w,
      bottom: 0.5.h,
    ),
    child: Container(
      alignment: Alignment.center,
      decoration: isInverted
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(0.5.h),
              border: Border.all(
                color: bgColor,
              ),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(0.5.h),
              color: bgColor,
            ),
      child: Padding(
        padding: customPadding
            ? EdgeInsets.symmetric(
                horizontal: 2.w,
                vertical: 1.h,
              )
            : EdgeInsets.symmetric(
                vertical: 1.h,
                horizontal: 2.w,
              ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: size,
          ),
        ),
      ),
    ),
  );
}

Widget customHeader(
  String text,
  Color color,
  bool param1,
  double size1,
  double size2,
  double size3,
  double vertical,
  double horizontal,
  double left,
  FontWeight fontWeight,
) {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: vertical,
      horizontal: horizontal,
    ),
    child: Text(
      text,
      style: TextStyle(
        color: const Color(0xFF10217D),
        fontSize: size1,
        fontWeight: fontWeight,
      ),
    ),
  );
}
