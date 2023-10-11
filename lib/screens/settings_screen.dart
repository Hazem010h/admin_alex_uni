import 'package:admin_alex_uni/constants.dart';
import 'package:admin_alex_uni/cubit/app_cubit.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController phoneController = TextEditingController();
  bool value = false;
  bool available = false;

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getSettings();
    phoneController.text = AppCubit.get(context).adminModel!.phone!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UpdateUserDataSuccessState) {
          Navigator.pop(context);
        }
        if (state is GetSettingsSuccessState) {
          value = AppCubit.get(context).settings!.reviewPosts!;
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(lang == 'en' ? 'Settings' : 'الاعدادات'),
            actions: [
              IconButton(
                onPressed: () async {
                  if (phoneController.text.isNotEmpty) {
                    cubit.updateUserData(
                      phone: phoneController.text,
                      available: available,
                    );
                    cubit.updateSettings(reviewPosts: value);
                    await cubit.changeAppLanguage(
                      context: context,
                      newLocale: lang == 'en'
                          ? const Locale('ar')
                          : const Locale('en'),
                    );
                  }
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
                    onTap: () {},
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
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
                      Switch(
                          value: value,
                          onChanged: (val) {
                            setState(
                              () {
                                value = val;
                              },
                            );
                          }),
                      FlutterSwitch(
                        showOnOff: true,
                        activeText: 'on',
                        inactiveText: 'off',
                        value: value,
                        onToggle: (val) {
                          setState(() {
                            value = val;
                          });
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
                        value: available,
                        onToggle: (val) {
                          setState(() {
                            available = val;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
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
