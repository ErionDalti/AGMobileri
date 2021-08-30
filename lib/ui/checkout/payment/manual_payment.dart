import 'dart:convert';
import 'dart:io';

import 'package:azzoa_grocery/data/remote/model/manual_order_place_response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../app_localization.dart';
import '../../../base/exception/app_exception.dart';
import '../../../constants.dart';
import '../../../data/local/model/app_config_provider.dart';
import '../../../data/remote/service/api_service.dart';
import '../../../util/helper/color.dart';
import '../../../util/lib/toast.dart';

class ManualPayment extends StatefulWidget {
  final ManualPlaceOrderResponse manualPlaceOrderResponse;

  const ManualPayment({Key key, this.manualPlaceOrderResponse})
      : super(key: key);

  @override
  _ManualPaymentState createState() => _ManualPaymentState();
}

class _ManualPaymentState extends State<ManualPayment> {
  File _directoryPath;
  String _category = "NONE";
  AppConfigNotifier appConfigNotifier;

  TextEditingController addressController;
  bool isLoading = false;

  String _message = "";
  String _path = "";
  String _size = "";
  String _mimeType = "";
  File _imageFile;
  int _progress = 0;

  @override
  void dispose() {
    addressController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    addressController = TextEditingController();
    ImageDownloader.callback(onProgressUpdate: (String imageId, int progress) {
      setState(() {
        _progress = progress;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const String _successfulPaymentUrlPrefix = kBaseUrl + "payment-success/";
    const String _failedPaymentUrlPrefix = kBaseUrl + "payment-failed/";
    List<String> accountTypes = ["NONE", "Saving", "Current"];

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
            getString('payment_title'),
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    buildTextFormField(
                      controller: addressController,
                      hint: getString('address'),
                      inputType: TextInputType.multiline,
                      maxLength: 5,
                      icon: Icon(
                        Icons.text_fields,
                        color: Color(0xFF02AEFF),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    /*     Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 2.0, 32.0, 2.0),
                child: Card(
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Account type",
                          style: TextStyle(
                            color: kRegularTextColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        DropdownButton<String>(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                          items: accountTypes.map((String dropdownItem) {
                            return DropdownMenuItem<String>(
                              value: dropdownItem,
                              child: Container(
                                width: 190,
                                child: Text(
                                  dropdownItem,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String newlySelectedValue) {
                            setState(() {
                              _category = newlySelectedValue;
                            });
                          },
                          value: _category != null ? _category : null,
                          underline: SizedBox(),
                          isExpanded: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),*/
                    Expanded(
                      child: WebView(
                        debuggingEnabled: false,
                        initialUrl: '',
                        onWebViewCreated: (WebViewController controller) {
                          controller.loadUrl(
                            Uri.dataFromString(
                              widget.manualPlaceOrderResponse.data.jsonObject.paymentMethod.description,
                              mimeType: 'text/html',
                              encoding: Encoding.getByName('utf-8'),
                            ).toString(),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 2.0, 32.0, 2.0),
                      child: Card(
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => _openFileExplorer(),
                                child: const Text("Choose File"),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Text(_directoryPath == null
                                    ? "No file chosen"
                                    : path.basename(_directoryPath.path)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(36.0, 2.0, 32.0, 0.0),
                      child: Text("Only zip file is allowed to upload"),
                    ),
                    Spacer(),
                    buildButton(
                      onPressCallback: () {
                        uploadBankInfo();
                      },
                      backgroundColor: ColorUtil.hexToColor(
                        appConfigNotifier.appConfig.color.colorAccent,
                      ),
                      title: getString('submit'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appConfigNotifier = Provider.of<AppConfigNotifier>(
      context,
      listen: false,
    );
  }

  Widget buildButton({
    VoidCallback onPressCallback,
    Color backgroundColor,
    String title,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
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

  Widget buildTextFormField({
    TextEditingController controller,
    String hint,
    TextInputType inputType,
    int maxLength,
    Icon icon,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 2.0, 32.0, 2.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 0.0,
          ),
          child: TextFormField(
            obscureText: inputType == TextInputType.visiblePassword,
            style: TextStyle(
              color: kSecondaryTextColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              hintStyle: TextStyle(
                color: kSecondaryTextColor,
              ),
              hintText: hint,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              suffixIcon: icon != null ? icon : SizedBox.shrink(),
            ),
            controller: controller,
          ),
        ),
      ),
    );
  }

  void _openFileExplorer() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip','jpg', 'pdf', 'doc'],
      );

      if(result != null) {
        _directoryPath = File(result.files.single.path);
      } else {
        // User canceled the picker
      }

      setState(() {});

      print(_directoryPath);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {});
  }

  // ignore: missing_return
  bool validateUserData() {
    if (addressController.text.trim().isEmpty) {
      ToastUtil.show(getString('please_fill_up_all_the_fields'));
      return false;
    } else {
      return true;
    }
  }

  void uploadBankInfo() async {
    if (validateUserData()) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = await NetworkHelper.on().uploadBankInformation(
            context,
            widget.manualPlaceOrderResponse.data.jsonObject.order.id.toString(),
            widget.manualPlaceOrderResponse.data.jsonObject.paymentMethod.id
                .toString(),
            widget.manualPlaceOrderResponse.data.jsonObject.paymentMethod.inputs
                .first.id,
            addressController.text.toString(),
            widget.manualPlaceOrderResponse.data.jsonObject.paymentMethod.inputs
                .last.id,
            _directoryPath);

        if (this.mounted) {
          setState(() {
            isLoading = false;
          });
        }

        if (response != null &&
            int.parse(response['status'].toString()) == 201) {
          //ToastUtil.show(getString('edit_profile_update_successful'));

          Navigator.of(context).pop(true);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });

        if (!(e is AppException)) {
          ToastUtil.show(getString('checkout_summary_payment_error'));
        }
      }
    }
  }

  String getString(String key) {
    return AppLocalizations.of(context).getString(key);
  }

  Future<void> _downloadImage(String url, {AndroidDestinationType destination, bool whenError = false}) async {
    String fileName;
    String path;
    int size;
    String mimeType;
    try {
      String imageId;

      if (whenError) {
        imageId = await ImageDownloader.downloadImage(url).catchError((error) {
          if (error is PlatformException) {
            var path = "";
            if (error.code == "404") {
              print("Not Found Error.");
            } else if (error.code == "unsupported_file") {
              print("UnSupported FIle Error.");
              path = error.details["unsupported_file_path"];
            }
            setState(() {
              _message = error.toString();
              _path = path;
            });
          }

          print(error);
        }).timeout(Duration(seconds: 10), onTimeout: () {
          print("timeout");
        });
      } else {
        if (destination == null) {
          imageId = await ImageDownloader.downloadImage(url);
        } else {
          imageId = await ImageDownloader.downloadImage(
            url,
            destination: destination,
          );
        }
      }

      if (imageId == null) {
        return;
      }
      fileName = await ImageDownloader.findName(imageId);
      path = await ImageDownloader.findPath(imageId);
      size = await ImageDownloader.findByteSize(imageId);
      mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      setState(() {
        _message = error.message;
      });
      return;
    }

    if (!mounted) return;

    setState(() {
      var location = Platform.isAndroid ? "Directory" : "Photo Library";
      _message = 'Saved as "$fileName" in $location.\n';
      _size = 'size:     $size';
      _mimeType = 'mimeType: $mimeType';
      _path = path;

      if (!_mimeType.contains("video")) {
        _imageFile = File(path);
      }
    });
  }
}
