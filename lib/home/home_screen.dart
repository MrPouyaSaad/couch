// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:couch/model/exercise.dart';
import 'package:couch/model/list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final pw.Document pdf = pw.Document();

  Future<String> savePdf() async {
    final pw.Document pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello World!'),
          );
        },
      ),
    );

    final Directory? dir = await getDownloadsDirectory();
    final String path = '${dir?.path}/example.pdf';
    final File file = File(path);

    await file.writeAsBytes(await pdf.save());

    return path;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            try {
              final String path = await savePdf();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('PDF saved at $path')),
              );
              // Open the PDF file
              OpenFile.open(path);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
              print(e);
            }
          },
          label: Text('چاپ').marginSymmetric(horizontal: 24, vertical: 12),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: ExerciseList(),
      ),
    );
  }
}

class ExerciseList extends StatefulWidget {
  const ExerciseList({
    super.key,
  });

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  final bazooList = bazoo;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Header();
        } else
          return Column(
            children: [
              ExerciseNumber(index: index),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    AddExerciseItem(exercises: bazooList),
                    Text('+'),
                    AddExerciseItem(exercises: bazooList),
                  ],
                ),
              ),
              if (index == 2) Divider(),
            ],
          );
      },
    );
  }
}

class AddExerciseItem extends StatefulWidget {
  const AddExerciseItem({
    Key? key,
    required this.exercises,
  }) : super(key: key);
  final List<ExerciseModel> exercises;

  @override
  State<AddExerciseItem> createState() => _AddExerciseItemState();
}

class _AddExerciseItemState extends State<AddExerciseItem> {
  final basePath = 'assets/images/';
  bool isSelected = false;
  String imagePath = '';
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomDropdown<ExerciseModel>(
            hintText: 'نام حرکت',
            excludeSelected: false,
            headerBuilder: (context, selectedItem) => Text(
              selectedItem.name,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            listItemBuilder: (context, item) => Text(
              item.name,
              style: TextStyle(fontSize: 12),
            ),
            items: List.generate(
              widget.exercises.length,
              (index) {
                final exercise = widget.exercises[index];
                return exercise;
              },
            ),
            onChanged: (value) {
              setState(() {
                imagePath = value.imagePath;
                isSelected = true;
              });
              log('changing value to: $value');
            },
          ),
        ),
        CountOfExercise(),
        if (isSelected)
          Expanded(
            child: Image.asset(basePath + imagePath),
          ),
      ],
    );
  }
}

class ExerciseNumber extends StatelessWidget {
  const ExerciseNumber({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Divider(),
        CircleAvatar(
          radius: 12,
          child: Text(
            '$index',
          ),
        ),
      ],
    );
  }
}

class CountOfExercise extends StatefulWidget {
  const CountOfExercise({
    super.key,
  });

  @override
  State<CountOfExercise> createState() => _CountOfExerciseState();
}

class _CountOfExerciseState extends State<CountOfExercise> {
  String count = '';
  bool isEmpty = false;
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showCountDialog(context);
      },
      child: Text(
        count == '' ? 'تعداد' : count,
        textDirection: TextDirection.ltr,
        style: TextStyle(letterSpacing: count == '' ? 0 : 2),
      ),
    );
  }

  Future<dynamic> showCountDialog(BuildContext context) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          actionsAlignment: MainAxisAlignment.spaceAround,
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                errorText: isEmpty ? 'نمیتواند خالی باشد!' : null,
                hintText: 'تعداد را وارد کنید',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    count = _controller.text;
                    isEmpty = false;
                  });
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    isEmpty = true;
                    Navigator.of(context).pop();
                    showCountDialog(context);
                  });
                }
              },
              child: Text('تایید'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('لغو'),
            )
          ],
        );
      },
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'برنامه تمرینی',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          'استاد پویا صاد',
          style: TextStyle(
              fontFamily: 'Iran-Nastaliq',
              fontSize: 32,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
