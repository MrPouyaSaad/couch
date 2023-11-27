// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

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
        body: ListView.builder(
          itemCount: 3,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Header();
            } else
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Text('${index - 1}'),
                        Column(
                          children: [
                            Row(
                              children: [
                                DropdownMenu(
                                  label: Text('نام حرکت'),
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry(
                                        value: 0, label: 'بالاسینه'),
                                    DropdownMenuEntry(
                                        value: 1, label: 'بالاسینه'),
                                    DropdownMenuEntry(
                                        value: 2, label: 'بالاسینه'),
                                    DropdownMenuEntry(
                                        value: 3, label: 'بالاسینه'),
                                    DropdownMenuEntry(
                                        value: 4, label: 'بالاسینه'),
                                    DropdownMenuEntry(
                                        value: 5, label: 'بالاسینه'),
                                  ],
                                ),
                                SizedBox(width: 12),
                                CountOfExercise(),
                              ],
                            ),
                            Text('+'),
                            Row(
                              children: [
                                SizedBox(width: 8),
                                DropdownMenu(
                                    label: Text('نام حرکت'),
                                    dropdownMenuEntries: [
                                      DropdownMenuEntry(
                                          value: 0, label: 'بالاسینه'),
                                      DropdownMenuEntry(
                                          value: 1, label: 'بالاسینه'),
                                      DropdownMenuEntry(
                                          value: 2, label: 'بالاسینه'),
                                      DropdownMenuEntry(
                                          value: 3, label: 'بالاسینه'),
                                      DropdownMenuEntry(
                                          value: 4, label: 'بالاسینه'),
                                      DropdownMenuEntry(
                                          value: 5, label: 'بالاسینه'),
                                    ]),
                                SizedBox(width: 24),
                                Text('تعداد'),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.image),
                        Spacer(),
                        Icon(Icons.image),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              );
          },
        ),
      ),
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
