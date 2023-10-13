import 'dart:developer';

import 'package:flutter/material.dart';

import 'country_code.dart';
import 'country_localizations.dart';

/// selection dialog used for selection of the country code
class SelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;
  final bool? showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle? searchStyle;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final WidgetBuilder? emptySearchBuilder;
  final bool? showFlag;
  final double flagWidth;
  final Decoration? flagDecoration;
  final Size? size;
  final bool hideSearch;
  final Icon? closeIcon;

  /// Background color of SelectionDialog
  final Color? backgroundColor;

  /// Boxshaow color of SelectionDialog that matches CountryCodePicker barrier color
  final Color? barrierColor;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  SelectionDialog(
    this.elements,
    this.favoriteElements, {
    Key? key,
    this.showCountryOnly,
    this.emptySearchBuilder,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.textStyle,
    this.boxDecoration,
    this.showFlag,
    this.flagDecoration,
    this.flagWidth = 32,
    this.size,
    this.backgroundColor,
    this.barrierColor,
    this.hideSearch = false,
    this.closeIcon,
  })  : searchDecoration = searchDecoration.prefixIcon == null
            ? searchDecoration.copyWith(prefixIcon: const Icon(Icons.search))
            : searchDecoration,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  /// this is useful for filtering purpose
  late List<CountryCode> filteredElements;
  String characterToShow = '';

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.size?.width ?? MediaQuery.of(context).size.width,
        height: widget.size?.height ?? MediaQuery.of(context).size.height * .8,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 45),
                Container(
                  transform: Matrix4.translationValues(0, 10, 0),
                  child: const Text(
                    'Select your country code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF434343),
                      fontSize: 18,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w500,
                      height: 0.07,
                      letterSpacing: 0.90,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 17,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 33),
            Expanded(
              child: ListView.builder(
                itemCount: filteredElements.length,
                itemBuilder: (context, index) {
                  final e = filteredElements[index];
                  bool shouldShowCharacter = _shouldShowCharacterFun(index);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (shouldShowCharacter) _displayLetter(characterToShow),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 24.0,
                              ),
                              child: GestureDetector(
                                child: _buildOption(e),
                                onTap: () => _selectItem(e),
                              ),
                            ),
                            const Divider(
                              endIndent: 40,
                              indent: 25,
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );

  bool _shouldShowCharacterFun(int index) {
    String firstCharacter = _getFirstCharacter(filteredElements[index].name!);
    if (firstCharacter != characterToShow) {
      characterToShow = firstCharacter;
      return true;
    }
    return false;
  }

  String _getFirstCharacter(String name) {
    return name
        .replaceAll(RegExp(r'[[\]]'), '')
        .split(',')
        .first[0]
        .toUpperCase();
  }

  Widget _displayLetter(String letter) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13, top: 13, left: 27),
      child: Text(
        letter,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF979797),
          fontSize: 16,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          height: 0.08,
        ),
      ),
    );
  }

  Widget _buildOption(CountryCode e) {
    return SizedBox(
      width: 400,
      child: Text(
        widget.showCountryOnly! ? e.toCountryStringOnly() : e.toLongString(),
        style: const TextStyle(
          color: Color(0xFF434343),
          fontSize: 18,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder!(context);
    }

    return Center(
      child: Text(CountryLocalizations.of(context)?.translate('no_country') ??
          'No country found'),
    );
  }

  @override
  void initState() {
    filteredElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      filteredElements = widget.elements
          .where((e) =>
              e.code!.contains(s) ||
              e.dialCode!.contains(s) ||
              e.name!.toUpperCase().contains(s))
          .toList();
    });
  }

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
