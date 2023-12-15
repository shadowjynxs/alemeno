// ignore_for_file: must_be_immutable

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:alemeno/screens/successpage/desktop/desktop_success_page.dart';

class CartPage extends StatefulWidget {
  final String userId;
  const CartPage({
    Key? key, // Change super.key to Key? key
    required this.userId,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Stream<QuerySnapshot> getCart(String userId) {
    return FirebaseFirestore.instance.collection('user_carts').doc(userId).collection('cart_items').snapshots();
  }

  Stream<QuerySnapshot<Object?>>? cartData;

  bool isDatePickMode = false;
  DateTime? _selectedDay;

  int? selectedIndex;
  String buttonText = "Next";

  String? selectedTime;
  String? selectedDate;
  String? scheduledDate;

  String? dateTime;

  bool isAgreeButton = false;

  int totalAmount = 0;
  int totalDiscount = 0;
  int payableAmount = 0;

  String dateText = "Select Date";

  List<String> purchasedTests = [];
  List<String> listTestId = [];
  List<String> listTestName = [];

  void updateDatePickMode(bool newValue, String sDate, String confirmScheduledDate) {
    setState(() {
      isDatePickMode = newValue;
      dateText = sDate;
      scheduledDate = confirmScheduledDate;
    });
  }

  void updateTimeSelection(int? timeIndex) {
    setState(() {
      selectedIndex = timeIndex;
    });
  }

  void updateDateSelection(DateTime date) {
    setState(() {
      _selectedDay = date;
    });
  }

  void updateCartTime(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  @override
  void initState() {
    super.initState();
    // cartData = getCart(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 10.w,
            right: 10.w,
            top: 3.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My cart',
                style: TextStyle(
                  color: const Color(0xff303030),
                  fontWeight: FontWeight.w700,
                  fontSize: 8.sp,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: getCart(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {}

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 18.sp,
                        ),
                      ),
                    );
                  }

                  totalAmount = 0;
                  totalDiscount = 0;
                  payableAmount = 0;

                  purchasedTests = [];
                  listTestId = [];
                  listTestName = [];

                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    var cartItem = snapshot.data!.docs[i];
                    var data = cartItem.data() as Map<String, dynamic>?;

                    totalAmount += data?['original_price'] as int;
                    payableAmount += data?['offer_price'] as int;

                    purchasedTests.add(data?['test_name']);
                    listTestId.add(data?['test_id']);
                    listTestName.add(data?['test_name']);
                  }

                  // Display cart contents
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.h),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10217D),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(1.h),
                                    topRight: Radius.circular(1.h),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 1.h,
                                  ),
                                  child: Text(
                                    "Pathology tests",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 4.sp,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xffDBDDE0), width: 0.1.w),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    var cartItem = snapshot.data!.docs[index];
                                    var data = cartItem.data() as Map<String, dynamic>?;

                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 2.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 1.h),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  data?['test_name'],
                                                  style: TextStyle(
                                                    color: const Color(0xff0F172A),
                                                    fontSize: 4.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "₹ ${data?['offer_price']}/-",
                                                      style: TextStyle(
                                                        color: const Color(0xff1BA9B5),
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 4.sp,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${data?['original_price']}",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: const Color(
                                                          0xFF5B5B5B,
                                                        ),
                                                        fontWeight: FontWeight.w400,
                                                        decoration: TextDecoration.lineThrough,
                                                        fontSize: 3.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 4.h,
                                            ),
                                            child: Row(
                                              children: [
                                                customButton(
                                                  const Icon(
                                                    Icons.delete_forever,
                                                  ),
                                                  "Remove",
                                                  data?['test_id'],
                                                  widget.userId,
                                                  true,
                                                ),
                                                SizedBox(width: 1.5.w),
                                                customButton(
                                                  const Icon(
                                                    Icons.file_upload_outlined,
                                                  ),
                                                  "Upload prescription (optional)",
                                                  data?['test_id'],
                                                  widget.userId,
                                                  false,
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (index < snapshot.data!.docs.length - 1)
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color(0xffC9C9C9),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 1.5.h, bottom: 1.5.h),
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
                                        "Add more tests",
                                        style: TextStyle(
                                          color: const Color(0xFF10217D),
                                          fontSize: 3.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 0.5.w),
                                      child: Icon(
                                        Icons.arrow_forward_outlined,
                                        color: const Color(0xFF10217D),
                                        size: 2.h,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.h),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isDatePickMode = !isDatePickMode;
                                        selectedIndex = null;
                                        _selectedDay = null;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 3.h),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xffDBDDE0),
                                          ),
                                          borderRadius: BorderRadius.circular(1.h),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 1.5.w,
                                            vertical: 2.5.h,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_month_outlined,
                                                color: Colors.black,
                                                size: 5.h,
                                              ),
                                              SizedBox(width: 1.w),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey.shade300,
                                                    ),
                                                    borderRadius: BorderRadius.circular(1.h),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 1.w,
                                                      vertical: 1.h,
                                                    ),
                                                    child: selectedDate != null
                                                        ? Text(
                                                            selectedDate!,
                                                            style: TextStyle(
                                                              color: const Color(0xff10217D),
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 4.5.sp,
                                                            ),
                                                          )
                                                        : Text(
                                                            dateText,
                                                            style: TextStyle(
                                                              color: const Color(0xff404D97),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 3.sp,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffDBDDE0),
                                      ),
                                      borderRadius: BorderRadius.circular(1.h),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "M.R.P Total",
                                                    style: TextStyle(
                                                      color: const Color(0xff475569),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 3.sp,
                                                    ),
                                                  ),
                                                  Text(
                                                    "$totalAmount",
                                                    style: TextStyle(
                                                      color: const Color(0xff475569),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 3.sp,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 1.h),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Discount",
                                                    style: TextStyle(
                                                      color: const Color(0xff475569),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 3.sp,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${totalAmount - payableAmount}",
                                                    style: TextStyle(
                                                      color: const Color(0xff475569),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 3.sp,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 1.h),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Amount to be paid",
                                                    style: TextStyle(
                                                      color: const Color(0xFF10217D),
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 4.sp,
                                                    ),
                                                  ),
                                                  Text(
                                                    "₹ $payableAmount/-",
                                                    style: TextStyle(
                                                      color: const Color(0xFF10217D),
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 4.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 3.h),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(22, 194, 213, 0.44),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(1.h),
                                              bottomRight: Radius.circular(1.h),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Total Savings",
                                                  style: TextStyle(
                                                    color: const Color(0xff0F172A),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 3.sp,
                                                  ),
                                                ),
                                                SizedBox(width: 1.5.w),
                                                Text(
                                                  "₹ ${totalAmount - payableAmount}/-",
                                                  style: TextStyle(
                                                    color: const Color(0xFF10217D),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 4.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isAgreeButton = !isAgreeButton;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 3.h),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(255, 172, 181, 201),
                                          ),
                                          borderRadius: BorderRadius.circular(1.h),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 1.w,
                                            vertical: 2.5.h,
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              isAgreeButton
                                                  ? Icon(
                                                      Icons.check_circle,
                                                      color: const Color(0xff10217D),
                                                      size: 2.5.h,
                                                    )
                                                  : Icon(
                                                      Icons.circle_outlined,
                                                      color: const Color(0xffEAECF0),
                                                      size: 2.5.h,
                                                    ),
                                              SizedBox(width: 0.5.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Hard copy of reports",
                                                      style: TextStyle(
                                                        color: const Color(0xff344054),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 3.sp,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Reports will be delivered within 3-4 working days. Hard copy charges are non-refundable once the reports have been dispatched.",
                                                      style: TextStyle(
                                                        color: const Color(0xff667085),
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 3.sp,
                                                      ),
                                                      maxLines: 5,
                                                    ),
                                                    SizedBox(height: 1.h),
                                                    Text(
                                                      "₹150 per person",
                                                      style: TextStyle(
                                                        color: const Color(0xff667085),
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 3.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  isAgreeButton && dateText != "Select Date"
                                      ? GestureDetector(
                                          onTap: () {
                                            AwesomeNotifications().createNotification(
                                              content: NotificationContent(
                                                id: 1,
                                                fullScreenIntent: true,
                                                channelKey: "confirmed_order",
                                                title: "Order Placed Successfully",
                                                // body: "Thanks for purchasing}",
                                                body: "Thanks for purchasing ${purchasedTests.join(',')}}",
                                              ),
                                            );
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) => SuccessPage(
                                                  scheduleTime: scheduledDate!,
                                                  testId: listTestId,
                                                  testName: listTestName,
                                                  userId: widget.userId,
                                                ),
                                              ),
                                              (route) => route.isFirst,
                                            );
                                          },
                                          child: customConfirmButton(
                                            "Schedule",
                                            const Color(0xff10217D),
                                            Colors.white,
                                          ),
                                        )
                                      : customConfirmButton(
                                          "Schedule",
                                          const Color(0xffB0B0B0),
                                          Colors.white,
                                        ),
                                ],
                              ),
                              if (isDatePickMode)
                                Padding(
                                  padding: EdgeInsets.only(top: 7.h),
                                  child: CustomCalendar(
                                    pselectedDay: _selectedDay,
                                    selectedIndex: selectedIndex,
                                    selectedTime: selectedTime,
                                    selectedDate: selectedDate,
                                    scheduledDate: scheduledDate,
                                    isDatePickMode: isDatePickMode,
                                    updateDatePickMode: updateDatePickMode,
                                    updateTimeSelection: updateTimeSelection,
                                    updateDateSelection: updateDateSelection,
                                    updateCartTime: updateCartTime,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget timeButtom(
  int index,
  Color textColor,
  Color bgColor,
  bool isBg,
) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xff10217D), width: 0.1.w),
      borderRadius: BorderRadius.circular(1.h),
      color: isBg ? bgColor : Colors.white,
    ),
    child: Center(
      child: Text(
        index + 8 > 12
            ? "0${index - 4}:00 PM"
            : index == 0 || index == 1
                ? "0${8 + index}:00 AM"
                : "${8 + index}:00 AM",
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w400,
          fontSize: 2.sp,
        ),
      ),
    ),
  );
}

