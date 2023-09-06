import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/data/model/response/requested_money_model.dart';
import 'package:six_cash/data/model/withdraw_histroy_model.dart';
import 'package:six_cash/helper/date_converter.dart';
import 'package:six_cash/helper/price_converter.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/view/screens/requested_money/requested_money_list_screen.dart';

class RequestedMoneyCard extends StatefulWidget {
  final RequestedMoney requestedMoney;
  final bool isHome;
  final RequestType requestType;
  final WithdrawHistory withdrawHistory;

  const RequestedMoneyCard({
    Key key, this.requestedMoney,
    this.isHome, this.requestType,
    this.withdrawHistory,
  }) : super(key: key);

  @override
  State<RequestedMoneyCard> createState() => _RequestedMoneyCardState();
}

class _RequestedMoneyCardState extends State<RequestedMoneyCard> {
  final TextEditingController reqPasswordController = TextEditingController();
  List<FieldItem> _itemList = [];

  @override
  void initState() {

    if(widget.requestType == RequestType.WITHDRAW) {
      widget.withdrawHistory.withdrawalMethodFields.forEach((key, value) {
        _itemList.add(FieldItem(key, value));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.requestType == RequestType.WITHDRAW ? Card(
      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.2)),
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Column(children: [
            _methodFieldView(type: 'withdraw_method'.tr, value: '${widget.withdrawHistory.methodName}'),
            SizedBox(height: Dimensions.DIVIDER_SIZE_EXTRA_LARGE,),

            _methodFieldView(type: 'request_status'.tr, value: widget.withdrawHistory.requestStatus.tr),
            SizedBox(height: Dimensions.DIVIDER_SIZE_EXTRA_LARGE,),

            _methodFieldView(type: 'amount'.tr, value: PriceConverter.balanceWithSymbol(balance: '${widget.withdrawHistory.amount}')),
          ],),
        ),

        Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Column(children: _itemList.map((_item) => Padding(
            padding: const EdgeInsets.all(3.0),
            child: _methodFieldView(type: _item.key.replaceAll('_', ' ').capitalizeFirst, value: _item.value),
          )).toList()),
        ),
      ],
      ),
    ) : Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.requestedMoney.receiver.name}', style: rubikMedium.copyWith(color: ColorResources.getTextColor(),fontSize: Dimensions.FONT_SIZE_LARGE) ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                    Text('amount_'.tr + '${PriceConverter.balanceWithSymbol(
                        balance: widget.requestedMoney.amount.toString())}',
                        style: rubikMedium.copyWith(color: Theme.of(context).textTheme.titleLarge.color,fontSize: Dimensions.FONT_SIZE_DEFAULT)
                    ),

                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Text(DateConverter.localDateToIsoStringAMPM(
                        DateTime.parse(widget.requestedMoney.createdAt)),
                        style: rubikLight.copyWith(color: ColorResources.getTextColor(), fontSize: Dimensions.FONT_SIZE_SMALL)
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              ]),
            ],
          ),
          SizedBox(height: 5),
          widget.isHome ? SizedBox() : Divider(height: .5,color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.3)),
        ],
      ),
    );
  }

  Widget _methodFieldView({@required String type,@required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(type, style: rubikLight.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),),

        Text(value),
      ],
    );
  }
}

class FieldItem{
  final String key;
  final String value;
  FieldItem(this.key, this.value);

}
