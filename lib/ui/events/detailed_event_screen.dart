import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flexx_bet/controllers/events_controller.dart';
import 'package:flexx_bet/models/event_model.dart';
import 'package:flexx_bet/ui/components/custom_appbar.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flexx_bet/ui/events/widgets/people_betting_widget.dart';
import 'package:flexx_bet/ui/events/widgets/swipe_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../controllers/wallet_controller.dart';
import '../bets_screens/bets_screen.dart';
import '../notifications_and_bethistory/notifications.dart';
import '../wallet/wallet.dart';

class DetailedEventScreen extends StatefulWidget {
  DetailedEventScreen({super.key});

  @override
  State<DetailedEventScreen> createState() => _DetailedEventScreenState();
}

class _DetailedEventScreenState extends State<DetailedEventScreen> {
  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        toolbarHeight: 80,
        actions: [
          IconButton(
              onPressed: () {
                //todo implement on press
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          const SizedBox(
            width: 50,
          ),
          Stack(
            children: [
              InkWell(
                onTap: (){
                  _showPopup(context);
                },
                child: Container(
                  height: 30,
                  width: 125,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [ColorConstant.deepPurpleA200,ColorConstant.orange]
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(18),bottomRight: Radius.elliptical(50,70))

                  ),
                  child: Center(child:  Text("Create A Bet",style: TextStyle(color: ColorConstant.whiteA700,fontFamily: "Popins",fontWeight: FontWeight.w600,fontSize: 16),)),
                ),
              ),
              Positioned(
                  left: 6,
                  top: 2,
                  child: SvgPicture.asset(ImageConstant.starIcon))
            ],
          ),
          const SizedBox(
            width: 12,
          ),
          IconButton(
              onPressed: () {
                Get.to(() => NotificationsScreen());
              },
              icon: SvgPicture.asset(ImageConstant.notificationIcon)),
          const SizedBox(
            width: 6,
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => WalletScreen());
            },
            child: Container(
              height: 35,
              width: 97,
              margin: const EdgeInsets.only(top: 14, bottom: 14),
              padding: const EdgeInsets.only(left: 18, right: 18),
              decoration: BoxDecoration(
                  color: ColorConstant.whiteA700,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50))),
              child: Center(
                child: GetBuilder<WalletContoller>(builder: (controller) {
                  return Text(
                    "₦${controller.totalAmount}",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.primaryColor),
                  );
                }),
              ),
            ),
          )
        ],
      ),*/
      appBar: const CustomAppBar(
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<EventsController>(builder: (controller) {
          EventModel? eventModel = controller.getCurrentEvent;
          bool isLive = false;
          if (eventModel != null) {
            isLive = eventModel.heldDate.microsecondsSinceEpoch <
                    Timestamp.now().microsecondsSinceEpoch &&
                !eventModel.isEnded &&
                !eventModel.isCancelled;
          }
          return Builder(
            builder: (context) {
              if(eventModel!=null){
                final String formattedtime = DateFormat("hh:mm:ss a").format(eventModel!.heldDate.toDate());
                return SizedBox(
                    height: Get.height / 1.2,
                    child: Column(
                      children: [
                        SizedBox(height: Get.height * 0.7, child: EventSwiper()),
                        Expanded(
                          flex: 7,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 10),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            ShowPeopleBetting(),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(2),
                                                  child: Transform.flip(
                                                      flipX: true,
                                                      child:
                                                      const Icon(Icons.update)),
                                                ),
                                                Text(
                                                  isLive
                                                      ? "Event started at: "
                                                      : eventModel.isCancelled
                                                      ? "Cancelled"
                                                      : eventModel.isEnded
                                                      ? "Ended"
                                                      : "Event starts in: ",
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            eventModel.isCancelled ||
                                                eventModel.isEnded
                                                ? const SizedBox()
                                                : Text(formattedtime),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ));
              }else{
                return Container();
              }
            }
          );
        }),
      ),
    );
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data;

    /// When app is killed state
    if (deepLink != null) {
      deepLink.link.queryParameters['invitedCode'] ?? '';
      print(deepLink.link.queryParameters['invitedCode'] ?? '');
    }

    /// When app is live and background state
    dynamicLinks.onLink.listen((dynamicLinkData) {
      dynamicLinkData.link.queryParameters['invitedCode'] ?? '';
      print(dynamicLinkData.link.queryParameters['invitedCode'] ?? '');
    }).onError((error) {
      print(error.message);
    });
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.5),
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 467,
            width: 353,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorConstant.gradiant1, ColorConstant.gradiant2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Please Read Terms.",
                  style: TextStyle(
                      color: ColorConstant.primaryColor, fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Popins"),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Please read and agree to terms before you proceed.\nPlease read and agree to terms before you proceed\nPlease read and agree to terms before you proceed\nPlease read and agree to terms before you proceed\nPlease read and agree to terms before you proceed",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                      fontFamily: "Popins"
                  ),
                ),
                const Spacer(
                ),
                 CustomButton(
                  text: "Proceed",
                  fontStyle: ButtonFontStyle.InterSemiBold16,
                  onTap: () {
                    Get.to(const BetScreen());
                  },
                   height: 48,
                   width: 307,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
