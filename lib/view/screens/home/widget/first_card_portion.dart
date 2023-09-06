import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/controller/profile_screen_controller.dart';
import 'package:six_cash/helper/TransactionType.dart';
import 'package:six_cash/helper/price_converter.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/view/screens/home/widget/banner_view.dart';
import 'package:six_cash/view/screens/home/widget/custom_card.dart';
import 'package:six_cash/view/screens/requested_money/requested_money_list_screen.dart';
import 'package:six_cash/view/screens/transaction_money/transaction_money_balance_input.dart';

class FirstCardPortion extends StatelessWidget {
  final ProfileController profileController;
  const FirstCardPortion({Key key,@required this.profileController}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Container(
          height: Dimensions.MAIN_BACKGROUND_CARD_WEIGHT,
          color: Theme.of(context).primaryColor,
        ),

        Positioned(
          child: Column(
            children: [
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

              SizedBox(
                height: Dimensions.TRANSACTION_TYPE_CARD_HEIGHT,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.FONT_SIZE_EXTRA_SMALL),
                  child: Row(
                    children: [

                      Expanded(child: CustomCard(
                        image: Images.sendMoney_logo,
                        text: 'send_money_'.tr,
                        color: Theme.of(context).secondaryHeaderColor,
                        onTap: () => Get.to(()=> TransactionMoneyBalanceInput(transactionType: TransactionType.SEND_MONEY)),
                      )),

                      Expanded(child: CustomCard(
                        image: Images.addMoneyLogo3,
                        text: 'add_money_'.tr,
                        color: ColorResources.getCashOutCardColor(),
                        onTap: ()=> Get.to(TransactionMoneyBalanceInput(transactionType: TransactionType.ADD_MONEY)),
                      )),

                      Expanded(child: CustomCard(
                        image: Images.requestMoneyLogo,
                        text: 'request_money_'.tr,
                        color: ColorResources.getRequestMoneyCardColor(),
                        onTap: ()=> Get.to(()=> TransactionMoneyBalanceInput(transactionType: TransactionType.REQUEST_MONEY)),
                      )),

                      Expanded(child: CustomCard(
                        image: Images.with_draw,
                        text: 'withdraw_request'.tr.replaceAll(' ', '\n'),
                        color: ColorResources.getReferFriendCardColor(),
                        onTap: ()=> Get.to(()=> TransactionMoneyBalanceInput(transactionType: TransactionType.WITHDRAW_REQUEST)),
                      )),
                    ],
                  ),
                ),
              ),

              GetBuilder<ProfileController>(
                  builder: (profile) {
                    return profile.userInfo != null?
                    GestureDetector(
                      onTap: ()=> Get.to(()=> RequestedMoneyListScreen(requestType: RequestType.WITHDRAW)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT, Dimensions.PADDING_SIZE_DEFAULT, Dimensions.PADDING_SIZE_DEFAULT, 0),
                        child: Container(

                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL)

                        ),
                            child: Row(
                          children: [
                            Expanded(
                              child: Column(children: [
                                Text.rich(TextSpan(children: [
                                  WidgetSpan(child: Row(
                                    children: [
                                      Text('withdraw_req_amount'.tr,
                                        style: rubikRegular.copyWith(color: Get.isDarkMode?
                                        Colors.white: Theme.of(context).primaryColor),),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text(PriceConverter.balanceWithSymbol(balance: profile.userInfo.pendingBalance.toString()),
                                          style: rubikSemiBold.copyWith(color: Get.isDarkMode?
                                          Colors.white: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    ],
                                  ))
                                ])),


                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                                Text.rich(TextSpan(children: [
                                  WidgetSpan(child: Row(
                                    children: [
                                      Text(profile.userInfo.pendingWithdrawCount.toString(),
                                          style: rubikSemiBold.copyWith(
                                              color:Get.isDarkMode?Colors.white: Theme.of(context).primaryColor,
                                              fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text('withdraw_request'.tr,style: rubikRegular.copyWith(
                                          color: Get.isDarkMode?Colors.white: Theme.of(context).primaryColor)),
                                    ],
                                  ))
                                ])),

                              ],),
                            ),
                            Icon(Icons.arrow_forward_ios, color: Get.isDarkMode?Colors.white: Theme.of(context).primaryColor,)
                          ],
                        )),
                      ),
                    ):SizedBox();
                  }
              ),

              /// Banner..
              BannerView(),

            ],
          ),
        ),
      ],
    );
  }

}
