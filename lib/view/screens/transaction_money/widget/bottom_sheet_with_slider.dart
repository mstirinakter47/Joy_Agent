import 'package:six_cash/controller/bootom_slider_controller.dart';
import 'package:six_cash/controller/profile_screen_controller.dart';
import 'package:six_cash/controller/screen_shot_widget_controller.dart';
import 'package:six_cash/controller/splash_controller.dart';
import 'package:six_cash/controller/transaction_controller.dart';
import 'package:six_cash/data/model/response/contact_model.dart';
import 'package:six_cash/helper/TransactionType.dart';
import 'package:six_cash/helper/price_converter.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:six_cash/view/base/custom_ink_well.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import 'avator_section.dart';

class BottomSheetWithSlider extends StatefulWidget {
  final String amount;
  final String pinCode;
  final String transactionType;
  final ContactModel contactModel;

  const BottomSheetWithSlider({
    Key key, @required this.amount,
    this.pinCode, this.transactionType, this.contactModel,
  }) : super(key: key);

  @override
  State<BottomSheetWithSlider> createState() => _BottomSheetWithSliderState();
}

class _BottomSheetWithSliderState extends State<BottomSheetWithSlider> {
  String transactionId ;

  @override
  void initState() {
    Get.find<TransactionMoneyController>().changeTrueFalse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _configModel = Get.find<SplashController>().configModel;

    String type = widget.transactionType == TransactionType.SEND_MONEY ? 'send_money'.tr
        : widget.transactionType == TransactionType.WITHDRAW_REQUEST ? 'admin_cash_out'.tr
        : widget.transactionType == TransactionType.ADD_MONEY ? 'add_money'.tr
        :'request_money'.tr;

    double cashOutCharge = double.parse(widget.amount.toString()) *
        (double.parse(_configModel.sendMoneyChargeFlat.toString())/100);

    String customerImage = '${_configModel.baseUrls.customerImageUrl}/${widget.contactModel.avatarImage}';
    String companyImage = '${_configModel.baseUrls.companyImageUrl}/${_configModel.companyLogo}';

    return WillPopScope(
      onWillPop: ()=>Get.offAllNamed(RouteHelper.getNavBarRoute()),
      child: Container(
        decoration: BoxDecoration(
          color: ColorResources.getBackgroundColor(),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.RADIUS_SIZE_LARGE),
            topRight:Radius.circular(Dimensions.RADIUS_SIZE_LARGE),
          ),
        ),

        child: GetBuilder<TransactionMoneyController>(
          builder: (transactionMoneyController) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE),
                      decoration: BoxDecoration(
                        color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.04),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SIZE_LARGE) ),
                      ),
                      child: Text('confirm_to'.tr +' '+ type, style: rubikSemiBold.copyWith(),),
                    ),
                    !transactionMoneyController.isLoading?
                    Visibility(
                      visible: !transactionMoneyController.isNextBottomSheet,
                      child: Positioned(
                        top: Dimensions.PADDING_SIZE_SMALL,
                        right: 8.0,
                        child: GestureDetector(onTap: ()=> Get.back(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: ColorResources.getGreyBaseGray6()),
                                child: Icon(Icons.clear,size: Dimensions.PADDING_SIZE_DEFAULT,))),
                      ),
                    ) : SizedBox(),
                  ],
                ),

                transactionMoneyController.isNextBottomSheet ?
                Column(
                  children: [
                    transactionMoneyController.isNextBottomSheet ? Lottie.asset(
                      Images.success_animation,
                      width: Dimensions.SUCCESS_ANIMATION_WIDTH,
                      fit: BoxFit.contain, alignment: Alignment.center,
                    ) : Padding(
                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Lottie.asset(
                        Images.failed_animation,
                        width: Dimensions.FAILED_ANIMATION_WIDTH,
                        fit: BoxFit.contain,alignment: Alignment.center,
                      ),
                    ),
                  ],
                ): AvatarSection(
                  image: widget.transactionType != TransactionType.WITHDRAW_REQUEST ? customerImage : companyImage,
                ),

                Container(
                  color: ColorResources.getBackgroundColor(),
                  child: Column(
                    children: [

                      transactionMoneyController.isNextBottomSheet ?
                      Text(widget.transactionType == TransactionType.SEND_MONEY
                          ? 'send_money_successful'.tr : widget.transactionType == TransactionType.REQUEST_MONEY
                          ?'request_send_successful'.tr : 'cash_out_successful'.tr,
                          style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Theme.of(context).textTheme.titleLarge.color,
                          ),
                      ) : SizedBox(),

                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE),

                      Text(
                        '${PriceConverter.balanceWithSymbol(balance: widget.amount)}',
                        style: rubikMedium.copyWith(fontSize: 34.0),
                      ),

                      GetBuilder<ProfileController>(
                        builder: (profileController) {
                          return profileController.userInfo == null ? SizedBox() : Text(
                            'new_balance'.tr+' '+'${
                              widget.transactionType == TransactionType.REQUEST_MONEY
                              ? PriceConverter.newBalanceWithCredit(inputBalance: double.parse(widget.amount))
                              : PriceConverter.newBalanceWithDebit(inputBalance: double.parse(widget.amount),
                              charge: 0)
                            }',
                            style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                          );
                        }
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        child: Divider(height: Dimensions.DIVIDER_SIZE_SMALL),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_DEFAULT,
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                        ),

                        child: Column(
                          children: [

                            widget.transactionType == TransactionType.WITHDRAW_REQUEST ?
                            Text('cash_out_from_admin'.tr) :
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.contactModel.name == null ?'(unknown )' :'(${widget.contactModel.name}) ',
                                  style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                  maxLines: 1,overflow: TextOverflow.ellipsis,
                                ),

                                Text(
                                  widget.contactModel.phoneNumber,
                                  style: rubikSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                ),
                              ],
                            ),

                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                            transactionMoneyController.isNextBottomSheet ?
                            transactionId != null? Text( 'trx_id'.tr+': $transactionId', style: rubikLight.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)): SizedBox()
                            : SizedBox(),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),


                transactionMoneyController.isNextBottomSheet?
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT / 1.7),
                      child: Divider(height: Dimensions.DIVIDER_SIZE_SMALL),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    CustomInkWell(
                        onTap:() async => await Get.find<ScreenShootWidgetController>().statementScreenShootFunction(
                          amount: widget.amount, transactionType: widget.transactionType, contactModel: widget.contactModel,
                          charge: widget.transactionType == TransactionType.SEND_MONEY ? '0' :  cashOutCharge.toString(),
                          trxId: transactionId,
                        ),
                        child: Text('share_statement'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE))),

                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                  ],
                ) : SizedBox(),



                transactionMoneyController.isNextBottomSheet ?
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_SMALL),
                    ),
                    child: CustomInkWell(
                      onTap: (){
                        Get.find<BottomSliderController>().goBackButton();
                      },
                      radius: Dimensions.RADIUS_SIZE_SMALL,
                      highlightColor: Theme.of(context).textTheme.titleLarge.color.withOpacity(0.1),
                      child: SizedBox(
                        height: 50.0,
                        child: Center(child: Text(
                          'back_to_home'.tr,
                          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.white),
                        )),

                      ),
                    ),
                  ),
                ):
                transactionMoneyController.isLoading ? Center(
                  child: CircularProgressIndicator(color: Theme.of(context).textTheme.titleLarge.color),
                ) :
                ConfirmationSlider(
                  height: 60.0,
                  backgroundColor: ColorResources.getGreyBaseGray6(),
                  text: 'swipe_to_confirm'.tr,
                  textStyle: rubikRegular.copyWith(fontSize: Dimensions.PADDING_SIZE_LARGE),
                  shadow: BoxShadow(),
                  sliderButtonContent: Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(Images.slide_right_icon, color: Colors.white),

                  ),
                  onConfirmation: ()async{
                    if( widget.transactionType == TransactionType.SEND_MONEY){
                      transactionMoneyController.cashIn(
                        contactModel: widget.contactModel,
                        amount: double.parse(widget.amount),
                        pinCode: widget.pinCode,
                      ).then((value) {
                        transactionId = value.body['transaction_id'];
                      });
                    }


                  },

                ),

                SizedBox(height: 40.0),

              ],
            );
          }
        ),
      ),
    );
  }
}