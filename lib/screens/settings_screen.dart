import 'package:admin_alex_uni/cubit/app_cubit.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController phoneController = TextEditingController();
  String? phone;
  bool value = false;
  bool available = false;

  @override
  void initState() {
    // TODO: implement initState
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
          available = AppCubit.get(context).adminModel!.isAvailable!;
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Setting Screen'),
            actions: [
              IconButton(
                onPressed: () {
                  cubit.updateUserData(phone: phone!, available: available);
                  cubit.updateSettings(reviewPosts: value);
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ConditionalBuilder(
              condition: state is GetSettingsSuccessState,
              builder: (context) => SingleChildScrollView(
                child: Column(
                  children: [
                    IntlPhoneField(
                      controller: phoneController,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      initialCountryCode: 'EG',
                      onChanged: (data) {
                        phone = data.completeNumber;
                      },
                    ),
                    Row(
                      children: [
                        const Text(
                          'Review Posts',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
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
                    Row(
                      children: [
                        const Text(
                          'Available',
                          style: TextStyle(
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
                  ],
                ),
              ),
              fallback: (conext) => const CircularProgressIndicator(),
            )),
          ),
        );
      },
    );
  }
}
