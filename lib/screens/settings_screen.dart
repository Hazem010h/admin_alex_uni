import 'package:admin_alex_uni/cubit/app_cubit.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  TextEditingController phoneController = TextEditingController();
  String? phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController.text = AppCubit.get(context).adminModel!.phone!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is UpdateUserDataSuccessState){
          Navigator.pop(context);
        }
      },
      builder: (context,state){

        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Setting Screen'),
            actions: [
              IconButton(
                onPressed: () {
                  cubit.updateUserData(phone: phone!);
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          body: Center(
            child:SingleChildScrollView(
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

                      phone = data.completeNumber ;



                    },
                  ),
                ],
              ),
            )
          ),
        );
      },
    );
  }
}
