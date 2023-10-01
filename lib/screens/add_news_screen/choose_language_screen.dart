import 'package:admin_alex_uni/constants.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:admin_alex_uni/screens/add_news_screen/add_arabic_news_screen.dart';
import 'package:admin_alex_uni/screens/add_news_screen/add_both_news_screen.dart';
import 'package:flutter/material.dart';

class ChooseLanguageScreen extends StatelessWidget {
  const ChooseLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang=='en'?'Choose Language':'اختر اللغة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            reusableElevatedButton(
              backColor: defaultColor,
              label:
                  lang == 'en' ? 'Add Arabic News' : 'اضافة خبر باللغة العربية',
              function: () {
                navigateTo(
                  context: context,
                  screen: const AddArabicNewsScreen(),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            reusableElevatedButton(
              backColor: defaultColor,
              label: lang == 'en'
                  ? 'Add Arabic And English News'
                  : 'اضافة خبر باللغة العربية و الانجليزية',
              function: () {
                navigateTo(
                  context: context,
                  screen: const AddBothNewsScreen(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
