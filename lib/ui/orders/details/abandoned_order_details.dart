import 'package:azzoa_grocery/app_localization.dart';
import 'package:azzoa_grocery/base/exception/app_exception.dart';
import 'package:azzoa_grocery/constants.dart';
import 'package:azzoa_grocery/data/local/model/app_config_provider.dart';
import 'package:azzoa_grocery/data/remote/model/dynamic_order_details_response.dart';
import 'package:azzoa_grocery/data/remote/model/manual_order_place_response.dart';
import 'package:azzoa_grocery/data/remote/model/order_details.dart';
import 'package:azzoa_grocery/data/remote/model/ordered_item.dart';
import 'package:azzoa_grocery/data/remote/model/payment_method.dart';
import 'package:azzoa_grocery/data/remote/model/product.dart';
import 'package:azzoa_grocery/data/remote/response/order_details_response.dart';
import 'package:azzoa_grocery/data/remote/response/payment_method_list_response.dart';
import 'package:azzoa_grocery/data/remote/response/single_product_response.dart';
import 'package:azzoa_grocery/data/remote/service/api_service.dart';
import 'package:azzoa_grocery/ui/checkout/payment/manual_payment.dart';
import 'package:azzoa_grocery/ui/checkout/payment/payment.dart';
import 'package:azzoa_grocery/ui/checkout/summary/checkout_summary.dart';
import 'package:azzoa_grocery/ui/orders/successfuldeliver/successful_delivery.dart';
import 'package:azzoa_grocery/ui/product/details/product_details.dart';
import 'package:azzoa_grocery/util/helper/color.dart';
import 'package:azzoa_grocery/util/lib/toast.dart';
import 'package:azzoa_grocery/util/lib/web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AbandonedOrderDetailsPage extends StatefulWidget {
  final int orderId;
  final String orderStatus;

  AbandonedOrderDetailsPage({
    @required this.orderId,
    this.orderStatus,
  });

  @override
  _AbandonedOrderDetailsPageState createState() =>
      _AbandonedOrderDetailsPageState();
}

class _AbandonedOrderDetailsPageState extends State<AbandonedOrderDetailsPage> {
  bool isLoading = false;

  Future<OrderDetailsResponse> _loadOrderDetails;
  AppConfigNotifier appConfigNotifier;
  List<PaymentMethod> paymentMethodList = [];
  int selectedPaymentMethod = 0;