Widget customConfirmButton(String text, Color bgColor, Color textColor) {
  return Container(
    width: double.infinity,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(1.h),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 3.sp,
        ),
      ),
    ),
  );
}

Widget customButton(
  Icon icon,
  String text,
  String itemId,
  String userId,
  bool isRemove,
) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(Colors.white),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h), // Adjust border radius as needed
          side: const BorderSide(
            color: Color(0xff10217D),
          ), // Change border color here
        ),
      ),
    ),
    onPressed: () async {
      if (isRemove) {
        await FirebaseFirestore.instance.collection('user_carts').doc(userId).collection('cart_items').doc(itemId).delete();
      }
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: 1.w),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.2.h),
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xff10217D),
              fontWeight: FontWeight.w500,
              fontSize: 3.5.sp,
            ),
          ),
        ),
      ],
    ),
  );
}

class CustomCalendar extends StatefulWidget {
  DateTime? pselectedDay;
  int? selectedIndex;
  String? selectedTime;
  String? selectedDate;
  String? scheduledDate;
  bool isDatePickMode;
  final Function(bool, String sDate, String confirmScheduledDate) updateDatePickMode;
  final Function(int?) updateTimeSelection;
  final Function(DateTime) updateDateSelection;
  final Function(String) updateCartTime;

