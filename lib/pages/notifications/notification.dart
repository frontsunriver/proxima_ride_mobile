import 'package:flutter/material.dart';
import 'package:proximaride_app/consts/constFileLink.dart';
import 'package:proximaride_app/pages/my_profile/my_profile.dart';
import 'package:proximaride_app/pages/notifications/widgets/filter_notification_side_widget.dart';
import 'package:proximaride_app/pages/notifications/widgets/userCard.dart';
import 'package:proximaride_app/pages/widgets/overlay_widget.dart';
import 'package:proximaride_app/pages/widgets/progress_circular_widget.dart';
import 'package:proximaride_app/pages/widgets/second_appbar_widget.dart';
import 'package:proximaride_app/pages/widgets/textWidget.dart';
import 'package:side_sheet/side_sheet.dart';
import 'NotificationController.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Obx(() => secondAppBarWidget(
              title:
                  "${controller.labelTextDetail['notification_page_main_heading'] ?? 'Notifications'}",
              context: context)),
          leading: const BackButton(color: Colors.white),
        ),
        body: Obx(() {
          if (controller.isLoading.value == true) {
            return Center(child: progressCircularWidget(context));
          } else {
            return controller.notificationsList.isEmpty &&
                    controller.filter.value == false
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(noNotifications),
                      20.heightBox,
                      txt18Size(
                          title:
                              "${controller.labelTextDetail['notification_page_no_messages_label'] ?? "You have no notifications yet"}",
                          context: context),
                    ],
                  ))
                : Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            10.heightBox,
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 15.0),
                            //   child: Align(
                            //     alignment: Alignment.topRight,
                            //     child: GestureDetector(
                            //       onTap: () {
                            //         SideSheet.right(
                            //           body: filterNotificationSideWidget(
                            //             context: context,
                            //             controller: controller,
                            //             screenWidth: context.screenWidth,
                            //             screenHeight: context.screenHeight,
                            //           ),
                            //           context: context,
                            //           width: context.screenWidth - 50,
                            //         );
                            //       },
                            //       child: Container(
                            //         height: 50,
                            //         padding: const EdgeInsets.symmetric(
                            //             horizontal: 16.0),
                            //         decoration: BoxDecoration(
                            //           color: btnPrimaryColor,
                            //           borderRadius: BorderRadius.circular(5.0),
                            //           boxShadow: [
                            //             BoxShadow(
                            //               color:
                            //                   btnPrimaryColor.withOpacity(0.2),
                            //               blurRadius: 5,
                            //               offset: const Offset(0, 2),
                            //             ),
                            //           ],
                            //         ),
                            //         child: Row(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.center,
                            //           children: [
                            //             Image.asset(
                            //               filterImage,
                            //               height: getValueForScreenType<double>(
                            //                 context: context,
                            //                 mobile: 20.0,
                            //                 tablet: 22.0,
                            //               ),
                            //               width: getValueForScreenType<double>(
                            //                 context: context,
                            //                 mobile: 20.0,
                            //                 tablet: 22.0,
                            //               ),
                            //               color: Colors.white,
                            //             ),
                            //             const SizedBox(width: 8),
                            //             Expanded(
                            //               child: Text(
                            //                 controller.labelTextDetail[
                            //                         'notification_filter_btn_label'] ??
                            //                     "Search filters",
                            //                 style: TextStyle(
                            //                   fontSize:
                            //                       getValueForScreenType<double>(
                            //                     context: context,
                            //                     mobile: 18.0,
                            //                     tablet: 20.0,
                            //                   ),
                            //                   fontWeight: FontWeight.w600,
                            //                   color: Colors.white,
                            //                 ),
                            //                 softWrap: true,
                            //                 overflow: TextOverflow.visible,
                            //                 maxLines: 2,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            GestureDetector(
                              onTap: () {
                                SideSheet.right(
                                  body: filterNotificationSideWidget(
                                    context: context,
                                    controller: controller,
                                    screenWidth: context.screenWidth,
                                    screenHeight: context.screenHeight,
                                  ),
                                  context: context,
                                  width: context.screenWidth - 50,
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: btnPrimaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color(0xFFB0EACD)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Top row with filter icon
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'This is where all your notifications will appear.',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.tune,
                                            color: Colors.white),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Notification types
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Icon(Icons.directions_car,
                                            size: 20, color: Colors.white),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'If the message is about a ride, tapping it will take you straight to that ride’s details.',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Icon(Icons.chat_bubble_outline,
                                            size: 20, color: Colors.white),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'If it’s from another member, you’ll be directed to your Inbox.',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Icon(
                                            Icons.notifications_active_outlined,
                                            size: 20,
                                            color: Colors.white),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'If it’s a general update from ProximaRide, it will open right here for you to read.',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            10.heightBox,
                            Container(
                              padding: EdgeInsets.only(
                                left: getValueForScreenType<double>(
                                  context: context,
                                  mobile: 10.0,
                                  tablet: 10.0,
                                ),
                                right: getValueForScreenType<double>(
                                  context: context,
                                  mobile: 10.0,
                                  tablet: 10.0,
                                ),
                              ),
                              child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.notificationsList.length,
                                  itemBuilder: (context, index) {
                                    return Dismissible(
                                        direction: DismissDirection.startToEnd,
                                        key: UniqueKey(),
                                        confirmDismiss:
                                            (DismissDirection direction) async {
                                          bool dataReturn = false;
                                          if (direction ==
                                              DismissDirection.startToEnd) {
                                            controller.readNotification(
                                                controller.notificationsList[
                                                    index]['id']);
                                            dataReturn = true;
                                          }
                                          return dataReturn;
                                        },
                                        child: userCard(
                                          context: context,
                                          notificationType: controller
                                                  .notificationsList[index]
                                              ['notification_type'],
                                          bgColor: index % 2 == 0
                                              ? Colors.white
                                              : Colors.grey.shade300,
                                          image: (controller.notificationsList[index]
                                                              ['from']
                                                              ['first_name']
                                                          ?.toString()
                                                          .toLowerCase()
                                                          .trim() ==
                                                      controller
                                                          .serviceController
                                                          .loginUserDetail[
                                                              'first_name']
                                                          ?.toString()
                                                          .toLowerCase()
                                                          .trim() &&
                                                  controller.notificationsList[index]
                                                              ['from']
                                                              ['last_name']
                                                          ?.toString()
                                                          .toLowerCase()
                                                          .trim() ==
                                                      controller.serviceController.loginUserDetail['last_name']
                                                          ?.toString()
                                                          .toLowerCase()
                                                          .trim())
                                              ? "assets/icons/logo.png"
                                              : controller.notificationsList[index]
                                                  ['from']['profile_image'],
                                          //  controller
                                          //         .notificationsList[index]
                                          //     ['from']['profile_image'],
                                          // name:
                                          //     "${controller.notificationsList[index]['from']['first_name']} ${controller.notificationsList[index]['from']['last_name']}",

                                          name: (controller
                                                          .notificationsList[index]
                                                              ['from']
                                                              ['first_name']
                                                          ?.toString()
                                                          .toLowerCase()
                                                          .trim() ==
                                                      controller
                                                          .serviceController
                                                          .loginUserDetail[
                                                              'first_name']
                                                          ?.toString()
                                                          .toLowerCase()
                                                          .trim() &&
                                                  controller
                                                          .notificationsList[index]
                                                              ['from']
                                                              ['last_name']
                                                          ?.toString()
                                                          .toLowerCase()
                                                          .trim() ==
                                                      controller
                                                          .serviceController
                                                          .loginUserDetail[
                                                              'last_name']
                                                          ?.toString()
                                                          .toLowerCase()
                                                          .trim())
                                              ? "ProximaRide"
                                              : "${controller.notificationsList[index]['from']['first_name']}",
                                          controller: controller,
                                          notification:
                                              "${controller.notificationsList[index]['message']}",
                                          date: controller
                                                  .notificationsList[index]
                                              ['added_on'],
                                          time: controller
                                                  .notificationsList[index]
                                              ['added_on'],
                                          // userType:
                                          //     controller.notificationsList[
                                          //                 index]['type'] ==
                                          //             "1"
                                          //         ? 'Passenger'
                                          //         : 'Driver',
                                          // onTap: () {
                                          //   if (controller.notificationsList[
                                          //               index]
                                          //           ['notification_type'] ==
                                          //       "review") {
                                          //     if (controller
                                          //                 .notificationsList[
                                          //             index]['type'] ==
                                          //         "1") {
                                          //       Get.toNamed(
                                          //           '/notification_add_review/passenger/${controller.notificationsList[index]['ride_id']}/${controller.notificationsList[index]['posted_to']}/${controller.notificationsList[index]['id']}/${controller.notificationsList[index]['ride_detail_id']}');
                                          //     } else {
                                          //       Get.toNamed(
                                          //           '/notification_add_review/driver/${controller.notificationsList[index]['ride_id']}/0/${controller.notificationsList[index]['id']}/${controller.notificationsList[index]['ride_detail_id']}');
                                          //     }
                                          //   } else if (controller
                                          //                   .notificationsList[
                                          //               index]
                                          //           ['notification_type'] ==
                                          //       "chat") {
                                          //     var rideId = 0;
                                          //     if (controller
                                          //                 .notificationsList[
                                          //             index]['ride_id'] !=
                                          //         null) {
                                          //       rideId = int.parse(controller
                                          //           .notificationsList[index]
                                          //               ['ride_id']
                                          //           .toString());
                                          //     }
                                          //     Get.toNamed(
                                          //         '/messaging_page/${controller.notificationsList[index]['posted_by']}/$rideId/new');
                                          //   } else if (controller
                                          //                   .notificationsList[
                                          //               index]
                                          //           ['notification_type'] ==
                                          //       "phone") {
                                          //     Get.toNamed('/my_phone_number');
                                          //   } else if (controller
                                          //                   .notificationsList[
                                          //               index]
                                          //           ['notification_type'] ==
                                          //       "christmas") {
                                          //   } else if (controller
                                          //                   .notificationsList[
                                          //               index]
                                          //           ['notification_type'] ==
                                          //       "birthday") {
                                          //   } else if (controller
                                          //                   .notificationsList[
                                          //               index]
                                          //           ['notification_type'] ==
                                          //       "password") {
                                          //   } else if (controller
                                          //                   .notificationsList[
                                          //               index]
                                          //           ['notification_type'] ==
                                          //       "welcome") {
                                          //   } else if (controller
                                          //                   .notificationsList[
                                          //               index]
                                          //           ['notification_type'] ==
                                          //       "student_card") {
                                          //     Get.toNamed('/student_card');
                                          //   }
                                          //    else {
                                          //     var type =
                                          //         controller.notificationsList[
                                          //                         index]
                                          //                     ['type'] ==
                                          //                 "1"
                                          //             ? "ride"
                                          //             : "trip";
                                          //     Get.toNamed(
                                          //         '/trip_detail/${controller.notificationsList[index]['ride_id']}/$type/${controller.notificationsList[index]['notification_type']}/${controller.notificationsList[index]['ride_detail_id']}');
                                          //   }
                                          // },
                                          onLongPress: () async {
                                            bool isConfirmed = await controller
                                                .serviceController
                                                .showConfirmationDialog(
                                                    controller.labelTextDetail[
                                                            'notification_confirm_message'] ??
                                                        "Are you sure you want to delete this notification",
                                                    cancelNoBtn:
                                                        "No, take me back!",
                                                    cancelYesBtn:
                                                        'Yes, delete it!');
                                            if (isConfirmed == false) {
                                            } else {
                                              await controller
                                                  .deleteNotification(controller
                                                          .notificationsList[
                                                      index]['id']);
                                            }
                                          },
                                          onTap: () {
                                            // controller.readNotification(
                                            //     controller.notificationsList[
                                            //         index]['id']);
                                            print(
                                                "=== NOTIFICATION TAP DEBUG START ===");
                                            print("Index: $index");
                                            print(
                                                "Full notification data: ${controller.notificationsList[index]}");
                                            print(
                                                "Notification type: ${controller.notificationsList[index]['notification_type']}");
                                            print(
                                                "Type field: ${controller.notificationsList[index]['type']}");
                                            print(
                                                "Ride ID: ${controller.notificationsList[index]['ride_id']}");
                                            print(
                                                "Posted by: ${controller.notificationsList[index]['posted_by']}");
                                            print(
                                                "Posted to: ${controller.notificationsList[index]['posted_to']}");
                                            print(
                                                "ID: ${controller.notificationsList[index]['id']}");
                                            print(
                                                "Ride detail ID: ${controller.notificationsList[index]['ride_detail_id']}");

                                            if (controller.notificationsList[
                                                        index]
                                                    ['notification_type'] ==
                                                "review") {
                                              print(
                                                  ">>> ENTERING REVIEW CONDITION <<<");
                                              if (controller.notificationsList[
                                                      index]['type'] ==
                                                  "1") {
                                                print(
                                                    "Review type is 1 - navigating to passenger review");
                                                var route =
                                                    '/notification_add_review/passenger/${controller.notificationsList[index]['ride_id']}/${controller.notificationsList[index]['posted_to']}/${controller.notificationsList[index]['id']}/${controller.notificationsList[index]['ride_detail_id']}';
                                                print(
                                                    "Navigation route: $route");
                                                Get.toNamed(route);
                                                print("Navigation completed");
                                              } else {
                                                print(
                                                    "Review type is NOT 1 - navigating to driver review");
                                                var route =
                                                    '/notification_add_review/driver/${controller.notificationsList[index]['ride_id']}/0/${controller.notificationsList[index]['id']}/${controller.notificationsList[index]['ride_detail_id']}';
                                                print(
                                                    "Navigation route: $route");
                                                Get.toNamed(route);
                                                print("Navigation completed");
                                              }
                                            } else if (controller
                                                        .notificationsList[index]
                                                    ['notification_type'] ==
                                                "chat") {
                                              print(
                                                  ">>> ENTERING CHAT CONDITION <<<");
                                              var rideId = 0;
                                              if (controller.notificationsList[
                                                      index]['ride_id'] !=
                                                  null) {
                                                rideId = int.parse(controller
                                                    .notificationsList[index]
                                                        ['ride_id']
                                                    .toString());
                                                print(
                                                    "Ride ID parsed: $rideId");
                                              } else {
                                                print(
                                                    "Ride ID is null, using 0");
                                              }
                                              var route =
                                                  '/messaging_page/${controller.notificationsList[index]['posted_by']}/$rideId/new';
                                              print(
                                                  "Chat navigation route: $route");
                                              Get.toNamed(route);
                                              print(
                                                  "Chat navigation completed");
                                            } else if (controller
                                                        .notificationsList[index]
                                                    ['notification_type'] ==
                                                "phone") {
                                              print(
                                                  ">>> ENTERING PHONE CONDITION <<<");
                                              print(
                                                  "Navigating to my_phone_number");
                                              Get.toNamed('/my_phone_number');
                                              print(
                                                  "Phone navigation completed");
                                            } else if (controller
                                                            .notificationsList[index]
                                                        ['notification_type'] !=
                                                    null &&
                                                controller.notificationsList[
                                                        index]['ride_id'] !=
                                                    null) {
                                              print(
                                                  ">>> ENTERING RIDE/TRIP CONDITION <<<");
                                              print(
                                                  "Notification type is not null: ${controller.notificationsList[index]['notification_type']}");
                                              print(
                                                  "Ride ID is not null: ${controller.notificationsList[index]['ride_id']}");

                                              // Handle ride/trip notifications
                                              var type =
                                                  controller.notificationsList[
                                                              index]['type'] ==
                                                          "1"
                                                      ? "ride"
                                                      : "trip";
                                              print(
                                                  "Determined type: $type (based on type field: ${controller.notificationsList[index]['type']})");

                                              var route =
                                                  '/trip_detail/${controller.notificationsList[index]['ride_id']}/$type/${controller.notificationsList[index]['notification_type']}/${controller.notificationsList[index]['ride_detail_id']}';
                                              print(
                                                  "Trip detail navigation route: $route");
                                              Get.toNamed(route);
                                              print(
                                                  "Trip detail navigation completed");
                                            } else {
                                              print(
                                                  ">>> ENTERING FALLBACK CONDITION (PROFILE) <<<");
                                              print(
                                                  "Notification type: ${controller.notificationsList[index]['notification_type']}");
                                              print(
                                                  "This includes welcome, birthday, christmas, password, and any other unhandled types");

                                              // Navigate to profile page for all unhandled notification types
                                              print(
                                                  "Navigating to profile page");
                                              Get.to(
                                                WelcomeScreen(
                                                  firstName: controller
                                                              .notificationsList[
                                                          index]['from']
                                                      ['first_name'],
                                                ),
                                              );
                                              // Get.toNamed('/profile_setting');
                                              print(
                                                  "Profile navigation completed");
                                            }

                                            print(
                                                "=== NOTIFICATION TAP DEBUG END ===");
                                          },
                                        ));
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox();
                                  }),
                            ),
                          ],
                        ),
                      ),
                      if (controller.isOverlayLoading.value == true) ...[
                        overlayWidget(context),
                      ],
                      if (controller.notificationsList.isEmpty &&
                          controller.filter.value == true &&
                          controller.isOverlayLoading.value == false) ...[
                        Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(noNotifications),
                            txt16Size(
                                title:
                                    "${controller.labelTextDetail['notification_page_no_messages_label'] ?? "You have no notifications"}",
                                context: context),
                          ],
                        ))
                      ]
                    ],
                  );
          }
        }));
  }
}