  @override
  void didChangeDependencies() {
    appConfigNotifier = Provider.of<AppConfigNotifier>(
      context,
      listen: false,
    );
    _loadOrderDetails = NetworkHelper.on().getOrderDetails(
      context,
      widget.orderId,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: kCommonBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          brightness: Brightness.light,
          backgroundColor: kCommonBackgroundColor,
          elevation: 0.0,
          title: Text(
            "${getString('order')} # ${widget.orderId}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: kCommonBackgroundColor,
        body: SafeArea(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return FutureBuilder(
      future: _loadOrderDetails,
      builder: (context, AsyncSnapshot<OrderDetailsResponse> snapshot) {
        if (snapshot.hasData) {
          OrderDetails orderDetails = snapshot.data.data.jsonObject;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      buildOrderList(orderDetails),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                        child: buildShippingMethod(orderDetails),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                        child: buildPaymentMethodSection(
                            context, orderDetails.id.toString()),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton.icon(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(20.0),
                  onPressed: () {
                    if (paymentMethodList.isEmpty) {
                      ToastUtil.show(
                        getString('checkout_not_sufficient_data'),
                      );
                    } else {
                      _payAbandoned(paymentMethodList[selectedPaymentMethod].id,
                          orderDetails.id);
                    }
                  },
                  color: ColorUtil.hexToColor(
                    appConfigNotifier.appConfig.color.buttonColor_2,
                  ),
                  label: Text(
                    getString('checkout_cart_summary'),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              )
            ],
          );
        }

        if (snapshot.hasError) {
          String errorMessage = getString('something_went_wrong');

          if (snapshot.hasError &&
              snapshot.error is AppException &&
              snapshot.error.toString().trim().isNotEmpty) {
            errorMessage = snapshot.error.toString().trim();
          }

          return buildErrorBody(errorMessage);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _payAbandoned(int paymentMethodId, int orderId) async {
    setState(() {
      isLoading = true;
    });

    try {
      var jsonData = await NetworkHelper.on()
          .abandonedPayment(context, paymentMethodId, orderId);

      setState(() {
        isLoading = false;
      });

      final data = jsonData["data"];
      if (data.containsKey("string_data")) {
        DynamicOrderDetailsResponse response =
            DynamicOrderDetailsResponse.fromJson(jsonData);
        if (response != null &&
            response.data != null &&
            response.data.stringData.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return PaymentPage(
                url: response.data.stringData,
              );
            }),
          ).then(
            (value) {
              if (value != null && value is bool) {
                if (value) {
                  Navigator.of(context).pop(value);
                } else {
                  ToastUtil.show(getString('checkout_summary_payment_error'));
                }
              }
            },
          );
        }
      } else if (data.containsKey("json_object")) {
        ManualPlaceOrderResponse response =
            ManualPlaceOrderResponse.fromJson(jsonData);
        if (response != null &&
            response.data != null &&
            response.data.jsonObject != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return ManualPayment(
                manualPlaceOrderResponse: response,
              );
            }),
          ).then(
            (value) {
              if (value != null && value is bool) {
                if (value) {
                  Navigator.of(context).pop(value);
                } else {
                  ToastUtil.show(getString('checkout_summary_payment_error'));
                }
              }
            },
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (!(e is AppException)) {
        ToastUtil.show(
          getString('checkout_summary_place_order_error'),
        );
      }
    }
  }

  Widget buildButton({
    VoidCallback onPressCallback,
    Color backgroundColor,
    String title,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          onPressed: onPressCallback,
          color: backgroundColor,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildShippingMethod(OrderDetails orderDetails) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            getString('shipping_method'),
            style: TextStyle(
              color: Color(0xFF282828),
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 4.0,
            ),
            child: Text(
              orderDetails.shippingMethodName,
              style: TextStyle(
                color: Color(0xFF414B5A),
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            "${orderDetails.shippingCharge} ${orderDetails.currencyCode}",
            style: TextStyle(
              color: Color(0xFF414B5A),
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Padding buildCostSection(
    String title,
    String subtitle, {
    bool isRed = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: isRed ? kRedTextColor : Colors.black.withOpacity(0.5),
              fontSize: isRed ? 18.0 : 14.0,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Center buildErrorBody(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 4,
        ),
      ),
    );
  }

  Widget buildOrderList(OrderDetails orderDetails) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                initiallyExpanded: true,
                tilePadding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 20.0,
                ),
                children: <Widget>[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: orderDetails.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FutureBuilder(
                        future: NetworkHelper.on().getSingleProduct(
                          context,
                          orderDetails.items[index].productId.toString(),
                        ),
                        builder: (context,
                            AsyncSnapshot<SingleProductResponse> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data.status != null &&
                              snapshot.data.status == 200 &&
                              snapshot.data.data.jsonObject != null) {
                            Product product = snapshot.data.data.jsonObject;

                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kWhiteColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: buildLinearItemBody(
                                    orderDetails.items[index],
                                    orderDetails.currencyCode,
                                    product,
                                  ),
                                ),
                              ),
                            );
                          }

                          return SizedBox.shrink();
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 0.0,
                      );
                    },
                  ),
                ],
                title: Text(
                  getString('item_list'),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            buildCostSection(
              getString('cart_subtotal'),
              "${orderDetails.netTotal} ${orderDetails.currencyCode}",
            ),
            buildCostSection(
              getString('cart_tax'),
              "${orderDetails.taxTotal} ${orderDetails.currencyCode}",
            ),
            buildCostSection(
              getString('cart_discount'),
              "${orderDetails.discount} ${orderDetails.currencyCode}",
            ),
            buildCostSection(
              getString('total'),
              "${orderDetails.grossTotal} ${orderDetails.currencyCode}",
              isRed: true,
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget buildLinearItemBody(
      OrderedItem item, String currency, Product product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              productId: product.id.toString(),
            ),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    color: Color(0xFF282828),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  "${item.price}${currency != null ? (kSpaceString + currency) : kDefaultString}",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethodSection(BuildContext context, String orderId) {
    return FutureBuilder(
      future: NetworkHelper.on().getAbandonedPaymentMethods(context, orderId),
      builder: (
        context,
        AsyncSnapshot<PaymentMethodListResponse> snapshot,
      ) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data.status != null &&
            snapshot.data.status == 200) {
          if (paymentMethodList.isEmpty) {
            paymentMethodList.addAll(snapshot.data.data.jsonArray);
          }

          if (paymentMethodList.isEmpty) {
            return buildEmptyPlaceholder();
          } else {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: paymentMethodList.length,
              itemBuilder: (BuildContext context, int index) {
                PaymentMethod item = paymentMethodList[index];

                if (index == 0) {
                  paymentMethodList[selectedPaymentMethod].isSelected = true;
                }

                return InkWell(
                  onTap: () {
                    if (this.mounted) {
                      this.setState(() {
                        paymentMethodList[selectedPaymentMethod].isSelected =
                            false;
                        selectedPaymentMethod = index;
                        paymentMethodList[selectedPaymentMethod].isSelected =
                            true;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF3B04DB).withOpacity(0.07),
                      border: Border(
                        top: BorderSide(color: kDividerColor),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: ListTile(
                      title: Text(
                        item.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          //item.description ?? kDefaultString,
                          WebUtil.removeHtmlTags(
                              stringWithHtmlTags:
                                  item.description ?? kDefaultString),
                          style: TextStyle(
                            color: Colors.black.withOpacity(.5),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      trailing: Radio(
                        activeColor: Color(0xFF24C030),
                        value: item.isSelected ? 1 : 0,
                        groupValue: 1,
                        onChanged: (value) {
                          if (this.mounted) {
                            this.setState(() {
                              paymentMethodList[selectedPaymentMethod]
                                  .isSelected = false;
                              selectedPaymentMethod = index;
                              paymentMethodList[selectedPaymentMethod]
                                  .isSelected = true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          String errorMessage = getString('something_went_wrong');

          if (snapshot.hasError &&
              snapshot.error is AppException &&
              snapshot.error.toString().trim().isNotEmpty) {
            errorMessage = snapshot.error.toString().trim();
          }

          return buildErrorBody(errorMessage);
        }

        return SizedBox.shrink();
      },
    );
  }

  Widget buildEmptyPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          getString('no_item_found'),
          style: TextStyle(
            color: kRegularTextColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  String getString(String key) {
    return AppLocalizations.of(context).getString(key);
  }
}
