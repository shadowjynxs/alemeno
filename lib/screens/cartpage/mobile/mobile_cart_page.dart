import 'package:alemeno/screens/successpage/mobile/mobile_success_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

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

  bool isDatePickMode = false;
  DateTime? _selectedDay;

  int? selectedIndex;
  String buttonText = "Next";

  String? selectedTime;
  String? selectedDate;
  String? scheduledDate;

  String? dateTime;

  bool isAgreeButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: !isDatePickMode
            ? GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xff444444),
                  size: 3.h,
                ),
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    isDatePickMode = false;
                  });
                },
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xff444444),
                  size: 3.h,
                ),
              ),
        title: Text(
          isDatePickMode ? 'Book Appointment' : 'My cart',
          style: TextStyle(
            color: const Color(0xff303030),
            fontWeight: FontWeight.w500,
            fontSize: 8.sp,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: const Icon(
              Icons.more_vert,
              color: Color(0xff0D99FF),
            ),
          )
        ],
      ),
      body: isDatePickMode
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 1.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0.5.h),
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff303030),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                            return isSameDay(_selectedDay, day);
                          },

                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              buttonText = "Confirm";
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
                              fontSize: 12.sp,
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
                    SizedBox(height: 2.5.h),
                    Text(
                      'Select Time',
                      style: TextStyle(
                        fontSize: 12.sp,
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
                        crossAxisSpacing: 6.w,
                        mainAxisSpacing: 1.5.h,
                        childAspectRatio: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedIndex == index) {
                                selectedIndex = null;
                              } else {
                                selectedIndex = index;
                                // selectedTime = index + 8 > 12 ? : "(${8 + index} AM)";

                                selectedTime = index + 8 > 12 ? "${index - 4} PM" : "${8 + index} AM";
                              }
                            });
                          },
                          child: selectedIndex == index
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
                    SizedBox(height: 4.h),
                    GestureDetector(
                      onTap: () {
                        selectedDate = "${_selectedDay.toString().split(' ')[0].split('-').reversed.join('/')} ($selectedTime)";

                        String getMonthName(int monthNumber) {
                          return DateFormat('MMMM').format(DateTime(DateTime.now().year, monthNumber));
                        }

                        String monthNo = selectedDate.toString().split(' ')[0].split('/')[1];

                        final month = getMonthName(int.parse(monthNo));

                        List<String> date = selectedDate.toString().split(' ')[0].split('/');
                        date[1] = month.substring(0, 3);
                        scheduledDate = "${date.join(' ')} | $selectedTime";

                        setState(() {
                          isDatePickMode = false;
                        });
                      },
                      child: customConfirmButton(
                        buttonText,
                        _selectedDay != null && selectedIndex != null ? const Color(0xff10217D) : const Color(0xffB0B0B0),
                        Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
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

                // Display cart contents
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var cartItem = snapshot.data!.docs[index];
                    var data = cartItem.data() as Map<String, dynamic>?;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order review",
                            style: TextStyle(
                              color: const Color(0xff10217D),
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffDBDDE0),
                                ),
                                borderRadius: BorderRadius.circular(1.h),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 1.5.h),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10217D),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(1.h),
                                          topRight: Radius.circular(1.h),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 1.w,
                                          vertical: 1.h,
                                        ),
                                        child: Text(
                                          "Pathology tests",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 1.h,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data?['test_name'],
                                          style: TextStyle(
                                            color: const Color(0xff0F172A),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "₹ ${data?['offer_price']}/-",
                                              style: TextStyle(color: const Color(0xff1BA9B5), fontWeight: FontWeight.w700, fontSize: 12.sp),
                                            ),
                                            Text(
                                              "${data?['original_price']}",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: const Color(0xFF5B5B5B),
                                                fontWeight: FontWeight.w400,
                                                decoration: TextDecoration.lineThrough,
                                                fontSize: 8.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
                                    child: customButton(
                                        const Icon(
                                          Icons.delete_forever,
                                        ),
                                        "Remove"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 10.w,
                                      right: 10.w,
                                      bottom: 1.5.h,
                                    ),
                                    child: customButton(
                                        const Icon(
                                          Icons.file_upload_outlined,
                                        ),
                                        "Upload prescription (optional)"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isDatePickMode = true;
                              });
                            },
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
                                  horizontal: 5.w,
                                  vertical: 2.h,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      color: Colors.black,
                                      size: 4.h,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(2.w),
                                          child: selectedDate != null
                                              ? Text(
                                                  selectedDate!,
                                                  style: TextStyle(
                                                    color: const Color(0xff10217D),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 8.sp,
                                                  ),
                                                )
                                              : const Text(
                                                  "Select date",
                                                ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xffDBDDE0),
                              ),
                              borderRadius: BorderRadius.circular(1.h),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 1.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(height: 1.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "M.R.P Total",
                                        style: TextStyle(
                                          color: const Color(0xff475569),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 8.sp,
                                        ),
                                      ),
                                      Text(
                                        "${data?['original_price']}",
                                        style: TextStyle(
                                          color: const Color(0xff475569),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 8.sp,
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
                                          fontSize: 8.sp,
                                        ),
                                      ),
                                      Text(
                                        "${data?['original_price'] - data?['offer_price']}",
                                        style: TextStyle(
                                          color: const Color(0xff475569),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 8.sp,
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
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      Text(
                                        "₹ ${data?['offer_price']}/-",
                                        style: TextStyle(
                                          color: const Color(0xFF10217D),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 3.h),
                                  Row(
                                    children: [
                                      Text(
                                        "Total Savings",
                                        style: TextStyle(
                                          color: const Color(0xff0F172A),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 8.sp,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "₹ ${data?['original_price'] - data?['offer_price']}/-",
                                        style: TextStyle(
                                          color: const Color(0xFF10217D),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isAgreeButton = !isAgreeButton;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(255, 172, 181, 201),
                                ),
                                borderRadius: BorderRadius.circular(1.h),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 1.h,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isAgreeButton
                                        ? Icon(
                                            Icons.check_circle,
                                            color: const Color(0xff10217D),
                                            size: 2.h,
                                          )
                                        : Icon(
                                            Icons.circle_outlined,
                                            color: const Color(0xffEAECF0),
                                            size: 2.h,
                                          ),
                                    SizedBox(width: 1.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hard copy of reports",
                                            style: TextStyle(
                                              color: const Color(0xff344054),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 8.sp,
                                            ),
                                          ),
                                          Text(
                                            "Reports will be delivered within 3-4 working days. Hard copy charges are non-refundable once the reports have been dispatched.",
                                            style: TextStyle(
                                              color: const Color(0xff667085),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 8.sp,
                                            ),
                                            maxLines: 5,
                                          ),
                                          SizedBox(height: 1.h),
                                          Text(
                                            "₹150 per person",
                                            style: TextStyle(
                                              color: const Color(0xff667085),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 8.sp,
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
                          SizedBox(height: 3.h),
                          isAgreeButton
                              ? GestureDetector(
                                  onTap: () {
                                    AwesomeNotifications().createNotification(
                                      content: NotificationContent(
                                        id: 1,
                                        fullScreenIntent: true,
                                        channelKey: "confirmed_order",
                                        title: "Order Placed Successfully",
                                        body: "Thanks for purchasing ${data?['test_name']}",
                                      ),
                                    );
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => SuccessPage(
                                          scheduleTime: scheduledDate!,
                                          testId: data?['test_id'],
                                          testName: data?['test_name'],
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
                    );
                  },
                );
              },
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
      border: Border.all(color: const Color(0xff10217D), width: 0.6.w),
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
          fontSize: 10.sp,
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
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
        ),
      ),
    ),
  );
}

Widget customButton(Icon icon, String text) {
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
    onPressed: () {},
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: 2.w),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xff10217D),
            fontWeight: FontWeight.w500,
            fontSize: 10.sp,
          ),
        ),
      ],
    ),
  );
}
