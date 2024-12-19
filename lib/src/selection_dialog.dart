import 'package:country_code_picker/src/string_extesion.dart';
import 'package:flutter/material.dart';

import 'country_code.dart';

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
  final Color? backgroundColor;
  final Color? barrierColor;
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
  late List<CountryCode> filteredElements;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredElements = widget.elements;
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredElements = widget.elements;
      } else {
        filteredElements = widget.elements
            .where((element) =>
                element.name!.toLowerCase().contains(query.toLowerCase()) ||
                element.code!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

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
            const SizedBox(height: 30),
            if (!widget.hideSearch)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: searchController,
                  decoration: widget.searchDecoration.copyWith(
                    hintText: 'Search country or code', // Add hint text here
                  ),
                  style: widget.searchStyle
                  onChanged: _filterCountries,
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredElements.length,
                itemBuilder: (context, index) {
                  final country = filteredElements[index];
                  return Column(
                    children: [
                      ListTile(
                        title: _buildOption(country),
                        onTap: () => _selectItem(country),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );

  Widget _buildOption(CountryCode e) {
    return Text(
      widget.showCountryOnly!
          ? e.toCountryStringOnly().fixUsCode()
          : e.toLongString().fixUsCode(),
      style: const TextStyle(
        color: Color(0xFF434343),
        fontSize: 18,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
