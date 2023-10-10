import 'package:admin_alex_uni/constants.dart';
import 'package:admin_alex_uni/cubit/app_cubit.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

var phoneController=TextEditingController();

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UpdateUserDataSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        phoneController.text = AppCubit.get(context).adminModel!.phone!;

        return Scaffold(
          appBar: AppBar(
            title: Text(lang == 'en' ? 'Settings' : 'الاعدادات'),
            actions: [
              IconButton(
                onPressed: () async {

                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  reusableTextFormField(
                      label: lang == 'en' ? 'Phone' : 'الهاتف',
                      onTap: (){},
                      controller: phoneController,
                      keyboardType: TextInputType.number
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        lang == 'en' ? 'Review Posts' : 'مراجعة المنشورات',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      FlutterSwitch(
                        showOnOff: true,
                        activeText: 'on',
                        inactiveText: 'off',
                        value: AppCubit.get(context).adminModel!.reviewPosts!?true:false,
                        onToggle: (val) {
                          AppCubit.get(context).toggleReviewButton(val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        lang == 'en' ? 'Available' : 'متاح',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      FlutterSwitch(
                        showOnOff: true,
                        activeText: 'on',
                        inactiveText: 'off',
                        value: AppCubit.get(context).adminModel!.isAvailable!?true:false,
                        onToggle: (val) {
                          AppCubit.get(context).toggleAvailableButton(val);
                        },
                      ),
                    ],
                  ),
                 const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        lang == 'en' ? 'Language' : 'اللغه',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff0D3961),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: DropdownButton<Locale>(
                          autofocus: true,
                          value: lang == 'en'
                              ? const Locale('en')
                              : const Locale('ar'),
                          onChanged: (newLocale) {
                            // Change app language instantly
                            cubit.changeAppLanguage(
                              context: context,
                              newLocale: newLocale,
                            );
                          },
                          items: const [
                            DropdownMenuItem(
                              value: Locale('en'),
                              child: Text('English'),
                            ),
                            DropdownMenuItem(
                              value: Locale('ar'),
                              child: Text('العربية'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
