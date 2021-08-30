import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:azzoa_grocery/app_localization.dart';
import 'package:azzoa_grocery/base/exception/app_exception.dart';
import 'package:azzoa_grocery/constants.dart';
import 'package:azzoa_grocery/data/local/model/AttributeColorsModel.dart';
import 'package:azzoa_grocery/data/local/model/app_config_provider.dart';
import 'package:azzoa_grocery/data/local/service/database_service.dart';
import 'package:azzoa_grocery/data/remote/model/app_info.dart';
import 'package:azzoa_grocery/data/remote/response/config_response.dart';
import 'package:azzoa_grocery/data/remote/service/api_service.dart';
import 'package:azzoa_grocery/localization/app_language.dart';
import 'package:azzoa_grocery/ui/auth/login/login.dart';
import 'package:azzoa_grocery/ui/auth/preference/preference.dart';
import 'package:azzoa_grocery/ui/container/home/homepage.dart';
import 'package:azzoa_grocery/util/helper/color.dart';
import 'package:azzoa_grocery/util/helper/permission_service.dart';
import 'package:azzoa_grocery/util/lib/shared_preference.dart';
import 'package:azzoa_grocery/util/lib/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isLoading, hasError;
  String error;
  String appLogo, appName;
  AppConfig appConfig;
  AppConfigNotifier appConfigNotifier;
  AppThemeAndLanguage themeAndLanguage;
  AnimationController _controller;
  void goToNextPage() async {
    bool isLoggedIn = await SharedPrefUtil.getBoolean(kKeyIsLoggedIn);
    appConfigNotifier.setAppConfig(this.appConfig);

    if (appConfigNotifier.appConfig.color.colorPrimary.isEmpty ||
        appConfigNotifier.appConfig.color.colorAccent.isEmpty ||
        appConfigNotifier.appConfig.color.buttonColor_1.isEmpty ||
        appConfigNotifier.appConfig.color.buttonColor_2.isEmpty) {
      ToastUtil.show(getString('please_set_appconfig'));
    }

    themeAndLanguage.setThemeData(
      ThemeData(
        backgroundColor: kCommonBackgroundColor,
        primaryColor: ColorUtil.hexToColor(
          appConfigNotifier.appConfig.color.colorPrimary,
        ),
        accentColor: ColorUtil.hexToColor(
          appConfigNotifier.appConfig.color.colorAccent,
        ),
        buttonColor: ColorUtil.hexToColor(
          appConfigNotifier.appConfig.color.colorAccent,
        ),
        fontFamily: 'Roboto',
      ),
    );

    if (this.context != null) {
      if (!(await SharedPrefUtil.contains(kKeyCurrency)) ||
          (await SharedPrefUtil.getString(kKeyCurrency)).isEmpty ||
          !(await SharedPrefUtil.contains(kKeyLanguage)) ||
          (await SharedPrefUtil.getString(kKeyLanguage)).isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SetPreferencePage(),
          ),
        );
      } else {
        if (!isLoggedIn) {
          String currencyCode = await SharedPrefUtil.getString(kKeyCurrency);
          String language = await SharedPrefUtil.getString(kKeyLanguage);

          await SharedPrefUtil.clear().then((value) async {
            await DatabaseService.on().clearDatabase();

            await SharedPrefUtil.writeString(
              kKeyCurrency,
              currencyCode,
            );

            await SharedPrefUtil.writeString(
              kKeyLanguage,
              language,
            );
          });
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    }
  }

  Future _checkAndGetLocation() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        ToastUtil.show(getString('enable_your_gps'));
      }
    } else {
      if (await PermissionService.instance.hasLocationPermission() ||
          await PermissionService.instance.requestLocationPermission()) {
        Position lastKnownPosition = await Geolocator.getLastKnownPosition();

        if (lastKnownPosition != null) {
          appConfigNotifier.setCurrentLocation(lastKnownPosition);
        } else {
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
              .then(
            (Position position) {
              appConfigNotifier.setCurrentLocation(position);
            },
          ).catchError(
            (e) {
              ToastUtil.show(getString('fetch_location_error'));
            },
          );
        }
      } else {
        ToastUtil.show(getString('fetch_location_error'));
      }
    }
  }

  @override
  void initState() {
    isLoading = false;
    hasError = false;
    error = kDefaultString;
    appLogo = kDefaultString;
    appName = kDefaultString;
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    super.initState();
  }

  Future<void> _getAppConfig({bool loadNeeded = false}) async {
    try {
      if (this.mounted && loadNeeded) {
        setState(() {
          isLoading = true;
        });
      }

      ConfigResponse response = await NetworkHelper.on().getAppConfig(context);
      print(response);
      if (response != null) {
        this.appConfig = response.appConfig;

        if (this.mounted) {
          setState(() {
            appLogo = appConfig.logo;
            appName = appConfig.name;
            hasError = false;

            if (loadNeeded) {
              isLoading = false;
            }
          });
        }

        Timer(
          Duration(seconds: 4),
          goToNextPage,
        );
      } else {
        if (this.mounted) {
          setState(() {
            hasError = true;

            if (loadNeeded) {
              isLoading = false;
            }
          });
        }

        error = getString('could_not_load_app_config');
      }
    } catch (e) {
      print(e);
      setState(() {
        hasError = true;

        if (loadNeeded) {
          isLoading = false;
        }
      });

      if (!(e is AppException)) {
        error = getString('could_not_load_app_config');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appConfigNotifier = Provider.of<AppConfigNotifier>(
      context,
      listen: false,
    );
    themeAndLanguage = Provider.of<AppThemeAndLanguage>(
      context,
      listen: false,
    );
    _checkAndGetLocation();
    _getAppConfig();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          //color: Colors.green[200],
          image: DecorationImage(
            image: AssetImage('images/ic_splash_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (hasError
                ? buildErrorBody(error)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      appLogo.isEmpty
                          ? Container()
                          : AnimatedBuilder(
                              child: Image.network(
                                appLogo,
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill,
                              ),
                              animation: _controller,
                              builder: (BuildContext context, Widget child) {
                                return Transform.scale(
                                  scale: _controller.value * 0.3 * math.pi,
                                  child: child,
                                );
                              })
                    ],
                  )),
      ),
    );
  }

  Widget buildErrorBody(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: kRegularTextColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.left,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String getString(String key) {
    return AppLocalizations.of(context).getString(key);
  }
}