class WelcomeScreen extends StatelessWidget {
  final dynamic firstName;

  const WelcomeScreen({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF2563EB).withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Close button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),

                      // Company logo placeholder
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.directions_car,
                          size: 40,
                          color: Color(0xFF2563EB),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Company name
                      Text(
                        'ProximaRide',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        'Welcome to the future of ridesharing',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),

                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 32),

              // Welcome Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome badge
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFF2563EB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.celebration,
                            size: 18,
                            color: Color(0xFF2563EB),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Welcome Message',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Welcome message card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Greeting
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: Colors.grey[800],
                              ),
                              children: [
                                TextSpan(
                                  text: 'Hi $firstName,\n\n',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'Thanks for signing up to ProximaRide, and welcome!\n\n',
                                ),
                                TextSpan(
                                  text:
                                      'I\'m Erman, a dad and the founder, and glad that you decided to join us. I started ProximaRide because I wanted to make ridesharing safer, more affordable and more reliable for people like my daughter, who travels to her school in Ottawa (from Montreal) every week. Everyone should arrive at their destination safely, just like her.\n\n',
                                ),
                                TextSpan(
                                  text:
                                      'Don\'t worry, we don\'t send a lot of messages; just the essentials. So, just relax and enjoy the ride.\n\n',
                                ),
                                TextSpan(
                                  text:
                                      'We are always here to answer any queries that you may have so feel free to contact us. And remember - sharing is caring!\n\n',
                                ),
                              ],
                            ),
                          ),

                          // Profile completion section
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Color(0xFF2563EB).withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      color: Color(0xFF2563EB),
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Complete Profile',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'By the way, have you completed your profile yet? If not yet, click here to do so; it\'s only four easy steps and only takes a couple of minutes.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.toNamed('/profile_setting');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Complete Profile',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, size: 16),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24),

                          // Closing message
                          Text(
                            'Again, thank you for joining, and welcome!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Signature section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Color(0xFF2563EB),
                                child: Text(
                                  'E',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Erman',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'ProximaRide Founder',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'And the entire ProximaRide Team',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Contact section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF2563EB).withOpacity(0.1),
                            Color(0xFF8B5CF6).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.support_agent,
                            color: Color(0xFF2563EB),
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Need Help?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'We\'re always here to help you',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to contact/support
                            },
                            child: Text(
                              'Contact Us',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
