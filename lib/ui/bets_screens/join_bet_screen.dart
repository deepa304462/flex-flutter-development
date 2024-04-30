import 'package:flexx_bet/chat/chat_controller.dart';
import 'package:flexx_bet/chat/widgets/join_requests.dart';
import 'package:flexx_bet/chat/widgets/messages_view.dart';
import 'package:flexx_bet/extensions/map_extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../controllers/wallet_controller.dart';
import '../components/custom_button.dart';
import '../notifications_and_bethistory/notifications.dart';
import '../wallet/wallet.dart';

class JoinBetScreen extends StatefulWidget {
  const JoinBetScreen({super.key});

  @override
  State<JoinBetScreen> createState() => _JoinBetScreenState();
}

class _JoinBetScreenState extends State<JoinBetScreen> {
  var controller = Get.find<ChatController>();
  var isAdmin =  false;
  @override
  void initState() {
    super.initState();
    isAdmin =  ((controller.currentGroup.value?.data() as Map).getValueOfKey("admin") == "${controller.uid}_${controller.currentUserData.value.getValueOfKey("name")}");

  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: isAdmin?4:3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          iconTheme: IconThemeData(color: ColorConstant.whiteA700),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => NotificationsScreen());
                },
                icon: SvgPicture.asset(ImageConstant.notificationIcon)),
            const SizedBox(
              width: 12,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => WalletScreen());
              },
              child: Container(
                height: 37,
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
          bottom: PreferredSize(
            preferredSize: const Size.square(50),
            child: Material(
              color: Colors.white,
              elevation: 0,
              child: TabBar(
                padding: const EdgeInsets.only(left: 35, right: 35),
                tabs: [
                  const Tab(text: 'Banter'),
                  Image.asset(ImageConstant.liveButton),
                  const Tab(text: 'Results'),
                  if(isAdmin)
                    const Tab(text: 'Requests'),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              const MessagesView(),
              /*Column(
                children: [
                  Container(
                    width: 418,
                    height: 222,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            ColorConstant.black900,
                            ColorConstant.blackLight,
                          ],
                        )),
                    child: Stack(fit: StackFit.expand, children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            ImageConstant.staticJoinBet,
                            fit: BoxFit.cover,
                          )),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black
                              .withOpacity(0.5), // Adjust opacity as needed
                        ),
                      ),
                      Positioned.fill(
                        bottom: 40,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Omah Lay will drop a new \n    Album this weekend.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: 6,
                                width: 254,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                        colors: [
                                          ColorConstant.red1,
                                          ColorConstant.greenLight1,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          left: 12,
                          top: 6,
                          child: Image.asset(
                            ImageConstant.musicIcon,
                            height: 30,
                            width: 30,
                          )),
                      Positioned(
                          left: 125,
                          top: 12,
                          child: Container(
                            width: 130,
                            height: 20,
                            decoration: BoxDecoration(
                                color: ColorConstant.primaryColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Event Pool",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Popins",
                                      fontSize: 14),
                                ),
                                Text(
                                  " ₦2500",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Popins",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                )
                              ],
                            ),
                          )),
                      Positioned(
                          right: 16,
                          top: 8,
                          child: Image.asset(
                            ImageConstant.shareIcon,
                            fit: BoxFit.fill,
                          )),
                      Positioned(
                          right: 60,
                          bottom: 30,
                          top: 143,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: ColorConstant.greenLight,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Popins"),
                              ),
                            ),
                          )),
                      Positioned(
                          right: 40,
                          bottom: 35,
                          top: 170,
                          child: Container(
                            height: 10,
                            width: 30,
                            decoration: BoxDecoration(
                                color: ColorConstant.grey1,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                              child: Text(
                                "58",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Popins"),
                              ),
                            ),
                          )),
                      Positioned(
                          left: 60,
                          bottom: 30,
                          top: 143,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: ColorConstant.red1,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                              child: Text(
                                "No",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Popins"),
                              ),
                            ),
                          )),
                      Positioned(
                          left: 40,
                          bottom: 35,
                          top: 170,
                          child: Container(
                            height: 10,
                            width: 30,
                            decoration: BoxDecoration(
                                color: ColorConstant.grey1,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                              child: Text(
                                "15",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Popins"),
                              ),
                            ),
                          )),
                    ]),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImageConstant.unsplash),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Please abide to the rules!",
                        style: TextStyle(
                            color: ColorConstant.gray500, fontFamily: "Popins"),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Image.asset(ImageConstant.pushpin),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(ImageConstant.unsplash),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    "I agree. Worth waiting till it's trading at \nits true valuation post lock up...",
                                    style: TextStyle(
                                        color: ColorConstant.black900,
                                        fontFamily: "Popins"),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  Image.asset(ImageConstant.heart),
                                  Text(
                                    "23.5k",
                                    style: TextStyle(
                                        color: ColorConstant.black900,
                                        fontFamily: "Popins"),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Image.asset(ImageConstant.message),
                                  Text(
                                    "3.3k",
                                    style: TextStyle(
                                        color: ColorConstant.black900,
                                        fontFamily: "Popins"),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Image.asset(ImageConstant.eye),
                                  Text(
                                    "104k",
                                    style: TextStyle(
                                        color: ColorConstant.black900,
                                        fontFamily: "Popins"),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Image.asset(ImageConstant.export),
                                  const SizedBox(
                                    width: 40,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              )
                            ],
                          );
                        }),
                  ),
                  Row(
                    children: [
                      Image.asset(ImageConstant.messageGreen),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        "View all 22 comments",
                        style: TextStyle(
                            color: ColorConstant.greenA700,
                            fontFamily: "Popins",
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 33,
                        width: 33,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: ColorConstant.whiteA700,
                          child: Image.asset(ImageConstant.caretDown),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 342,
                        height: 43,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: ColorConstant.gray500)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Send a message",
                              style: TextStyle(
                                  color: ColorConstant.gray500,
                                  fontFamily: "Popins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            Image.asset(ImageConstant.happyPng),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                      Image.asset(ImageConstant.goIcon),
                    ],
                  )
                ],
              ),*/
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No bet Created Yet!',
                      style: TextStyle(
                          color: ColorConstant.blueGray40002,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Popins")),
                  const SizedBox(
                    height: 20,
                  ),
                  const CustomButton(
                    text: "Create a Bet",
                    fontStyle: ButtonFontStyle.PoppinsSemiBold18,
                    height: 48,
                    width: 307,
                  ),
                ],
              ),
              ListView.builder(
                itemCount: 6, // Set the number of items in the list
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 110,
                        decoration: BoxDecoration(color: ColorConstant.listBackground),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  GradientText(
                                    "${index + 1}", // Text changes according to the list index
                                    style: TextStyle(
                                      fontSize: 30,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 3
                                        ..color = ColorConstant.whiteA700,
                                    ),
                                    colors: [
                                      ColorConstant.amber300,
                                      ColorConstant.purple50,
                                    ],
                                    gradientType: GradientType.linear,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Image.asset(
                                    ImageConstant.profile1,
                                    height: 54,
                                    width: 54,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    '@Thomas',
                                    style: TextStyle(
                                      color: ColorConstant.black900,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Popins",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Column(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: ColorConstant.gray500,
                                            fontFamily: "Popins",
                                          ),
                                          children: <TextSpan>[
                                            const TextSpan(
                                              text: 'Staked ',
                                            ),
                                            TextSpan(
                                              text: '₦1000', // Change this text as needed
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: ColorConstant.gray500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const CustomButton(
                                        width: 100,
                                        text: "₦1000",
                                        fontStyle: ButtonFontStyle.InterSemiBold16,
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 13),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: ColorConstant.greenLight,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Popins",
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(ImageConstant.upIcon),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  );
                },
              ),
              if(isAdmin) const JoinRequests(),
            ],
          ),
        ),
      ),
    );
  }
}