  CustomCalendar({
    Key? key,
    required this.pselectedDay,
    required this.selectedIndex,
    required this.selectedTime,
    required this.selectedDate,
    required this.scheduledDate,
    required this.isDatePickMode,
    required this.updateDatePickMode,
    required this.updateTimeSelection,
    required this.updateDateSelection,
    required this.updateCartTime,
  }) : super(key: key);

  @override
  State<CustomCalendar> createState() => CustomCalendarState();
}

class CustomCalendarState extends State<CustomCalendar> {
  int? cartSelectedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 0.w, top: 1.h, right: 3.8.w, bottom: 2.h),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xffE7E7E7),
          ),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 3.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff303030),
                ),
              ),
              SizedBox(height: 0.5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        offset: Offset(0, 4),
                        blurRadius: 24,
                        spreadRadius: 0,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TableCalendar(
                    focusedDay: DateTime.now(),
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2030),
                    calendarFormat: CalendarFormat.month,
                    selectedDayPredicate: (day) {
                      return isSameDay(widget.pselectedDay, day);
                    },

                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        widget.updateDateSelection(selectedDay);
                      });
                    },

                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: const Icon(
                        Icons.chevron_left,
                        color: Color(0xff0659FD),
                      ),
                      rightChevronIcon: const Icon(
                        Icons.chevron_right,
                        color: Color(0xff0659FD),
                      ),
                      titleTextStyle: TextStyle(
                        color: const Color(0xff303030),
                        fontSize: 3.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      dowTextFormatter: (date, locale) {
                        if (date.weekday == DateTime.sunday) {
                          return 'Su';
                        } else if (date.weekday == DateTime.monday) {
                          return 'Mo';
                        } else if (date.weekday == DateTime.tuesday) {
                          return 'Tu';
                        } else if (date.weekday == DateTime.wednesday) {
                          return 'We';
                        } else if (date.weekday == DateTime.thursday) {
                          return 'Th';
                        } else if (date.weekday == DateTime.friday) {
                          return 'Fr';
                        } else {
                          return 'Sa';
                        }
                      },
                    ),

                    // headerVisible
                    calendarStyle: const CalendarStyle(
                      isTodayHighlighted: false,
                      outsideDaysVisible: false,
                      defaultTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      weekendTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff10217D),
                      ),
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Select Time',
                style: TextStyle(
                  fontSize: 3.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff303030),
                ),
              ),
              SizedBox(height: 1.h),
              GridView.builder(
                shrinkWrap: true,
                itemCount: 12,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1.w,
                  mainAxisSpacing: 1.h,
                  childAspectRatio: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.selectedIndex == index) {
                          widget.updateTimeSelection(null);
                          cartSelectedIndex = null;
                        } else {
                          cartSelectedIndex = index;
                          widget.updateTimeSelection(index);
                          // selectedTime = index + 8 > 12 ? : "(${8 + index} AM)";

                          widget.selectedTime = index + 8 > 12 ? "${index - 4} PM" : "${8 + index} AM";
                          widget.updateCartTime(widget.selectedTime!);
                        }
                      });
                    },
                    child: widget.selectedIndex == index
                        ? timeButtom(
                            index,
                            Colors.white,
                            const Color(0xff10217D),
                            true,
                          )
                        : timeButtom(
                            index,
                            const Color(0xff303030),
                            const Color(0xff10217D),
                            false,
                          ),
                  );
                },
              ),
              SizedBox(height: 1.3.h),
              GestureDetector(
                onTap: () {
                  if (cartSelectedIndex != null && widget.pselectedDay != null) {
                    widget.selectedDate = "${widget.pselectedDay.toString().split(' ')[0].split('-').reversed.join('/')} (${widget.selectedTime})";

                    String getMonthName(int monthNumber) {
                      return DateFormat('MMMM').format(DateTime(DateTime.now().year, monthNumber));
                    }

                    String monthNo = widget.selectedDate.toString().split(' ')[0].split('/')[1];

                    final month = getMonthName(int.parse(monthNo));

                    List<String> date = widget.selectedDate.toString().split(' ')[0].split('/');
                    date[1] = month.substring(0, 3);
                    widget.scheduledDate = "${date.join(' ')} | ${widget.selectedTime}";

                    widget.updateDatePickMode(
                      false,
                      widget.selectedDate!,
                      widget.scheduledDate!,
                    );
                  }
                },
                child: customConfirmButton(
                  "Confirm",
                  widget.pselectedDay != null && cartSelectedIndex != null
                      ? const Color(0xff10217D)
                      : const Color(
                          0xffB0B0B0,
                        ),
                  Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
