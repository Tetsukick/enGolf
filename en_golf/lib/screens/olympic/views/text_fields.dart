import 'dart:core';

import 'package:engolf/common/color_config.dart';
import 'package:engolf/common/size_config.dart';
import 'package:engolf/common/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

const _textFieldIconSize = 28.0;

class IconStreamTextField extends StatelessWidget {
  String? icon;
  String? labelTitle;
  Stream<int>? stream;
  Function(int)? function;
  FocusNode? node;

  IconStreamTextField([this.icon, this.labelTitle, this.stream, this.function, this.node]);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          color: ColorConfig.bgDarkGreen,
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.smallMargin)
          )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: (size.width - SizeConfig.mediumLargeMargin * 2) / 2,
      child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            final _controller = TextEditingController.fromValue(
              TextEditingValue(
                text: snapshot.data?.toString() ?? '',
                selection: TextSelection.collapsed(
                    offset: snapshot.data?.toString().length ?? 0,),
              ),
            );
            return Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(SizeConfig.smallestMargin),
                  child: Image.asset(icon!, width: _textFieldIconSize,),
                ),
                SizedBox(width: SizeConfig.smallMargin),
                Expanded(
                  child: TextFormField(
                    focusNode: node,
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: labelTitle,
                      hintStyle: const TextStyle(color: ColorConfig.textGreenDark),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: ColorConfig.textGreenLight),
                    onChanged: (text) {
                      try {
                        final value = int.parse(text);
                        function!(value);
                      }
                      on Exception catch(e) {
                        print(e);
                      }
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class EditableIconIntTextField extends StatelessWidget {
  String? icon;
  String? labelTitle;
  int initialValue;
  Function(int)? function;
  FocusNode? node;

  EditableIconIntTextField({
    this.icon,
    this.labelTitle,
    required this.initialValue,
    this.function,
    this.node
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _controller = TextEditingController.fromValue(
      TextEditingValue(
        text: initialValue.toString(),
        selection: TextSelection.collapsed(
          offset: initialValue.toString().length ?? 0,
        ),
      ),
    );
    return Container(
      decoration: const BoxDecoration(
          color: ColorConfig.bgDarkGreen,
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.smallMargin)
          )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: (size.width - SizeConfig.mediumLargeMargin * 2) / 2,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(SizeConfig.smallestMargin),
            child: Image.asset(icon!, width: _textFieldIconSize,),
          ),
          SizedBox(width: SizeConfig.smallMargin),
          Expanded(
            child: TextFormField(
              focusNode: node,
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: labelTitle,
                hintStyle: const TextStyle(color: ColorConfig.textGreenDark),
              ),
              style: const TextStyle(color: ColorConfig.textGreenLight),
              onChanged: (text) {
                try {
                  final value = int.parse(text);
                  function!(value);
                }
                on Exception catch(e) {
                  print(e);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class IconTextField extends StatelessWidget {
  String? icon;
  String? labelTitle;
  Stream<String>? stream;
  Function(String)? function;

  IconTextField([this.icon, this.labelTitle, this.stream, this.function]);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          color: ColorConfig.bgDarkGreen,
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.smallMargin)
          )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: size.width - SizeConfig.mediumMargin,
      child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            final _controller = TextEditingController.fromValue(
              TextEditingValue(
                text: snapshot.data?.toString() ?? '',
              ),
            );
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(SizeConfig.smallestMargin),
                  child: Image.asset(icon!, width: _textFieldIconSize,),
                ),
                const SizedBox(width: SizeConfig.smallMargin),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: labelTitle,
                      hintStyle: const TextStyle(color: ColorConfig.textGreenDark),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: ColorConfig.textGreenLight),
                    onEditingComplete: () {
                      print(_controller.text);
                      function!(_controller.text);
                    },
                    onFieldSubmitted: (text) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class EditableIconTextField extends StatelessWidget {
  String? icon;
  String? labelTitle;
  String? initialValue;
  Function(String)? function;

  EditableIconTextField([this.icon, this.labelTitle, this.initialValue, this.function]);

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController(text: initialValue);
    _controller.addListener(() {
      function!(_controller.text);
    });
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          color: ColorConfig.bgDarkGreen,
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.smallMargin)
          )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: size.width - SizeConfig.mediumMargin,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(SizeConfig.smallestMargin),
            child: Image.asset(icon!, width: _textFieldIconSize,),
          ),
          const SizedBox(width: SizeConfig.smallMargin),
          Expanded(
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: labelTitle,
                hintStyle: const TextStyle(color: ColorConfig.textGreenDark),
              ),
              style: const TextStyle(color: ColorConfig.textGreenLight),
              onEditingComplete: () {
                function!(_controller.text);
              },
              onFieldSubmitted: (text) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class IconTextFieldDate extends StatelessWidget {
  String icon;
  String? labelTitle;
  Stream<DateTime>? stream;
  Function(DateTime) function;

  IconTextFieldDate({
    required this.icon,
    this.labelTitle,
    this.stream,
    required this.function});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          color: ColorConfig.bgDarkGreen,
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.smallMargin)
          )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: size.width - SizeConfig.mediumMargin,
      child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            final data = snapshot.data == null
                ? DateTime.now() : (snapshot.data as DateTime?)!;
            final _controller = TextEditingController.fromValue(
              TextEditingValue(
                text: dateTimeToString(data) ?? '',
              ),
            );
            return Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(SizeConfig.smallestMargin),
                  child: Image.asset(icon, width: _textFieldIconSize,),
                ),
                SizedBox(width: SizeConfig.smallMargin),
                Expanded(
                  child: TextFormField(
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: labelTitle,
                      hintStyle: const TextStyle(color: ColorConfig.textGreenDark),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: ColorConfig.textGreenLight),
                    onTap: () {
                      final now = DateTime.now();
                      showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: DateTime(2019, 1),
                        lastDate: DateTime(now.year + 3, 12),
                      ).then((pickedDate) {
                        function(pickedDate!);
                      });
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class EditableIconTextFieldDate extends StatelessWidget {
  String icon;
  String? labelTitle;
  DateTime initialDateTime;
  Function(DateTime) function;

  EditableIconTextFieldDate({
    required this.icon,
    this.labelTitle,
    required this.initialDateTime,
    required this.function});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _controller = TextEditingController.fromValue(
      TextEditingValue(
        text: dateTimeToString(initialDateTime) ?? '',
      ),
    );
    return Container(
      decoration: const BoxDecoration(
          color: ColorConfig.bgDarkGreen,
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.smallMargin)
          )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: size.width - SizeConfig.mediumMargin,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(SizeConfig.smallestMargin),
            child: Image.asset(icon, width: _textFieldIconSize,),
          ),
          SizedBox(width: SizeConfig.smallMargin),
          Expanded(
            child: TextFormField(
              focusNode: AlwaysDisabledFocusNode(),
              controller: _controller,
              decoration: InputDecoration(
                hintText: labelTitle,
                hintStyle: const TextStyle(color: ColorConfig.textGreenDark),
              ),
              style: const TextStyle(color: ColorConfig.textGreenLight),
              onTap: () {
                final now = DateTime.now();
                showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: DateTime(2019, 1),
                  lastDate: DateTime(now.year + 3, 12),
                ).then((pickedDate) {
                  function(pickedDate!);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}