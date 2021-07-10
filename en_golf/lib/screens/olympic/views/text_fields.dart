import 'dart:core';

import 'package:engolf/common/color_config.dart';
import 'package:engolf/common/size_config.dart';
import 'package:engolf/common/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class IconStreamTextField extends StatelessWidget {
  String icon;
  String labelTitle;
  Stream<int> stream;
  Function(int) function;

  IconStreamTextField([this.icon, this.labelTitle, this.stream, this.function]);

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
                text: snapshot?.data?.toString() ?? '',
                selection: TextSelection.collapsed(
                    offset: snapshot?.data?.toString()?.length ?? 0),
              ),
            );
            return Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(SizeConfig.smallMargin),
                  child: SvgPicture.asset(icon),
                ),
                SizedBox(width: SizeConfig.mediumMargin),
                Expanded(
                  child: TextFormField(
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
                        function(value);
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

class IconTextField extends StatelessWidget {
  String icon;
  String labelTitle;
  Stream<String> stream;
  Function(String) function;

  IconTextField([this.icon, this.labelTitle, this.stream, this.function]);

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    _controller.addListener(() {
      function(_controller.text);
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
      child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            return Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(SizeConfig.smallMargin),
                  child: SvgPicture.asset(icon),
                ),
                SizedBox(width: SizeConfig.mediumMargin),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: labelTitle,
                      hintStyle: const TextStyle(color: ColorConfig.textGreenDark),
                    ),
                    style: const TextStyle(color: ColorConfig.textGreenLight),
                    onEditingComplete: () {
                      function(_controller.text);
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class IconTextFieldDate extends StatelessWidget {
  String icon;
  String labelTitle;
  Stream<DateTime> stream;
  Function(DateTime) function;

  IconTextFieldDate([this.icon, this.labelTitle, this.stream, this.function]);

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
            final data = snapshot?.data == null
                ? DateTime.now() : snapshot?.data as DateTime;
            final _controller = TextEditingController.fromValue(
              TextEditingValue(
                text: dateTimeToString(data) ?? '',
              ),
            );
            return Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(SizeConfig.smallMargin),
                  child: SvgPicture.asset(icon),
                ),
                SizedBox(width: SizeConfig.mediumMargin),
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
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2019, 1),
                        lastDate: DateTime(2021, 12),
                      ).then((pickedDate) {
                        function(pickedDate);
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