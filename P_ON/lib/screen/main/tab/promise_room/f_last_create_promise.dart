// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:fast_app_base/common/constant/app_colors.dart';
import 'package:fast_app_base/common/widget/w_basic_appbar.dart';
import 'package:fast_app_base/screen/main/tab/promise_room/f_search_naver.dart';
import 'package:fast_app_base/screen/main/tab/promise_room/vo_naver_headers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:nav/nav.dart';
import 'package:velocity_x/velocity_x.dart';

class LastCreatePromise extends StatefulWidget {
  const LastCreatePromise({super.key});

  @override
  State<LastCreatePromise> createState() => _LastCreatePromiseState();
}

class _LastCreatePromiseState extends State<LastCreatePromise> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  final FocusNode dateNode = FocusNode();
  final FocusNode timeNode = FocusNode();
  final FocusNode placeNode = FocusNode();

  Future<void> _selectDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.mainBlue2,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.mainBlue
                ),
              )
          ), child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay t = TimeOfDay.now();
    Navigator.of(context).push(
        showPicker(
            context: context,
            value: Time(hour: t.hour, minute: t.minute),
            onChange: (TimeOfDay time) {
              final period = time.period == DayPeriod.am ? '오전' : '오후';
              timeController.text = '$period ${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')}';
            },
            minuteInterval: TimePickerInterval.FIVE,
            iosStylePicker: true,
            okText: '확인',
            okStyle: TextStyle(color: AppColors.mainBlue2),
            cancelText: '취소',
            cancelStyle: TextStyle(color: AppColors.mainBlue2),
            hourLabel: '시',
            minuteLabel: '분',
            accentColor: AppColors.mainBlue2
        )
    );
  }

  void _searchPlace() {
    Nav.push(SearchNaver());
  }

  bool get isFilled =>
      dateController.text.isNotEmpty &&
          timeController.text.isNotEmpty &&
          placeController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dateController.addListener(updateState);
    timeController.addListener(updateState);
    placeController.addListener(updateState);
    dateNode.addListener(updateState);
    timeNode.addListener(updateState);
    placeNode.addListener(updateState);
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const BasicAppBar(
                  text: '약속 생성', isProgressBar: true, percentage: 100),
              _buildTextField('날짜', dateController, dateNode, timeNode),
              _buildTextField('시간', timeController, timeNode, placeNode),
              _buildTextField('장소', placeController, placeNode, null),
            ],
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            width: double.infinity,
            height: 48,
            margin: const EdgeInsets.all(14),
            child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                    backgroundColor: isFilled ? AppColors.mainBlue : Colors
                        .grey),
                child: Text(isFilled ? '다음' : '건너뛰기')),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      FocusNode node, FocusNode? nextNode) {
    final dio = Dio();
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          alignment: Alignment.topLeft,
          child: Text(label, style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: controller.text.isEmpty && !node.hasFocus
                  ? Colors.grey
                  : AppColors.mainBlue2,
            ),
          ),
          child: TextField(

            showCursor: label == '장소',
            focusNode: node,
            controller: controller,
            decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
            onTap: () async {
              if (label == '날짜') await _selectDate();
              if (label == '시간') await _selectTime();
              if (label == '장소') _searchPlace();
            },
          ),
        ),
      ],
    );
  }

  void SearchPlace(String text) async {
    final dio = Dio();
    final response = await dio.get(
      'https://openapi.naver.com/v1/search/local.json?',
      queryParameters: {
        'query': text,
      },
      options: Options(
        headers: {
          'X-Naver-Client-Id': Client_ID,
          'X-Naver-Client-Secret': Client_Secret,
        },
      ),
    );
    print(text);
    print("=======================");
    print("=======================");
    print("=======================");
    print("=======================");
    print(response);
    print("=======================");
    print("=======================");
    print("=======================");
    print("=======================");
  }
}


