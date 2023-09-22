import 'package:admin_alex_uni/cubit/app_cubit.dart';
import 'package:admin_alex_uni/cubit/app_states.dart';
import 'package:admin_alex_uni/reusable_widgets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;

class AddUniversityScreen extends StatefulWidget {
  AddUniversityScreen({super.key});

  @override
  State<AddUniversityScreen> createState() => _AddUniversityScreenState();
}

class _AddUniversityScreenState extends State<AddUniversityScreen> {
  TextEditingController nameController = TextEditingController();
  bool error = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.15,
                    backgroundColor: cubit.image == null
                        ? Colors.grey[350]
                        : Theme.of(context).scaffoldBackgroundColor,
                    child: cubit.image == null
                        ? IconButton(
                      onPressed: () {
                        cubit.pickImage();
                      },
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.black,
                        size: MediaQuery.of(context).size.width * 0.1,
                      ),
                    )
                        : Image.file(
                      cubit.image!,
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (cubit.image == null)
                    TextButton(
                      onPressed: () {
                        cubit.pickImage();
                      },
                      child: Text(
                        'Pick Image',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  if (cubit.image != null)
                    TextButton(
                      onPressed: () {
                        cubit.pickImage();
                      },
                      child: Text(
                        'Change Image',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'University Name',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  reusableTextFormField(
                    label: 'University Name',
                    onTap: () {},
                    controller: nameController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if(error)
                    Text(
                      'Select Image and Enter University Name',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                      ),
                    ),
                  if(error)
                    SizedBox(
                      height: 10.0,
                    ),
                  ConditionalBuilder(
                    condition: state is! CreateUniversityLoadingState,
                    builder: (context) => Row(
                      children: [
                        Expanded(
                          child: reusableElevatedButton(
                            label: 'Save',
                            function: () {
                              if (cubit.image != null && nameController.text.isNotEmpty) {
                                setState(() {
                                  error = false;
                                });
                                cubit.uploadImage().then((value) {
                                  cubit.createUniversity(
                                    name: nameController.text,
                                  );
                                });
                              } else {
                                setState(() {
                                  error = true;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: reusableElevatedButton(
                            label: 'Cancel',
                            backColor: Colors.white70,
                            textColor: Colors.blue,
                            function: () {
                              setState(() {
                                cubit.image = null;
                                nameController.clear();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    fallback: (context) => Center(
                      child: CircularProgressIndicator(),
                    ),
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
