import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/controller/localization_controller.dart';
import 'package:six_cash/data/model/transaction_model.dart';
import 'package:six_cash/helper/date_converter.dart';
import 'package:six_cash/helper/price_converter.dart';
import 'package:six_cash/util/app_constants.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
class TransactionHistoryCardWidget extends StatelessWidget {
  final Transactions transactions;
  const TransactionHistoryCardWidget({Key key, this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _userPhone;
    String _userName;
    bool _isCredit = transactions.transactionType == AppConstants.SEND_MONEY
        || transactions.transactionType == AppConstants.WITHDRAW
        || transactions.transactionType == AppConstants.CASH_OUT;
     try{
       // _userName = transactions.userInfo.name ?? '';
       // _userPhone = transactions.userInfo.phone ?? '';

       _userPhone = transactions.transactionType == AppConstants.CASH_IN
           ? transactions.sender.phone : transactions.transactionType == AppConstants.AGENT_COMMISSION
           ? transactions.sender.phone : transactions.transactionType == AppConstants.ADD_MONEY
           ? transactions.sender.phone : transactions.transactionType == AppConstants.RECEIVED_MONEY
           ? transactions.sender.phone : transactions.transactionType == AppConstants.CASH_OUT
           ? transactions.receiver.phone : transactions.transactionType == AppConstants.WITHDRAW
           ? transactions.receiver.phone : '';

       _userName = transactions.transactionType == AppConstants.CASH_IN
           ? transactions.sender.name : transactions.transactionType == AppConstants.AGENT_COMMISSION
           ? transactions.sender.name : transactions.transactionType == AppConstants.ADD_MONEY
           ? transactions.sender.name : transactions.transactionType == AppConstants.RECEIVED_MONEY
           ? transactions.sender.name : transactions.transactionType == AppConstants.CASH_OUT
           ? transactions.receiver.name : transactions.transactionType == AppConstants.WITHDRAW
           ? transactions.receiver.name : '';

     }catch(e){
       _userPhone = 'user_unavailable'.tr;
       _userPhone = 'user_unavailable'.tr;
     }

   String _image = transactions.transactionType == AppConstants.CASH_IN ? Images.send_money_icon :
    transactions.transactionType == AppConstants.AGENT_COMMISSION ? Images.refer_image :
    transactions.transactionType == AppConstants.ADD_MONEY ? Images.addMoneyLogo3 :
    transactions.transactionType == AppConstants.RECEIVED_MONEY ? Images.requestMoney_logo :
    transactions.transactionType == AppConstants.CASH_OUT ? Images.cashOut_logo :
    transactions.transactionType == AppConstants.WITHDRAW ? Images.with_draw :
    Images.refer_image;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Stack(
        children: [
         Column(
          children: [
            Row(
              children: [
                Container(height: 50,width: 50, child: Padding(padding:
                  const EdgeInsets.all(8.0), child: Image.asset(_image))),

                SizedBox(width: 5,),

                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        transactions.transactionType.tr,
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),


                      Text(
                        _userName ?? '',
                        style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                      Text(_userPhone?? '', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                      SizedBox(height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                      Text('TrxID: ${transactions.transactionId}',style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL))
                    ]),
                Spacer(),

                Text('${_isCredit ? '-' : '+'} ${PriceConverter.convertPrice(double.parse('${transactions.amount}'))}',
                  style: rubikMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    color: _isCredit ? Colors.redAccent : Colors.green,
                  )),

              ],
            ),
            SizedBox(height: 5),
            Divider(height: .125),
          ],
        ),
          Get.find<LocalizationController>().isLtr ?  Positioned(
            bottom:  3 ,
              right: 2,
              child: Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(transactions.createdAt)),style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getHintColor()),),
          ): Positioned(
            bottom:  3 ,
            left: 2,
            child: Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(transactions.createdAt)),style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getHintColor()),),
          )
        ],
      ),
    );
  }
}
