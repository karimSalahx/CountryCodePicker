import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final countryCode =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode;
    log(countryCode.toString());
    return MaterialApp(
      supportedLocales: const [
        Locale("en"),
      ],
      localizationsDelegates: const [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: const Text('CountryPicker Example'),
        ),
        body: Center(
          child: CountryCodePicker(
            barrierColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            dialogBackgroundColor: Colors.transparent,
            initialSelection: countryCode,
            onChanged: print,
            showFlagDialog: false,
            onInit: (value) => log('Country code is ${value.toString()}'),
          ),
        ),
      ),
    );
  }
}
